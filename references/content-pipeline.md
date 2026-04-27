# Content Pipeline — Deep Reference

Full stage-by-stage instructions for the 8-stage content production pipeline.

---

## Stage 1 — Brief & Research

### Inputs Required

| Input | Example |
|-------|---------|
| Topic or keyword | "how to sell a used car in Delhi" |
| Content goal | SEO traffic / brand authority / lead gen / social engagement |
| Target audience | first-time seller / used car buyer / loan seeker |
| Approximate length | short (600w) / medium (1200w) / long-form (2000w+) |

### Research Steps

**1. Keyword intent mapping**
- Informational → reader is learning (top of funnel)
- Commercial → reader is comparing (mid funnel)
- Transactional → reader is ready to act (bottom funnel)
- Map to brand service that addresses the intent

**2. Competitive gap analysis**
- WebSearch: top 5 pages ranking for target keyword
- Extract: H2 structure, word count, unique angle, proof points
- Identify: what does none of them cover? → that's your brand's angle

**3. Source gathering**
- All statistics and market data need a source URL
- Prefer: official bodies, published news, brand's own data
- Label internal brand stats explicitly (e.g. "per [Brand] customer data")

### Brief Output Format

```
Topic: [title]
Target Keyword: [primary]
Secondary Keywords: [2-3 related]
Reader: [persona description]
Goal: [SEO / authority / conversion]
Brand Service Hook: [which service to weave in]
Unique Angle: [what makes this piece different from top 5]
H2 Structure: [proposed outline]
Proof Points to Use: [from brand config]
CTA: [what action should reader take]
Sources gathered: [list URLs]
```

---

## Stage 2 — Framework & Outline

Apply the copywriting framework chosen in the execution plan (AIDA, PAS, BAB, LEMA,
4-Point, or AIDA+R). Agree the H1/H2 structure before writing any body copy.

### Outline Format

```
H1: [Primary keyword — curiosity-driving headline]

H2: [Section 1 — problem or context]
H2: [Section 2 — core insight / method]
H2: [Brand angle — weave in naturally, not salesy]
H2: [Section N …]
H2: Conclusion
```

Do not proceed to Stage 3 until the outline is confirmed (or the user has said "go" on
the full execution plan).

---

## Stage 3 — Draft

### Blog Markdown Structure

All blogs should be saved as Markdown with YAML frontmatter:

```markdown
---
title: [H1 headline]
slug: [kebab-case]
date: YYYY-MM-DD
author: [author name]
category: [category]
tags: [tag1, tag2]
meta_title: [≤60 chars, contains keyword]
meta_description: [150-160 chars, contains keyword + CTA hook]
status: draft
---

# [H1: keyword-rich, curiosity-driving headline]

[INTRO — 3-4 sentences]
Name the reader's problem or situation. State what this article solves.
Establish brand credibility anchor (if relevant).

## [Section 1]

Main point first. Prove with example or data. One actionable takeaway.

## [Brand angle section — weave in naturally]

How the brand solves this specific problem. Not salesy — educational.

## Conclusion

Summary of core argument (2 sentences).
Most important next step.
**[VERB-FIRST ACTION → brand URL]**
```

### SEO Checklist (before moving to Stage 4)

- [ ] Primary keyword in H1, first 100 words, and 2+ H2s
- [ ] Meta title ≤ 60 chars, contains keyword
- [ ] Meta description 150-160 chars, has CTA hook
- [ ] Internal links: at least 2 links to brand service pages
- [ ] One brand proof point per 400 words
- [ ] Word count within 10% of target
- [ ] No bare URLs — all links have anchor text

---

## Stage 4 — Fact Check

Tag every factual claim in the draft:

| Tag | Meaning | Action |
|-----|---------|--------|
| ✅ VERIFIED | Source confirmed | Keep as-is, inline source link |
| ⚠️ NEEDS SOURCE | Claim made, no citation | Find source or rephrase |
| ❌ REMOVE | Unverifiable or inaccurate | Delete or rewrite |
| 🔵 INTERNAL DATA | Brand's own stat | Flag to confirm it's current |

