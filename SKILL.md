---
name: brandforge
description: >
  AI-powered brand content operating system. Use this skill whenever the user asks to
  create ANY brand content — blog posts, LinkedIn posts, Twitter/X threads, Instagram
  carousels, Facebook posts, email newsletters, email sequences, PPTX decks, XLSX
  spreadsheets, or a full multi-channel content pipeline. Also use when the user wants
  to set up a new brand workspace, clone a brand, audit content for brand voice, humanize
  AI writing, run SEO or competitor research, or get AI search visibility. Triggers on:
  "write a blog", "LinkedIn post", "Twitter thread", "Instagram carousel", "Facebook post",
  "email newsletter", "email sequence", "build a deck", "content pipeline", "new brand setup",
  "humanize this", "SEO research", "make this sound human", or ANY request to produce
  marketing/content for a named or unnamed brand. When in doubt, use this skill — it handles
  every stage from brand discovery to publish-ready output.
license: MIT
compatibility: >
  Works with any agent platform (Claude Code, Cursor, Copilot, Codex CLI).
  Optional: nanobanana MCP server (requires uvx + GEMINI_API_KEY) for AI image generation.
  See references/image-generation.md for setup.
allowed-tools: Read Write Bash WebSearch WebFetch Grep Glob
metadata:
  author: ast-consulting
  version: "1.1.0"
---

# Brandforge

Complete AI content operating system: brand intelligence → content production → QC →
multi-channel delivery. Works for any brand. Brand config always loads first.

---

## Gotchas

These are the non-obvious things that go wrong without this skill:

