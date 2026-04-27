# Agent Architecture

How to set up and run the full agent layer: orchestrator → managers → specialists.

---

## Overview

The agent system adds **plan-first execution** and **quality gates** to the content OS.
It has three tiers:

```
Tier 1: ORCHESTRATOR
  └─ Routes requests to the correct manager
  └─ Only works as main-thread agent (claude --agent [brand]-orchestrator)

Tier 2: MANAGERS  (content-manager, presentation-manager, research-manager)
  └─ Parse user request → show execution plan → execute on approval
  └─ Cannot spawn nested subagents — read specialist playbooks inline

Tier 3: SPECIALISTS  (blog-writer, social-writer, instagram-creator, deck-builder, ...)
  └─ Markdown playbooks under .claude/agents/
  └─ Executed inline by the manager (Read the file → follow instructions)
```

---

## Tier 1 — Orchestrator

### File

`.claude/agents/[brand]-orchestrator.md`

### Frontmatter

```yaml
---
name: [brand]-orchestrator
description: >
  CEO orchestrator for [Brand]'s AI content system. Routes all user requests to the correct
  manager — content-manager for blogs/social/carousels, presentation-manager for decks/data,
  research-manager for SEO/competitor work. Always load this first.
tools: Agent(content-manager, presentation-manager, research-manager), Read
---
```

### Routing Logic

| Request pattern | Route to |
|----------------|---------|
| Blog, LinkedIn, Twitter, Instagram, content plan, repurposing, images | `content-manager` |
| PPTX, XLSX, spreadsheet, tracker, slide design | `presentation-manager` |
| SEO audit, competitor analysis, keyword research, content gaps | `research-manager` |

### Critical Constraint

**The Agent tool only works when the orchestrator is the main-thread agent.**
```bash
claude --agent [brand]-orchestrator
```
If invoked as a `@`-mention subagent, the orchestrator **cannot** spawn managers — tell
the user to invoke the right manager directly: `@content-manager`, `@presentation-manager`, or `@research-manager`.

### Delegation Template (include in every manager invocation)

```
You are [Brand] [manager-name].

Always-plan mode:
  1. Parse the user request into a structured execution plan.
  2. Present the EXECUTION PLAN (deliverables, depth, images, files to create).
  3. STOP and wait for explicit approval ("go", "yes", "run it", "approved", "ok").
  4. Only after approval, execute exactly what was approved — nothing extra.

Do not run a hardcoded "full pipeline" unless the user explicitly requests one.
Only stop and report when: (a) plan awaits approval, (b) deliverables complete,
(c) duplicate detected, (d) content plan needs approval, (e) QC fails twice.

Brand context:
  Name: [Brand name]
  Tagline: [tagline]
  Colors: [primary hex] | [accent hex]
  Voice: [voice adjectives]
  Proof points: [proof point 1] · [proof point 2] · [proof point 3]
  Site: [brand url]

Registry: outputs/CONTENT-REGISTRY.csv (read before any content decisions)
Request: [full user request verbatim]
```

---

## Tier 2 — Managers

### content-manager

**File:** `.claude/agents/content-manager.md`

**Frontmatter:**
```yaml
---
name: content-manager
description: >
  Agentic Content Head for [Brand]. Parses any content request (blog, LinkedIn, Twitter,
  Instagram, content plan, or any mix), builds an execution plan for exactly what was asked,
  shows the plan, and runs it only on approval. No hardcoded pipelines.
tools: Read, Write, Edit, Bash, WebSearch, Grep, Glob
mcpServers:
  - nanobanana
---
```

**Execution flow:**
```
Step 0 → Parse intent → structured deliverable list
Step 1 → EXECUTION PLAN → stop, await "go"
Step 2 → Execute (per deliverable): route to specialist playbook → run QC → update registry
Step 3 → Delivery report
```

**Specialist playbook map:**
| Role | File |
|------|------|
| Content planning | `.claude/agents/content-planner.md` |
| Brief + duplicate check | `.claude/agents/content-brief-writer.md` |
| Blog (Markdown) | `.claude/agents/blog-writer.md` |
| QC | `.claude/agents/quality-checker.md` |
| Images | `.claude/agents/nanobanana-image-generator.md` |
| Repurposing | `.claude/agents/content-repurposer.md` |
| Social copy | `.claude/agents/social-writer.md` |
| Instagram carousel | `.claude/agents/instagram-creator.md` |

---

### presentation-manager

**File:** `.claude/agents/presentation-manager.md`

**Frontmatter:**
```yaml
---
name: presentation-manager
description: >
  Agentic Presentation Head for [Brand]. Creates, edits, and QAs .pptx decks and .xlsx
  spreadsheets. Always-plan mode — shows plan before building.
tools: Read, Write, Edit, Bash
---
```

**Specialist playbooks:**
| Role | File |
|------|------|
| Deck building | `.claude/agents/deck-builder.md` |
| Data analysis / XLSX | `.claude/agents/data-analyst.md` |
| Visual design | `.claude/agents/visual-designer.md` |

---

### research-manager

**File:** `.claude/agents/research-manager.md`