### Fact Check Report Format

```
## Fact Check Report

VERIFIED (✅):
- [Claim] → Source: [URL]

NEEDS SOURCE (⚠️):
- [Claim] → Suggested source or rephrase: [...]

REMOVE (❌):
- [Claim] → Reason: [...]

Internal Data Used (🔵):
- [Stat] → Confirm with team before publishing
```

---

## Stage 5 — AI SEO Pass

Add these elements to the draft before the copy audit:

- **Definition block** near the top — one-paragraph plain-English definition of the
  primary topic (AI Overviews pull from these)
- **3-5 FAQ items** with direct answers — each question phrased as H3, answer in 2-3
  sentences, no padding
- **Stat + source rows** — format every data point as `[stat — source, year]`
- **Comparison table** if the post compares options or tools
- **TL;DR summary box** — 3-5 bullet points at the top or bottom
- **H2s as questions** where appropriate — "How does X work?" > "How X Works"
- **Keyword check**: H1 has primary keyword, keyword appears in first 100 words,
  2+ H2s contain related terms

Goal: make the content citable by ChatGPT, Perplexity, and Google AI Overviews.

---

## Stage 6 — Copy Audit (7 Sweeps)

Run each sweep sequentially. Produce a pass/fail + list of issues per sweep.

**Sweep 1 — Clarity**
- Every sentence understandable to the target reader (no jargon without explanation)?
- One idea per paragraph?

**Sweep 2 — Brand Voice**
- Sounds like the brand (not generic)?
- No corporate fluff ("leverage," "synergize," "holistic")?
- Active voice throughout?
- Numbers used correctly for urgency?

**Sweep 3 — Proof Points**
- At least 1 brand proof point per major section?
- CTA appears naturally?
- Trust signals near conversion asks?

**Sweep 4 — Flow & Structure**
- Intro delivers on headline promise?
- Each H2 section earns its place?
- Smooth transitions?
- Conclusion feels earned, not padded?

**Sweep 5 — Readability**
- Average sentence 15-20 words?
- No paragraph > 4 sentences?
- Short paragraphs for mobile readers?

**Sweep 6 — SEO Signals**
- Keyword density natural (not stuffed)?
- Header hierarchy correct (H1 > H2 > H3)?
- Meta tags finalised?

**Sweep 7 — Human Check**
- Sounds like a person who knows the topic?
- Would the target reader find this useful and credible?
- Is the brand mention editorial (not advertorial)?

### Audit Output Format

```
## Copy Audit Report

OVERALL SCORE: Pass / Needs Work / Fail

Sweep 1 — Clarity: [Pass/Fail] → Issues: [...]
Sweep 2 — Brand Voice: [Pass/Fail] → Issues: [...]
Sweep 3 — Proof Points: [Pass/Fail] → Issues: [...]
Sweep 4 — Flow: [Pass/Fail] → Issues: [...]
Sweep 5 — Readability: [Pass/Fail] → Issues: [...]
Sweep 6 — SEO: [Pass/Fail] → Issues: [...]
Sweep 7 — Human Check: [Pass/Fail] → Issues: [...]

REQUIRED FIXES BEFORE NEXT STAGE:
1. [Fix 1]
2. [Fix 2]
```

---

## Stage 7 — Channel Adaptation

After the blog is approved, derive social content from it using content-repurposer logic.
Full channel formulas are in `social-playbooks.md`.

**Adaptation rules:**
- LinkedIn post: extract the most counterintuitive insight from the blog → hook + bullets + CTA
- Twitter thread: extract 6-8 standalone insights → each fits in 240 chars
- Instagram carousel: extract 5 core tips → visualise as slides

---

## Stage 8 — Final Audit & Publish Package

Combined checklist before declaring any piece done:

