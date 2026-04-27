# Image Generation — nanobanana MCP Setup & Usage

This skill uses the **nanobanana MCP server** for AI image generation via Google Gemini.
It's optional — text-only content works without it — but required for hero images, social
banners, and Instagram carousel slides.

---

## What Is nanobanana?

[nanobanana-mcp-server](https://github.com/zhongweili/nanobanana-mcp-server) is an open-source
MCP (Model Context Protocol) server that gives Claude access to Google Gemini's image
generation API. Once installed, Claude can call `mcp__nanobanana__generate_image` directly
during a content session — no extra prompting needed.

**What it generates:**
- Blog hero images (16:9)
- LinkedIn banners (1200×628)
- Twitter/X cards (1200×675)
- Instagram posts (1080×1080)
- Instagram carousel slides (7× 1080×1080 per carousel)
- PPTX slide backgrounds and generative art

---

## Prerequisites

| Requirement | Why | Install |
|-------------|-----|---------|
| **uv / uvx** | Runs nanobanana without a global npm/pip install | `curl -LsSf https://astral.sh/uv/install.sh \| sh` |
| **Gemini API key** | Google AI image generation is billed per image | See §1 below |
| **Claude Code** | MCP servers only work in Claude Code (not Claude.ai chat) | [docs.anthropic.com](https://docs.anthropic.com/en/docs/claude-code) |

---

## Step 1 — Get a Gemini API Key (Free Tier Available)

1. Go to [aistudio.google.com/apikey](https://aistudio.google.com/apikey)
2. Sign in with your Google account
3. Click **Create API key** → copy the key (starts with `AIza...`)
4. **Free tier**: 15 requests/minute, 1500 requests/day — enough for most content workflows
5. Keep the key private — never commit it to git

---

## Step 2 — Create `.env` in Your Brand Workspace

```bash
# In your brand workspace root (e.g. myproject/acmeco/)
cp .env.example .env
```

Edit `.env` and set:

```bash
GEMINI_API_KEY=AIzaSy...your_key_here
```

Your `.gitignore` should already exclude `.env`. If not, add it:

```bash
echo ".env" >> .gitignore
echo ".env.*" >> .gitignore
```

---

## Step 3 — Add `.mcp.json` to Your Brand Workspace Root

Create (or update) `.mcp.json` in the same folder as your `CLAUDE.md`:

```json
{
  "mcpServers": {
    "nanobanana": {
      "command": "uvx",
      "args": ["nanobanana-mcp-server@latest"],
      "env": {
        "GEMINI_API_KEY": "${GEMINI_API_KEY}"
      }
    }
  }
}
```

This tells Claude Code to launch the nanobanana server automatically when the project opens.

---

## Step 4 — Enable MCP in `.claude/settings.json`

Add nanobanana to your project settings so Claude has permission to call it:

```json
{
  "permissions": {
    "allow": [
      "mcp__nanobanana__generate_image",
      "mcp__nanobanana__upload_file",
      "mcp__nanobanana__show_output_stats"
    ]
  }
}
```

---

## Step 5 — Load the API Key Before Starting Claude Code

The API key must be exported in the **same terminal session** that launches Claude Code:

```bash
# macOS / Linux
set -a && source .env && set +a

# Then launch Claude Code in that terminal
claude
```

On **Windows (PowerShell)**:
```powershell
$env:GEMINI_API_KEY = "AIzaSy...your_key_here"
claude
```

> The first image request may take 30–60 seconds while `uvx` downloads the server.
> Subsequent calls in the same session are fast (2–4 seconds per image).

---

## Verify It's Working

Ask Claude in a session:

```
Generate a test image: a simple blue square, save to outputs/test.png
```

If you see `outputs/test.png` created → nanobanana is working correctly.

If you see an error → check the troubleshooting section below.

---

## How This Skill Uses nanobanana

When `image: yes` is set for a deliverable (which is the default unless you say "no images"),
Claude calls `mcp__nanobanana__generate_image` automatically at the right stage:

| Deliverable | When image is generated | Default dimensions |
|------------|------------------------|--------------------|
| `blog` | After blog is QC-approved | 16:9 (hero image) |
| `linkedin_post` | After post copy is written | 1200×628px |
| `twitter_post` / `twitter_thread` | After copy is written | 1200×675px |
| `instagram_post` | After copy is written | 1080×1080px |
| `instagram_carousel` | Per slide, 7 total | 1080×1080px each |

### The MCP Tool Call (what Claude does internally)

```json
{
  "tool": "mcp__nanobanana__generate_image",
  "arguments": {
    "prompt": "Clean modern Instagram carousel cover slide. Dark navy blue (#0A1F44) background. Large bold white Poppins headline text: 'Sell your car in 2 hours'. Accent orange (#F7941D) underline on key word. 4K. 1080x1080px square.",
    "model_tier": "pro",
    "aspect_ratio": "1:1",
    "resolution": "high",
    "output_path": "outputs/social/instagram/2026-04-22_sell-car-tips/slide-01-cover.png",
    "n": 1
  }
}
```

### Model Tier Guide

| Tier | Speed | Quality | Use for |
|------|-------|---------|---------|
| `flash` | ~1s | Draft quality | Quick mockups, testing prompts |
| `nb2` | 2–4s | Production quality | All standard content images |
| `pro` | 5–10s | Highest quality | Cover slides, hero images, key visuals |

Default is `nb2` for everything. Use `pro` only for the cover/hero of each piece.

---

## Logo Overlay (Save API Cost)

For adding your brand logo to generated images, use the local overlay script instead of
making another API call. This saves ~1 Gemini credit per image.

```bash
# Add logo to a generated slide
bash scripts/overlay-logo.sh path/to/generated.png path/to/output.png
```

**Requires:** `ffmpeg` installed (`brew install ffmpeg` on macOS, `apt install ffmpeg` on Linux)

The script uses `ffmpeg` to alpha-composite the logo at the correct position.
Logo file: `.claude/skills/[brand]-brand/assets/[brand]-logo-light.avif` (or `.png`)

---

## What Happens Without nanobanana

If nanobanana is not installed or the API key is missing, the skill degrades gracefully:

- Content (blogs, social copy, decks) is still produced fully — no images
- Claude writes `[IMAGE NEEDED: description of what to generate]` as a placeholder in the output file
- The delivery report will note: `Images: skipped (nanobanana not available)`
- You can generate images later by running the image step manually

**To skip images intentionally**, add "no images" or "text only" to your request:
```
Write a [Brand] blog post about [topic] — text only, no images
```

---

## Troubleshooting

| Problem | Likely cause | Fix |
|---------|-------------|-----|
| `uvx: command not found` | uv is not installed | `curl -LsSf https://astral.sh/uv/install.sh \| sh` then restart terminal |
| `GEMINI_API_KEY not set` | `.env` not sourced | Run `set -a && source .env && set +a` in the same terminal before `claude` |
| `API quota exceeded` | Free tier 1500/day limit hit | Wait 24h or upgrade Google AI Studio plan |
| First image takes 60s | uvx downloading server | Normal — only happens once per machine |
| Images look wrong / off-brand | Prompt too vague | Read the prompt templates in `social-playbooks.md` — they're tuned for brand accuracy |
| `mcp__nanobanana__generate_image` not found | MCP not enabled | Check `.mcp.json` exists + `GEMINI_API_KEY` is exported + Claude Code restarted |
| Logo overlay script fails | ffmpeg not installed | `brew install ffmpeg` (macOS) or `apt install ffmpeg` (Linux) |

---

## Quick-Start Checklist

```
□ uv installed (uvx --version works in terminal)
□ Gemini API key created at aistudio.google.com/apikey
□ .env file created with GEMINI_API_KEY=...
□ .env added to .gitignore
□ .mcp.json created with nanobanana config
□ .claude/settings.json updated with mcp permissions
□ API key exported: set -a && source .env && set +a
□ Claude Code opened from same terminal
□ Test image generated successfully
```

Once all boxes are checked, every content request with `image: yes` (the default) will
automatically generate brand-aligned images at the right stage of the pipeline.
