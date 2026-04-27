#!/usr/bin/env bash
# setup_outputs.sh — scaffold the output directory structure for a brand workspace
#
# Usage:
#   bash scripts/setup_outputs.sh [brand-slug]
#
# Examples:
#   bash scripts/setup_outputs.sh acmeco
#   bash scripts/setup_outputs.sh mystartup
#
# If no brand slug is given, creates the structure in the current directory.

set -e

BRAND="${1:-}"
BASE="${BRAND:+${BRAND}/}outputs"

echo "Creating output directories under: ${BASE}/"

mkdir -p "${BASE}/blogs/images"
mkdir -p "${BASE}/social/linkedin/images"
mkdir -p "${BASE}/social/twitter/images"
mkdir -p "${BASE}/social/instagram/images"
mkdir -p "${BASE}/social/facebook/images"
mkdir -p "${BASE}/email/newsletter"
mkdir -p "${BASE}/email/campaign"
mkdir -p "${BASE}/email/sequences"
mkdir -p "${BASE}/presentations/art"
mkdir -p "${BASE}/research"
mkdir -p "${BASE}/briefs"

# Create the content registry CSV if it doesn't exist
REGISTRY="${BASE}/CONTENT-REGISTRY.csv"
if [ ! -f "$REGISTRY" ]; then
  echo "date,type,slug,title,status,file_path" > "$REGISTRY"
  echo "Created: ${REGISTRY}"
fi

# Create the content plan CSV if it doesn't exist
PLAN="${BASE}/CONTENT-PLANNED.csv"
if [ ! -f "$PLAN" ]; then
  echo "date_planned,type,slug,topic,assigned_to,notes" > "$PLAN"
  echo "Created: ${PLAN}"
fi

echo ""
echo "Output structure ready at: ${BASE}/"
echo ""
echo "Status flow:"
echo "  draft → qc-failed → ready-for-review → scheduled → published"
echo "  (only humans set 'scheduled' or 'published')"
