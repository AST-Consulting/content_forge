# brandforge

> AI-powered brand content operating system for any brand — blogs, LinkedIn, Twitter/X,
> Instagram, Facebook, email sequences, PPTX decks, XLSX trackers, and a full
> multi-channel content pipeline.

## What it does

- **Brand auto-discovery** — 6 questions → web crawl → voice URL analysis → auto-drafted
  brand config, ready for your review. No manual forms.
- **8-stage content pipeline** — Brief → Framework → Draft → Fact-check → AI SEO pass →
  Copy audit → Channel adaptation → Publish package
- **Multi-channel** — Blog, LinkedIn, Twitter/X thread, Instagram carousel, Facebook,
  email newsletter, email sequence
- **Copywriting frameworks** — AIDA, PAS, BAB, LEMA, 4-Point, AIDA+R — auto-selected
  per content type
- **AI SEO pass** — Structures content for citation by ChatGPT, Perplexity, Google AI
  Overviews: definition blocks, FAQ items, stat+source rows, summary boxes
- **AI humanizer** — Detect → Humanize → Voice inject — removes AI tells and injects
  brand voice
- **Deck system** — PPTX via pptxgenjs, XLSX via openpyxl+pandas, generative art via p5.js
- **Image generation** — Google Gemini via nanobanana MCP (optional)
- **Content registry** — CSV log of all outputs with duplicate detection
- **Multi-brand** — Clone, sync, and manage multiple brand workspaces

## Install

```bash
# Global — available across all your projects
npx skills add ast-consulting/brandforge -g

# Project — committed to your repo, shared with your team
npx skills add ast-consulting/brandforge
```

**Manual install (git clone):**

```bash
# Global
git clone https://github.com/ast-consulting/brandforge \
  ~/.claude/skills/brandforge

# Project-local
git clone https://github.com/ast-consulting/brandforge \
  .claude/skills/brandforge
```

## Compatible with

Claude Code · Cursor · GitHub Copilot · Codex CLI · Gemini CLI · Windsurf · Roo Code

## Usage

Just describe what you want in natural language:

```
"Write a blog post for [brand] about [topic]"
"Create a LinkedIn post for [brand] about [topic]"
"Run full content pipeline for [brand] on [topic]"
"Set up a new brand workspace for [name]"
"Make this [brand] copy sound human: [paste]"
"Create a 3-email nurture sequence for [brand] targeting [goal]"
"Build an investor deck for [brand]"
"SEO audit [brand] content on [topic]"
```

## File structure

```
brandforge/
├── SKILL.md                        # Main skill — brand config, pipeline, routing, QC
├── README.md                       # This file
├── LICENSE                         # MIT
├── evals/
│   └── evals.json                  # 3 test cases: LinkedIn post, new brand, blog plan
├── scripts/
│   ├── setup_outputs.sh            # Scaffold output directory structure for a brand
│   ├── setup_nanobanana.sh         # Full nanobanana MCP install: uv, .env, .mcp.json, permissions
│   └── overlay-logo.sh             # ffmpeg logo compositor — adds brand logo to any generated image
└── references/
    ├── brand-config.md             # Full brand interview + web crawl + auto-draft protocol
    ├── content-pipeline.md         # Deep 8-stage pipeline with per-stage instructions
    ├── social-playbooks.md         # LinkedIn, Twitter/X, Instagram, Facebook formulas
    ├── email-playbooks.md          # Newsletter, campaign, drip sequence templates
    ├── deck-system.md              # pptxgenjs API, XLSX patterns, p5.js generative art
    ├── agent-architecture.md       # 3-tier agent orchestration setup
    └── image-generation.md        # nanobanana MCP install, Gemini API key, troubleshooting
```

## Optional: Image generation (nanobanana MCP)

Hero images, social banners, and Instagram carousel slides are generated via Google Gemini
through the nanobanana MCP server.

**One-command setup:**

```bash
bash scripts/setup_nanobanana.sh
```

This handles everything: installs `uv`, saves your `GEMINI_API_KEY` to `.env`,
creates `.mcp.json`, and updates `.claude/settings.json` with the right permissions.

Or pass the key non-interactively:

```bash
bash scripts/setup_nanobanana.sh --key AIzaSy...yourkey
```

**After setup — start Claude Code:**

```bash
set -a && source .env && set +a   # export key in current terminal
claude                             # nanobanana auto-starts
```

See `references/image-generation.md` for the full guide and troubleshooting.

## Logo overlay (no extra API cost)

After generating images, stamp your brand logo with ffmpeg — no second Gemini call:

```bash
# Auto-discovers logo in .claude/skills/{brand}-brand/assets/
bash scripts/overlay-logo.sh outputs/social/linkedin/post.png outputs/social/linkedin/post-branded.png

# Specify logo manually
bash scripts/overlay-logo.sh input.png output.png --logo .claude/skills/mybrand-brand/assets/logo.png

# Options: position (bl/br/tl/tr), width, margin
bash scripts/overlay-logo.sh input.png output.png --logo logo.avif --position br --width 120 --margin 20
```

**Requires:** `ffmpeg` — `brew install ffmpeg` (macOS) · `apt install ffmpeg` (Linux)

The skill works fully without nanobanana — it writes `[IMAGE NEEDED: description]`
placeholders and continues.

## Multi-brand support

Each brand gets its own workspace cloned from a master template:

```bash
cp -r [existing-brand]/ [new-brand]/
# Update all brand-specific values in: [new-brand]/.claude/skills/[brand]-brand/SKILL.md
# Replace: brand name, tagline, colors, voice, proof points, services, URLs
```

Brand configs live at `.claude/skills/{brand}-brand/SKILL.md` and are auto-loaded at
the start of every content task.

## License

MIT — see [LICENSE](LICENSE)