**Frontmatter:**
```yaml
---
name: research-manager
description: >
  Agentic Research Head for [Brand]. Runs SEO audits, competitor analysis, and keyword
  research. Always-plan mode.
tools: Read, Write, WebSearch, Grep
---
```

**Specialist playbooks:**
| Role | File |
|------|------|
| SEO audit | `.claude/agents/seo-analyst.md` |
| Competitor analysis | `.claude/agents/competitor-analyst.md` |
| Keyword research | `.claude/agents/content-brief-writer.md` |

---

## Tier 3 — Specialist Playbooks

Specialists are **markdown files**, not separate agents. Managers read them inline:

```
Read: .claude/agents/blog-writer.md
→ follow its instructions within the current context
```

### Core Specialist Files

| File | Responsibility |
|------|---------------|
| `blog-writer.md` | CMS-ready Markdown blog with YAML frontmatter, schema, meta, internal links |
| `social-writer.md` | LinkedIn post / Twitter post / Twitter thread |
| `instagram-creator.md` | 7-slide Instagram carousel + caption |
| `content-brief-writer.md` | Keyword research + brief + duplicate check |
| `content-planner.md` | Multi-day content calendar as .xlsx |
| `content-repurposer.md` | Derive social from existing blog |
| `quality-checker.md` | QC pass: fact check + copy audit + brand check |
| `nanobanana-image-generator.md` | Generate images via nanobanana MCP (Gemini) |
| `deck-builder.md` | PPTX creation with pptxgenjs |
| `data-analyst.md` | XLSX creation with openpyxl + pandas |
| `visual-designer.md` | Slide design and brand consistency |
| `seo-analyst.md` | SEO audit: meta, keywords, internal links, score |
| `competitor-analyst.md` | Top-N competitor content gap analysis |
| `registry-guide.md` | CONTENT-REGISTRY.csv rules and status values |

---

## Quality Gate

All content goes through `quality-checker.md` before delivery.

```
QC attempt 1 → issues found → fix inline → QC attempt 2
QC attempt 2 → issues found → escalate to human (status: escalated)
QC attempt 2 → passed → status: ready-for-review
```

**Status flow (agents can only move forward to `ready-for-review`):**

```
draft → qc-failed → ready-for-review
                        ↓  (human only)
               scheduled → published
```

Agents **never** set `scheduled` or `published`. That is a human action.

---

## MCP Integration (nanobanana)

The `nanobanana` MCP server provides Gemini-powered image generation.

**Project `.mcp.json` setup:**
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

**`.claude/settings.json` (enable MCP for agents):**
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

**Auth:** set `GEMINI_API_KEY` in the shell or `.env` before launching Claude Code.
Never commit the key. `.env` must be in `.gitignore`.

---

## Claude Code Settings

### `.claude/settings.json` (commit this)

```json
{
  "permissions": {
    "allow": [
      "Bash(bash scripts/*)",
      "Bash(python3:*)",
      "Bash(node:*)",
      "mcp__nanobanana__*"
    ],
    "deny": []
  },
  "mcpServers": {
    "nanobanana": true
  }
}
```

### `.claude/settings.local.json` (gitignore — machine-specific)

```json
{
  "permissions": {
    "allow": [
      "Bash(*)"
    ]
  }
}
```

---

## CLAUDE.md Template

The CLAUDE.md file loads automatically in every session. Keep it short — direct to skills.

```markdown
# [Brand] — Claude Code Project Memory

This file is loaded automatically. Long playbooks live in `.claude/skills/*/SKILL.md`
and `.claude/agents/*.md`. Human onboarding: see `README.md`.

## Canonical Layout

| What | Where |
|------|-------|
| Project skills | `.claude/skills/<skill>/SKILL.md` |
| Subagents | `.claude/agents/<name>.md` |
| Project MCP | `.mcp.json` (repo root) |
| Settings | `.claude/settings.json` (committed) |
| Local overrides | `.claude/settings.local.json` (gitignored) |

## How Agents Work

1. **Orchestrator** routes requests when run as main-thread agent: `claude --agent [brand]-orchestrator`
2. **Managers** cannot spawn subagents — they read specialist `.md` files inline (playbook pattern)
3. **Outputs** go under `outputs/`. Registry: `outputs/CONTENT-REGISTRY.csv`

## MCP (Images)

Set `GEMINI_API_KEY` in `.env` before launching. Run `set -a && source .env && set +a` in the
same terminal. First image may take ~60s while uvx fetches the server.
```

---

## Debugging Common Issues

| Problem | Fix |
|---------|-----|
| Orchestrator won't delegate | Must be main-thread agent: `claude --agent [brand]-orchestrator`. From a chat, invoke managers directly with `@content-manager` etc. |
| `uvx: command not found` | Install [uv](https://docs.astral.sh/uv/) and restart terminal |
| MCP / images fail | Confirm `GEMINI_API_KEY` is exported in **same session** as Claude Code |
| Subagent can't spawn agents | This is expected behavior — managers read playbooks inline instead |
| Permission errors on Bash | Check `.claude/settings.json` allows the script path pattern |
| Content plan never gets approval | Plan step is intentional — send "go" to proceed |