**Blog article**
- [ ] All Stage 4 fact-check issues resolved
- [ ] All Stage 6 copy audit fixes applied
- [ ] SEO meta tags finalised
- [ ] Internal links added and verified live
- [ ] CTA present and clear
- [ ] Proofread — no typos or grammar errors
- [ ] Mobile-readable (short paras, scannable headers)
- [ ] Word count confirmed

**Social posts**
- [ ] Hook strong in first line
- [ ] Brand voice consistent
- [ ] CTA present
- [ ] Platform-appropriate length
- [ ] No competitor name-drops

---

### Blog Deliverables

```
outputs/blogs/
├── YYYY-MM-DD_[slug].md           ← Blog post in Markdown with YAML frontmatter
├── images/
│   └── YYYY-MM-DD_[slug]-hero.png ← Hero image (16:9, generated via nanobanana)
└── [slug]-meta.md                 ← SEO metadata file

[slug]-meta.md format:
---
meta_title: [≤60 chars]
meta_description: [150-160 chars]
url_slug: /blog/[slug]
internal_links:
  - anchor: "[anchor text]" → url: "[service page url]"
  - anchor: "[anchor text]" → url: "[service page url]"
author_bio: [1 sentence]
suggested_featured_image: [description for editor]
---
```

### Content Registry Row (add to CONTENT-REGISTRY.csv)

```csv
YYYY-MM-DD,[type],[slug],[full headline],[status],[file_path]
```

Status on creation: `ready-for-review`
Human sets: `scheduled` → `published`

---

## AI Humanizer — 3 Modes

Use after any AI-generated draft, before final audit.

### Mode 1: Detect

Scan for AI tells — flag severity: 🔴 critical / 🟡 medium / 🟢 minor.

Core AI tell categories:
- **Overused filler words** 🔴: "delve," "landscape," "crucial," "leverage," "furthermore,"
  "navigate," "robust," "holistic," "foster," "facilitate," "ensure"
- **Hedging chains** 🔴: "It's important to note that," "One might argue," "In many cases,"
  "It goes without saying," "Needless to say"
- **Em-dash overuse** 🟡: 1-2 per piece is fine; every other paragraph = AI fingerprint
- **Uniform paragraph structure** 🔴: every paragraph is topic → explanation → example → bridge
- **Lack of specificity** 🔴: "many companies," "studies show," "significantly improved"
- **False authority** 🟡: confident claims with no basis: "companies that do X are more successful"
- **Cookie-cutter conclusion** 🟡: intro restated; "by implementing these strategies you can achieve"

### Mode 2: Humanize

Never just delete — always replace.

| AI phrase | Human replacement |
|---|---|
| "delve into" | "look at," "dig into," "break down" |
| "the X landscape" | "how X works today," "the current state of X" |
| "leverage" | "use," "apply," "put to work" |
| "crucial" / "vital" | state the thing — let it be self-evidently important |
| "furthermore" | nothing (just start the next sentence), or "and" |
| "robust" | specific: "handles 10,000 requests/sec" |
| "facilitate" | "help," "make easier" |

**Rhythm fix:** read aloud — break long sentences, add short punchy ones after long ones.
Pattern: *Long. Short. Long, long. Short.*

### Mode 3: Voice Inject

Inject brand personality using techniques:
1. **Personal anecdotes** — "We saw this firsthand when..."
2. **Direct address** — talk to the reader as "you", not "users"
3. **Opinions without apology** — "We think the industry is wrong about this"
4. **The aside** — parenthetical that shows the brand knows more than it's saying
5. **Rhythm signature** — match the cadence from brand voice examples

---

## Duplicate Detection

Before writing any new piece, check `outputs/CONTENT-REGISTRY.csv`.

**Fuzzy match criteria** (flag if any two of these match):
- Same primary keyword / topic area
- Same target audience + intent
- Published within the past 90 days

**On duplicate detected:**
```
DUPLICATE DETECTED
Existing piece: outputs/[path]
Title: [title]
Status: [status] | Date: [date]

Suggest a different angle, subtopic, or geographic variant before re-running.
```

Do not proceed with remaining deliverables until user resolves.
