# Brand Config — Setup Protocol

This file describes the full interactive brand setup process: interview → web crawl →
auto-draft → user review → save. Read this when no brand config exists yet.

---

## Overview

The goal is to require as little effort from the user as possible. They answer 6 questions,
you do the research, you draft the config, they correct anything wrong.

```
STEP 1 → Ask 6 questions (one message, all at once)
STEP 2 → Crawl brand website  (homepage + key inner pages)
STEP 3 → WebSearch for context (tagline, proof points, press, voice)
STEP 4 → Draft brand config from everything gathered
STEP 5 → Present draft for user review
STEP 6 → Apply corrections
STEP 7 → Save to .claude/skills/[brand]-brand/SKILL.md
```

---

## STEP 1 — The Interview (6 Questions, One Message)

Send exactly this block — all 6 questions in one message (not one at a time). Do not ask them one at a time.

```
To set up your brand profile, I just need 6 quick answers:

1. **Brand name** — what is it?
2. **Website URL** — the main site (e.g. https://example.com)
3. **One sentence** — what does your brand do, and for whom?
4. **One feeling** — what should customers feel or believe after interacting with your brand?
5. **Voice URLs** (optional) — paste 1-3 links to content you've already written (blog posts,
   LinkedIn posts, etc.) that best represent your brand voice. I'll analyse these to match
   your tone. Skip if you don't have any yet.
6. **One case study / proof point** (optional) — a real customer result or stat you're proud of
   (e.g. "We helped [client type] achieve [result] in [timeframe]"). Add more after setup.

That's it. I'll research everything else and draft the full brand profile for you to review.
```

Then wait for the user's answers before proceeding to Step 2.

**If the user has already shared this information earlier in the conversation**, extract it
from context — do not ask again.

### Voice URL Analysis (Step 1.5 — if URLs provided)

If the user provided voice URLs in Q5, fetch each with `WebFetch` and extract:

| Signal | What to detect |
|--------|---------------|
| Sentence length | Short punchy vs. long explanatory — note the mix |
| Vocabulary | Technical / casual / regional (e.g. Indian English idioms) |
| Personality markers | Humour, directness, use of "you", opinionated stances |
| Formatting patterns | Heavy bullets vs. prose, subheading frequency |
| CTA style | Soft ("curious? DM us") vs. hard ("Buy now") vs. editorial ("Read more") |

Synthesise into a 3-line **Detected Voice Summary** and include it in the brand config draft
as `voice_url_analysis`. If something conflicts with Q3/Q4 answers, flag it — ask the user
which is more representative.

---

## STEP 2 — Website Crawl

Use `WebFetch` to crawl the brand's website. Fetch these pages in order, stopping when
you have enough data (usually homepage + 1-2 inner pages is sufficient):

### Pages to Fetch

```
Priority 1 — Always fetch:
  WebFetch: [website_url]                    (homepage)

Priority 2 — Fetch if homepage is thin:
  WebFetch: [website_url]/about
  WebFetch: [website_url]/about-us
  WebFetch: [website_url]/services
  WebFetch: [website_url]/products
  WebFetch: [website_url]/our-story

Priority 3 — Fetch only if needed:
  WebFetch: [website_url]/pricing
  WebFetch: [website_url]/contact
```

### What to Extract from Each Page

| Signal | Where to find it | What to look for |
|--------|-----------------|------------------|
| **Tagline** | `<title>`, `<h1>`, hero section, og:description, meta description | Short memorable phrase, often in hero |
| **Services / products** | Nav menu, homepage sections, footer links | Named offerings |
| **Proof points** | Hero stats, testimonials, badges, "About" section | Numbers, milestones, awards |
| **Voice / tone** | Body copy, CTA text, headline phrasing | Adjectives, sentence length, formality |
| **Colors** | `<style>` tags, CSS variables (`:root`), inline `style=` on hero | Hex codes or CSS color names |
| **Fonts** | `@font-face` declarations, Google Fonts `<link>`, font-family rules | Font names |
| **Target customer** | Hero copy, "who it's for" sections, testimonial personas | Customer descriptions |
| **CTA language** | Buttons, banner text, nav CTAs | Verb-first phrases used |

### Color Extraction Tips

Look in the page source for patterns like:
```css
--primary: #0A1F44;
--accent: #F7941D;
background-color: #F7941D;
color: #0A1F44;
```

If colors are not in CSS variables, note the most frequently occurring hex codes in the
hero and header sections — those are typically primary and accent.

If you genuinely cannot determine colors from the page source, note "could not determine
— set manually" and leave the field as a placeholder.

---

## STEP 3 — WebSearch for Context

Run 2-3 targeted searches to fill gaps the website didn't answer.

### Search Queries to Run

```
Search 1: "[brand name] [city/country] reviews customers"
  → Extract: proof points, customer language, trust signals

Search 2: "[brand name] about founded mission"
  → Extract: founding story, mission statement, year, founder names if relevant

Search 3 (only if needed): "[brand name] [main service] vs competitors"
  → Extract: differentiators, positioning, what customers compare them to
```

