#!/usr/bin/env bash
# overlay-logo.sh — composite a brand logo onto a generated image using ffmpeg.
#
# Saves an API call (no second Gemini request needed for branding).
# Handles AVIF logos with alpha (2-stream alphamerge), PNG with alpha,
# and black-plate logos via chromakey — auto-detected by default.
#
# Usage:
#   scripts/overlay-logo.sh INPUT.png OUTPUT.png --logo path/to/logo.avif
#   scripts/overlay-logo.sh INPUT.png OUTPUT.png --logo path/to/logo.png --position br
#   scripts/overlay-logo.sh INPUT.png OUTPUT.png --logo path/to/logo.png --width 140 --margin 24
#
# Options:
#   --logo PATH          Path to logo file (required: .avif, .png, .webp, .svg)
#   --width N            Logo width in pixels (default: 80)
#   --margin N           Edge margin in pixels (default: 16)
#   --position CORNER    bl = bottom-left (default), br = bottom-right,
#                        tl = top-left,    tr = top-right
#   --alphamerge         Force alphamerge mode (AVIF 2-stream)
#   --chromakey          Force chromakey black removal
#   --no-chromakey       Force no background removal (PNG with built-in alpha)
#   --chromakey-sim N    Chromakey similarity threshold (default: 0.06)
#   --chromakey-blend N  Chromakey blend threshold (default: 0.12)
#
# Brand logo conventions (any of these work):
#   .claude/skills/{brand}-brand/assets/{brand}-logo-light.avif
#   .claude/skills/{brand}-brand/assets/{brand}-logo-light.png
#   assets/{brand}-logo-light.avif
#
# Requires:
#   ffmpeg  →  brew install ffmpeg   (macOS)
#              apt install ffmpeg    (Ubuntu/Debian)
#              choco install ffmpeg  (Windows)

set -euo pipefail

# ── Colour output ─────────────────────────────────────────────────────────────
GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'; RESET='\033[0m'
success() { echo -e "${GREEN}ok:${RESET} $*"; }
error()   { echo -e "${RED}error:${RESET} $*" >&2; }
warn()    { echo -e "${YELLOW}warn:${RESET} $*"; }

# ── Defaults ──────────────────────────────────────────────────────────────────
WIDTH=80
MARGIN=16
POSITION="bl"
LOGO_PATH=""
LOGO_MODE="auto"   # auto | alphamerge | chromakey | first
CHROMA_SIM="${CHROMA_SIM:-0.06}"
CHROMA_BLEND="${CHROMA_BLEND:-0.12}"

# ── Helpers ───────────────────────────────────────────────────────────────────
count_video_streams() {
  ffprobe -v error -select_streams v \
    -show_entries stream=index -of compact=p=0:nk=1 "$1" 2>/dev/null \
    | tr '|' '\n' | grep -c . || echo 0
}

usage() {
  grep '^#' "$0" | head -n 40 | sed 's/^# \{0,1\}//'
  exit 0
}

# ── Parse arguments ───────────────────────────────────────────────────────────
POSITIONAL=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)         usage ;;
    --width)           WIDTH="${2:?}";         shift 2 ;;
    --margin)          MARGIN="${2:?}";        shift 2 ;;
    --position)        POSITION="${2:?}";      shift 2 ;;
    --logo)            LOGO_PATH="${2:?}";     shift 2 ;;
    --alphamerge)      LOGO_MODE="alphamerge"; shift ;;
    --chromakey)       LOGO_MODE="chromakey";  shift ;;
    --no-chromakey)    LOGO_MODE="first";      shift ;;
    --chromakey-sim)   CHROMA_SIM="${2:?}";    shift 2 ;;
    --chromakey-blend) CHROMA_BLEND="${2:?}";  shift 2 ;;
    -*) error "Unknown option: $1"; exit 1 ;;
    *)  POSITIONAL+=("$1"); shift ;;
  esac
done

# ── Validation ────────────────────────────────────────────────────────────────
if ! command -v ffmpeg &>/dev/null; then
  error "ffmpeg not found in PATH"
  echo "  macOS:          brew install ffmpeg"
  echo "  Ubuntu/Debian:  sudo apt install ffmpeg"
  echo "  Windows:        choco install ffmpeg"
  exit 1
fi