- **Never start writing before showing an execution plan.** Always show plan → wait for "go" → then create files. Skipping this is the most common failure mode.
- **Brand config must load before any content.** Check for `.claude/skills/{brand}-brand/SKILL.md` first. Without brand colors/voice/proof points, the output will be generic.
- **Reference paths are relative to this skill's directory.** When told to read `references/X.md`, use the path relative to this file's location (the agent knows the skill's `fullPath`).
- **Duplicate detection before writing.** Always scan `outputs/CONTENT-REGISTRY.csv` for fuzzy title matches before creating any new content file.
- **Email links go in first comment on Facebook**, not the post body — reduces reach penalty.
- **nanobanana requires a running MCP server.** If `uvx --version` or `$GEMINI_API_KEY` fails, run `bash scripts/setup_nanobanana.sh` or write `[IMAGE NEEDED: description]` as a placeholder — never block the content workflow.
- **Logo overlay runs AFTER image generation, not during.** Use `scripts/overlay-logo.sh` with ffmpeg — it auto-discovers the brand logo, costs zero API credits, and handles AVIF (2-stream alphamerge), PNG, and chromakey transparently.
- **Agents never set status `scheduled` or `published`** — those are human-only actions in the registry.

---

## 0 — Brand Config (Always First)

**Config exists** → read `.claude/skills/{brand}-brand/SKILL.md` → go to §1.

**No config** → run the Brand Setup Interview. Do the research; never ask the user to fill a form.

### Setup Flow (6 steps)

```
STEP 1   — Ask all 6 questions in ONE message (not one at a time)
STEP 1.5 — If voice URLs provided: crawl them for tone analysis
STEP 2   — WebFetch: homepage + /about + /services
STEP 3   — WebSearch: brand reviews, press, competitors
STEP 4   — Draft brand config → present with ✅/🟡/⬜ confidence labels
STEP 5   — Save to .claude/skills/{brand}-brand/SKILL.md on user approval
```

### The 6 Questions (send all at once)

```
1. Brand name?
2. Website URL?
3. One sentence: what does the brand do and for whom?
4. What should customers feel after interacting with the brand?
5. Voice URLs (optional): 1-3 links to your existing content for tone analysis.
6. One case study / proof point (optional): a real customer result with metrics.
```

**Full interview + crawl + draft protocol**: `references/brand-config.md`

**Minimum before any content task:**

| Field | Example |
|-------|---------|
| Brand name | AcmeCo |
| Tagline | Your Brand's Tagline Here |
| Primary color | #1A1A2E Navy |
| Voice adjectives | Direct, expert, human, no jargon |
| Top proof points | 10,000+ customers · delivered in 24 hours |
| Top 3 services | Service A · Service B · Service C |

---

## 1 — Routing

| Request | Action |
|---------|--------|
| Blog, LinkedIn, Twitter, Instagram, Facebook, email, content calendar, pipeline | → §2 |
| PPTX deck, XLSX, data viz, slides | → §3 |
| SEO audit, competitor research, keyword research, AI search visibility | → §4 |
| Humanize copy, fix brand voice, copy audit | → §5 |
| New brand or workspace clone | → §6 |

**Rule: always show EXECUTION PLAN → wait for "go" → then create files.**

---

## 2 — Content Production

### 2.1 — Execution Plan (required before every job)

```
EXECUTION PLAN
==============
Brand      : [brand name]
Request    : [verbatim]
Topic      : [inferred or confirmed]
Framework  : [chosen — see §2.3]

Deliverables:
  1. [type] × [count] | depth: full/standard/draft | image: yes/no
  2. ...

Files to create:
  outputs/briefs/[slug].md
  outputs/blogs/YYYY-MM-DD_[slug].md
  outputs/social/[platform]/[slug].md
  outputs/email/[type]/YYYY-MM-DD_[slug].md

Reply "go" to execute, or tell me what to change.
```

### 2.2 — Deliverable Types

| Type | Depth | Image |
|------|-------|-------|
| `blog` | full: brief → draft → fact-check → QC → retry → hero | 16:9 |
| `linkedin_post` | standard: write → QC once | 1200×628 |
| `twitter_post` | standard | 1200×675 card |
| `twitter_thread` | standard | 1200×675 tweet 1 |
| `instagram_post` | standard | 1080×1080 |
| `instagram_carousel` | standard: 7 slides | 1080×1080 × 7 |
| `facebook_post` | standard | 1200×630 |
| `email_newsletter` | standard | none |
| `email_campaign` | standard | none |
| `email_sequence` | full: 3–7 email series | none |
| `content_plan` | outline only | none |

**Full pipeline** (only if user says "full pipeline" or "everything"):
blog + linkedin + twitter thread + instagram carousel, same topic.

### 2.3 — Copywriting Framework (pick before writing)

Don't ask the user — choose the right one, name it in the plan.

| Framework | Best for |
|-----------|---------|
| **AIDA** | Launch posts, announcements, landing pages |
| **PAS** | Social posts, re-engagement, problem-aware readers |
| **BAB** | Case studies, testimonial-driven content |
| **LEMA** | Thought leadership, long educational blogs |
| **4-Point** | How-to guides, long-form articles |
| **AIDA+R** | Finance, health, high-trust topics (add Reassurance block) |

### 2.4 — The 8-Stage Pipeline

For `full` depth run all 8. For `standard` run Stages 1, 3, 6, 8 only.

```
STAGE 1 → Brief & Research
  Search top 5 pages for target keyword. Find the gap.
  Output: outputs/briefs/[slug].md

STAGE 2 → Framework & Outline
  Apply §2.3 framework. Agree H1/H2 structure before writing.

STAGE 3 → Draft
  Write to the outline. Every H2: one idea, one proof, one transition.

STAGE 4 → Fact Check
  Mark: ✅ verified / ⚠️ needs source / ❌ remove / 🔵 internal data
  Remove or caveat everything marked ❌.

STAGE 5 → AI SEO Pass
  Add: definition block near top, 3-5 FAQ items, stat+source rows [stat — source, year]
  Check: H1 has primary keyword, keyword in first 100 words, 2+ H2s with related terms.
  Goal: citable by ChatGPT, Perplexity, Google AI Overviews.

STAGE 6 → Copy Audit (7 Sweeps)
  1. Clarity — every sentence understandable to target reader?
  2. Brand voice — sounds like the brand, not generic AI?
  3. Proof points — at least 1 proof per major section?
  4. Flow — intro delivers on headline? each section earns its place?
  5. Readability — avg sentence 15-20 words? no paragraph > 4 sentences?
  6. SEO — keyword density natural? header hierarchy correct? meta present?
  7. Human check — would the target reader find this useful and credible?

STAGE 7 → Channel Adaptation
  Derive all social/email variants from the final blog.
  Never copy-paste — rewrite for each platform voice and format.
  Platform formulas: references/social-playbooks.md | references/email-playbooks.md

STAGE 8 → Publish Package
  Output: outputs/blogs/YYYY-MM-DD_[slug].md
  Meta title (50-60 chars), meta description (150-160 chars), slug
  Log row to outputs/CONTENT-REGISTRY.csv
  Delivery report: files created, what needs human action
```

Deep stage-by-stage guide: `references/content-pipeline.md`

### 2.5 — AI Humanizer (3 modes)

| Mode | What it does |
|------|-------------|
| **Detect** | Audit — flag AI tells, don't fix yet |
| **Humanize** | Strip patterns, vary rhythm, replace vague with specific |
| **Voice inject** | Apply brand personality: opinions, direct address, rhythm signature |

**AI tells to always eliminate:** "delve", "leverage", "robust", "furthermore", "it is
important to note", "the X landscape", identical paragraph structure, 0 specificity.

### 2.6 — QC Rules

- `full` → QC + 1 retry on fail → escalate to human
- `standard` → QC once + 1 revision → escalate
- `draft` → skip QC (only if user explicitly requests)

### 2.7 — Content Registry

Log all outputs to `outputs/CONTENT-REGISTRY.csv`:

| date | type | slug | title | status | file_path |

Status flow: `draft → qc-failed → ready-for-review → scheduled → published`
(Only humans set `scheduled` or `published`.)

**Before any new piece:** scan registry for fuzzy title match. If match found, stop and
report — don't write until user decides.

---

## 3 — Deck System

| Request | Tool | Output |
|---------|------|--------|
| Investor / campaign / review deck | pptxgenjs (Node.js) | `.pptx` |
| Data table / tracker / dashboard | openpyxl + pandas | `.xlsx` |
| Generative art backdrop | p5.js seeded sketch | PNG / HTML |

**Workflow:** Clarify type + audience + slide count → propose outline → confirm → build →
QA → deliver to `outputs/presentations/YYYY-MM-DD_[name]_v[N].pptx`

**Design defaults:** dark title slide → light content slides → dark CTA close slide.
Brand primary for headers, accent for CTAs and stats.

Full pptxgenjs API, templates, XLSX patterns: `references/deck-system.md`

---

## 4 — Research

**SEO Audit:** Crawl target URL → extract headings, word count, meta → map keyword intent
→ check keyword placement + internal links (≥2 to brand service pages)
→ output: `outputs/research/YYYY-MM-DD_seo-audit_[topic].md`

**Competitor Gap:** Top 5 ranking pages → extract headings, angles, proof points → find
the gap (what none of the top 5 cover = the brand's unique angle)
→ output: `outputs/research/YYYY-MM-DD_competitor-analysis_[topic].md`

**AI Search Visibility** — to get cited by ChatGPT / Perplexity / AI Overviews:
- Definition block near top
- 3-5 FAQ items with direct answers
- `[stat — source, year]` format for all data points
- Comparison table if comparing options
- TL;DR summary box (AI Overviews pull from these)
- H2s phrased as questions, not just labels

---

## 5 — Content Quality (standalone)

If user pastes copy and asks to audit or humanize:

1. Run all 7 copy audit sweeps (§2.4 Stage 6)
2. Run AI humanizer: Detect → Humanize → Voice inject
3. Return annotated version with issues flagged, then clean final version
4. Do NOT change the core message — only enhance clarity and voice

---

## 6 — Multi-Brand Setup

**New brand:** run `scripts/setup_outputs.sh [brand-slug]` first to scaffold directories.

```bash
# Clone from master template
cp -r [existing-brand]/ [new-brand]/
# Then manually update all brand-specific values in the new config:
# Update: [new-brand]/.claude/skills/[brand]-brand/SKILL.md
# Replace: brand name, tagline, colors, voice, proof points, services, URLs
```

**Output directory structure per brand:**
```
outputs/
├── CONTENT-REGISTRY.csv
├── blogs/                  (YYYY-MM-DD_[slug].md + images/)
├── social/linkedin|twitter|instagram|facebook/
├── email/newsletter|campaign|sequences/
├── presentations/
│   └── art/                (p5.js generative art PNGs)
├── research/
└── briefs/
```

---

## 7 — Image Generation

Check before any image task:

```bash
uvx --version        # must print a version
echo $GEMINI_API_KEY # must not be empty
```

If either fails → run the setup script: `bash scripts/setup_nanobanana.sh`
Or load the manual guide: `references/image-generation.md`

**Without nanobanana:** write `[IMAGE NEEDED: description]` as placeholder — never block content.

**Logo overlay** (after image generation — no extra API call):

```bash
bash scripts/overlay-logo.sh INPUT.png OUTPUT.png
# Auto-discovers brand logo in .claude/skills/{brand}-brand/assets/
# Options: --position bl|br|tl|tr  --width 80  --margin 16  --logo path/to/logo.avif
# Requires: ffmpeg (brew install ffmpeg / apt install ffmpeg)
```

| Deliverable | Image | Dimensions |
|------------|-------|-----------|
| blog | Hero after QC | 16:9 |
| linkedin_post | Banner after copy | 1200×628 |
| instagram_carousel | 7 slides | 1080×1080 each |

To skip images: user says "no images" or "text only".

---

## References

Load only what you need — not all at once:

| File | Load when |
|------|-----------|
| `references/brand-config.md` | Setting up a new brand (full interview + crawl + draft protocol) |
| `references/content-pipeline.md` | Deep per-stage instructions for the 8-stage pipeline |
| `references/social-playbooks.md` | LinkedIn / Twitter / Instagram / Facebook channel formulas |
| `references/email-playbooks.md` | Newsletter, campaign, drip sequence templates |
| `references/deck-system.md` | pptxgenjs API, XLSX patterns, p5.js generative art |
| `references/agent-architecture.md` | 3-tier agent orchestration setup |
| `references/image-generation.md` | nanobanana MCP install, API key, troubleshooting |

---

## Quick Reference

| Goal | Say this |
|------|---------|
| Full pipeline | "Run full content pipeline for [brand] on [topic]" |
| Blog | "Write a [brand] blog about [topic]" |
| LinkedIn | "Draft a [brand] LinkedIn post about [topic]" |
| Twitter thread | "Write a [brand] Twitter thread about [topic]" |
| Instagram carousel | "Create a [brand] Instagram carousel about [topic]" |
| Facebook | "Write a [brand] Facebook post about [topic]" |
| Email newsletter | "Write a [brand] email newsletter about [topic]" |
| Email sequence | "Create a [N]-email [brand] nurture sequence for [goal]" |
| Deck | "Create a [investor/campaign/review] deck for [brand]" |
| SEO + AI search | "SEO audit [brand] content on [topic]" |
| Humanize | "Make this [brand] copy sound human: [paste]" |
| New brand | "Set up a new brand workspace for [name]" |