### What to Extract from Search Results

| Signal | What to look for |
|--------|-----------------|
| **Industry / market** | What category does the brand operate in? |
| **Differentiators** | What do reviewers and customers say makes it different? |
| **Social proof scale** | Customer count, ratings, press coverage |
| **Pain points solved** | What problems do customers mention being solved? |
| **Competitors mentioned** | Names of alternatives (useful for content strategy) |
| **Keywords used naturally** | How do customers describe what the brand does? |

---

## STEP 4 — Draft the Brand Config

Now synthesise everything into the brand config SKILL.md. Fill in every field you can
from the crawl + search. For fields you genuinely could not determine, mark them with
`[could not determine — please update]` rather than guessing.

### Draft Format

```markdown
---
name: [brand-slug]-brand
description: >
  [Brand name] brand intelligence — colors, voice, typography, proof points, services,
  and messaging. Load this skill whenever creating or reviewing any [Brand name] content,
  copy, deck, social post, image, or communication. Contains the full [Brand name] design
  system and brand guidelines.
allowed-tools: Read
---

# [Brand Name] Brand Intelligence Skill

> [One-sentence brand description from user interview]
> Use this skill for any content creation, deck building, ad copy, social media, pitch
> preparation, or brand-aligned communication for [Brand Name].

---

## Brand at a Glance

| Element | Value |
|---------|-------|
| **Name** | [Brand name] |
| **Tagline** | [Extracted or could not determine] |
| **Website** | [URL] |
| **Core market** | [Market / geography extracted] |
| **Customer base / traction** | [Proof point if found, else could not determine] |
| **Core promise** | [Primary value prop from hero or about page] |

---

## Brand Foundation

### Purpose
[Extracted from about page / mission statement. 2-3 sentences.]

### Vision
[Extracted if available, else: could not determine — please update]

### Mission
[Extracted if available, else: could not determine — please update]

### Core Brand Values

| Value | Definition |
|-------|------------|
| [Value 1 extracted from copy] | [Definition] |
| [Value 2] | [Definition] |
| [Value 3] | [Definition] |

### Brand Personality
[3-4 adjectives extracted from copy tone + user's "feeling" answer]

### Positioning Statement
> For [target customer from user interview + crawl], [Brand] is the [category] that
> [core benefit] — [key differentiator].

---

## Brand Voice & Tone

### Voice Pillars

| Pillar | Description | Example |
|--------|-------------|---------|
| **[Adjective 1]** | [Derived from copy] | "[Actual example from their copy]" |
| **[Adjective 2]** | [Derived from copy] | "[Actual example from their copy]" |
| **[Adjective 3]** | [Derived from copy] | "[Actual example from their copy]" |

### Writing Rules
- Lead with [benefit vs feature — determined from their copy style]
- [Active/passive] voice — determined from their existing copy
- Avoid: [words that appear 0 times in their copy but are common AI clichés]
- Use: [words that appear frequently in their copy as brand language]

---

## Visual Identity

### Color Palette

| Role | Color | Hex | Usage |
|------|-------|-----|-------|
| **Primary** | [name] | `[hex extracted]` | Headers, main backgrounds |
| **Accent / CTA** | [name] | `[hex extracted]` | Buttons, highlights |
| **Background** | Off white | `#F8F9FA` | Page backgrounds, cards |
| **Body text** | [name] | `[hex extracted or #1A1A2E default]` | Body copy |

### Typography

| Role | Font | Fallback | Weight |
|------|------|----------|--------|
| **Heading** | [extracted font or could not determine] | Arial, sans-serif | 700 |
| **Body** | [extracted font or could not determine] | Helvetica, sans-serif | 400 |

---

## Core Services & Messaging

| Service | Headline | Supporting copy |
|---------|----------|-----------------|
| [Service 1 from nav/homepage] | [Their headline for it] | [Supporting line] |
| [Service 2] | [Their headline] | [Supporting line] |
| [Service 3] | [Their headline] | [Supporting line] |

---

## Key Proof Points

[List every stat, milestone, or trust signal found on the site or in search results]

- [Proof point 1 — specific, with number if possible]
- [Proof point 2]
- [Proof point 3]

---

## Case Studies