if [[ ${#POSITIONAL[@]} -lt 2 ]]; then
  error "Missing required arguments: INPUT OUTPUT"
  echo "  Usage: $0 INPUT.png OUTPUT.png --logo path/to/logo.avif"
  exit 1
fi

INPUT="${POSITIONAL[0]}"
OUTPUT="${POSITIONAL[1]}"

if [[ ! -f "$INPUT" ]]; then
  error "Input file not found: $INPUT"
  exit 1
fi

# Auto-discover logo if not supplied
if [[ -z "$LOGO_PATH" ]]; then
  REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
  # Try common brand logo locations
  for candidate in \
    "${REPO_ROOT}/.claude/skills/"*"-brand/assets/"*"-logo-light.avif" \
    "${REPO_ROOT}/.claude/skills/"*"-brand/assets/"*"-logo-light.png" \
    "${REPO_ROOT}/assets/"*"-logo-light.avif" \
    "${REPO_ROOT}/assets/"*"-logo-light.png"
  do
    if [[ -f "$candidate" ]]; then
      LOGO_PATH="$candidate"
      warn "Auto-discovered logo: $LOGO_PATH"
      break
    fi
  done
fi

if [[ -z "$LOGO_PATH" ]]; then
  error "No logo found. Pass --logo path/to/logo.avif"
  echo ""
  echo "  Expected locations:"
  echo "    .claude/skills/{brand}-brand/assets/{brand}-logo-light.avif"
  echo "    .claude/skills/{brand}-brand/assets/{brand}-logo-light.png"
  exit 1
fi

if [[ ! -f "$LOGO_PATH" ]]; then
  error "Logo file not found: $LOGO_PATH"
  exit 1
fi

case "$POSITION" in
  bl|br|tl|tr) ;;
  *)
    error "Invalid --position '$POSITION'. Must be: bl, br, tl, tr"
    exit 1 ;;
esac

# ── Detect logo stream count ───────────────────────────────────────────────────
NSTREAMS="$(count_video_streams "$LOGO_PATH")"

# ── Build logo prep filter ────────────────────────────────────────────────────
build_logo_prep() {
  local scale="scale=${WIDTH}:-1:flags=lanczos+accurate_rnd"
  case "$LOGO_MODE" in
    alphamerge)
      if [[ "$NSTREAMS" -lt 2 ]]; then
        error "--alphamerge requires 2+ video streams in the logo (found ${NSTREAMS})"
        exit 1
      fi
      echo "[1:0][1:1]alphamerge,format=rgba,${scale}[lg]"
      ;;
    chromakey)
      echo "[1:v]chromakey=0x000000:${CHROMA_SIM}:${CHROMA_BLEND},format=rgba,${scale}[lg]"
      ;;
    first)
      echo "[1:v]format=rgba,${scale}[lg]"
      ;;
    auto)
      if [[ "$NSTREAMS" -ge 2 ]]; then
        echo "[1:0][1:1]alphamerge,format=rgba,${scale}[lg]"
      else
        echo "[1:v]chromakey=0x000000:${CHROMA_SIM}:${CHROMA_BLEND},format=rgba,${scale}[lg]"
      fi
      ;;
    *)
      error "Invalid LOGO_MODE: $LOGO_MODE"
      exit 1 ;;
  esac
}

LOGO_PREP="$(build_logo_prep)"

# ── Position overlay ──────────────────────────────────────────────────────────
case "$POSITION" in
  bl) OVERLAY_XY="${MARGIN}:main_h-overlay_h-${MARGIN}" ;;
  br) OVERLAY_XY="main_w-overlay_w-${MARGIN}:main_h-overlay_h-${MARGIN}" ;;
  tl) OVERLAY_XY="${MARGIN}:${MARGIN}" ;;
  tr) OVERLAY_XY="main_w-overlay_w-${MARGIN}:${MARGIN}" ;;
esac

FILTER="${LOGO_PREP};[0:v][lg]overlay=${OVERLAY_XY}"

# ── Write to temp file, then atomic move ─────────────────────────────────────
OUT_DIR="$(dirname "$OUTPUT")"
OUT_BASE="$(basename "$OUTPUT")"
TMP_OUT="${OUT_DIR}/.${OUT_BASE}.tmp.$$.png"

mkdir -p "$OUT_DIR"
cleanup() { rm -f "${TMP_OUT}"; }
trap cleanup EXIT

ffmpeg -hide_banner -loglevel error -y \
  -i "$INPUT" \
  -i "$LOGO_PATH" \
  -filter_complex "$FILTER" \
  -frames:v 1 \
  "$TMP_OUT"

mv -f "$TMP_OUT" "$OUTPUT"
trap - EXIT

success "$OUTPUT  (logo: $(basename "$LOGO_PATH"), pos: $POSITION, width: ${WIDTH}px, streams: $NSTREAMS, mode: $LOGO_MODE)"