[Populated from user's Q6 answer + any testimonials/results found on site]

| Client type | Challenge | Result | Timeframe |
|------------|-----------|--------|-----------|
| [Client type — anonymised if needed] | [Problem] | [Metric result] | [Timeframe if known] |
| [Add more from site testimonials] | | | |

**Instructions for adding more:** After setup, add rows to this table or create
`references/case-studies.md` for richer case study content (full narrative + stats).

---

## Products & Services Detail

[Expanded from Core Services — include enough for content generation]

| Service / Product | Tagline | Target customer | Key benefit | CTA |
|-------------------|---------|----------------|-------------|-----|
| [Service 1] | [Their headline] | [Who it's for] | [Top benefit] | [CTA text + URL] |
| [Service 2] | | | | |
| [Service 3] | | | | |

---

## Voice Analysis

[Populated from Step 1.5 voice URL analysis, if URLs were provided]

```
Detected voice summary:
- Sentence style: [short/long/mixed — describe the pattern]
- Vocabulary register: [technical/casual/regional]
- Personality: [key adjectives from actual copy]
- Formatting preference: [prose-heavy/bullet-heavy/subheading-rich]
- CTA style: [soft/direct/editorial]

Voice URLs analysed: [list URLs]
```

If no voice URLs were provided: `[No voice URLs analysed — add URLs to improve voice matching]`

---

## Content & SEO Themes

### Editorial Pillars

Based on the brand's services and audience:

| Pillar | % | Topics |
|--------|---|--------|
| [Service area 1] | — | [Topic ideas] |
| [Service area 2] | — | [Topic ideas] |
| [Audience education] | — | [Topic ideas] |

### Primary SEO Keyword Themes
- "[brand main service] [location if local]"
- "[problem the brand solves]"
- "[how to + main use case]"

---

## Do's and Don'ts

### Always Do
- Lead with customer benefit, not feature spec
- Use proof points in every major claim
- [Third rule derived from their positioning]

### Never Do
- Use vague superlatives without backing ("world's best", "amazing")
- Make competitor claims without a cited source
- [Third rule — derived from their voice]
```

---

## STEP 5 — Present Draft for Review

After drafting, present it clearly with a confidence annotation on each section:

```
I've drafted your brand profile based on your answers + research from [website URL].

Here's what I found with high confidence (extracted directly from your site):
✅ Tagline: [value]
✅ Colors: [values]
✅ Services: [values]
✅ Proof points: [values]

Here's what I inferred (based on tone + copy analysis — please confirm or correct):
🟡 Voice adjectives: [values]
🟡 Brand values: [values]
🟡 Voice analysis: [summary from URL scan, or "no voice URLs provided"]

Here's what I added from your answers:
✅ Case study: [from Q6, or "none provided — add to case studies table when ready"]

Here's what I couldn't determine (please fill in):
⬜ Founding year / story: [could not find]
⬜ Vision statement: [could not find]
⬜ Products/services detail: [partial — please review the table and add missing CTAs]

--- FULL DRAFT BELOW ---

[paste the complete SKILL.md draft]

---
Reply with any corrections and I'll update and save it. Or say "looks good" to save as-is.
```

---

## STEP 6 — Apply Corrections

If the user makes corrections:
- Update only the specific fields they mention
- Do NOT regenerate the whole config
- Confirm what was changed: "Updated: tagline, primary color. Everything else unchanged."

If the user says "looks good" or "save it" → proceed to Step 7.

---

## STEP 7 — Save the Config

```bash
mkdir -p .claude/skills/[brand-slug]-brand/references
```

Save the drafted SKILL.md:

```
Write: .claude/skills/[brand-slug]-brand/SKILL.md
```

Then confirm:

```
✅ Brand profile saved to .claude/skills/[brand-slug]-brand/SKILL.md

You're all set. I'll load this profile automatically for all [Brand name] content tasks.

What would you like to create first?
```

---

## Confidence Levels

Use these labels when presenting the draft:

| Label | Meaning |
|-------|---------|
| ✅ High confidence | Extracted directly from page source, meta tags, or prominent copy |
| 🟡 Inferred | Derived from tone analysis, copy patterns, or search results |
| ⬜ Could not determine | Not found anywhere — user must fill in manually |

---

## Example Run — QuickServe

**User's 6 answers:**
1. QuickServe
2. https://quickserve.app
3. QuickServe helps restaurants manage orders and inventory through a simple WhatsApp bot
4. Customers should feel in control — like running their business just got easier
5. (no voice URLs provided)
6. Helped a 3-location restaurant chain cut order errors by 40% in the first month

**Crawl findings (homepage):**
- Title tag: "QuickServe — Restaurant Management via WhatsApp"
- H1: "Run Your Restaurant from WhatsApp"
- CSS: `--primary: #1B4332; --accent: #52B788;`
- Stats visible: "500+ restaurants onboarded", "Setup in 10 minutes", "No app download needed"
- Nav services: Order Management, Inventory Alerts, Daily Reports, Staff Notifications
- Fonts: Inter (headings + body) — Google Fonts link in head

**Search findings:**
- Industry: restaurant tech / F&B SaaS, SMB-focused
- Differentiator: WhatsApp-native (no app install), instant setup, works on any phone
- Competitors mentioned: Petpooja, Posist, local POS vendors

**Result:** Full brand config drafted with ✅ on colors, tagline, services, proof points;
🟡 on voice pillars; ⬜ on founding year and vision statement.
