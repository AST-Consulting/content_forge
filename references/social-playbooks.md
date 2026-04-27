# Social Playbooks — LinkedIn, Twitter/X, Instagram, Facebook

Channel-specific formulas, templates, and production workflows.

---

## LinkedIn

### Post Formula

```
LINE 1: Bold hook — stat, question, or bold claim (ONE line — stops the scroll)

[blank line]

LINE 2-3:
Context or story expanding the hook.
Real. Specific. Grounded in the brand's market.

LINE 4-8:
Substance — 3-5 insight bullets or mini-story beats.
→ Use arrows or numbers, not generic bullets.
Each line = one idea.

LINE 9-10:
Brand angle — weave in naturally.
"This is exactly why we built [feature] at [Brand]."
OR a relevant data point. Not a hard sell.

LINE 11:
CTA — one clear action.
"Check what your car is worth at [url]"
OR "What's your experience? Drop it below."

[HASHTAGS — 3-5 max]
#[Brand] #[TopicTag] #[IndustryTag]
```

### Content Types & Cadence

| Type | Format | Target cadence |
|------|--------|---------------|
| Insight post | Hook + bullets + CTA | 3×/week |
| Customer story | Narrative post | 1×/week |
| Data post | Stat + context + implication | 1×/week |
| Behind the scenes | Process / team / product | 1×/2 weeks |
| Market commentary | Timely news angle | As needed |

### Best Practices

- First line must work standalone (before "see more" truncation)
- Line breaks after every 1-2 sentences — white space = more reads
- Use numbers: "3 things," "₹2 lakh," "2 hours" — specificity builds trust
- Native documents and carousels get 3× more reach than external links
- Best posting times: Tuesday–Thursday, 8-10am local time
- Images: 1200×628px banner (auto-generate if `image: yes`)
- Length sweet spot: 150-300 words for most posts

### Headline Hook Formulas

| Formula | Example |
|---------|---------|
| Number + outcome | "3 mistakes that cut your car's resale value by 30%" |
| Counterintuitive claim | "Selling your car to a dealer is actually your worst option." |
| Direct question | "Do you actually know what your car is worth right now?" |
| The confession | "We got this wrong for 2 years. Here's what we learned." |
| Stat + so what | "65% of used car deals in India fail RC transfer. Here's why." |

---

## Twitter / X

### Single Post Formula

```
[Surprising stat or bold claim — 1 line]
[Brief context — 1 line]
[CTA or invitation] + [brand URL]

[1-2 hashtags max]
```

### Thread Formula

```
TWEET 1 (Hook):
[Bold claim or surprising fact]
[Why this matters to the reader]
Thread 🧵

TWEET 2:
[Problem setup — the pain the reader recognises]

TWEETS 3-6:
[Core content — 1 insight per tweet]
Short. Punchy. One idea per tweet.
Use numbers where possible.

TWEET 7:
[Brand angle — how the brand addresses this]
No hard sell. One line reference.

TWEET 8 (CTA):
[Single action + link]
"[Verb-first CTA]: [brand URL]"

TWEET 9 (Engagement hook):
"What's your experience with [topic]?
Reply below 👇"
```

### Twitter Best Practices

- Start threads with data or a counterintuitive claim
- Keep individual tweets under 240 chars (aim for 200 for retweet room)
- Use relevant currency/local symbols (₹ for India, $ for US)
- Reference local cities, not generic "city"
- Threads: 7-10 tweets is the sweet spot
- 1-2 hashtags max per thread; brand tag + topic tag
- Best posting times: 8-10am or 7-9pm local time
- Images: 16:9 card (1200×675px) — auto-generate if `image: yes`

### Tweet Hook Formulas

| Formula | Example |
|---------|---------|
| Buried lede | "Nobody talks about this. [Stat] is why your car lost value this year." |
| Myth bust | "Your dealer is NOT giving you the market price. Here's the actual data." |
| Step reveal | "Sell your car in 2 hours. Step 1 is the one most people skip." |
| Before / after | "Before [Brand]: struggled for weeks. After: results in 60 seconds, done in 2 hours." |

---

## Instagram Carousel

### 7-Slide Structure

Every carousel follows this exact sequence:

| Slide | Type | Purpose | Copy rule |
|-------|------|---------|-----------|
| 1 | **Cover** | Make them stop scrolling | 5-7 words max. Bold claim or number. |
| 2 | **Problem** | Name the relatable pain | 1 sentence. Specific to target reader. |
| 3-5 | **Content** | 1 insight per slide | 1 headline + 2-3 bullets max |
| 6 | **Brand proof** | Trust signal | 1 big stat + 1 line context |
| 7 | **CTA** | One action | Verb-first. One URL. |

### Image Generation Prompts (nanobanana)

**Cover Slide**
```
Clean modern Instagram carousel cover slide. [Primary color] background.
Large bold white Poppins headline text: "[HEADLINE]".
Accent [accent color] underline or highlight on key word.
Bottom-left: small [Brand] logo in white.
Bottom strip in [accent color], 8px.
Photographic quality. 4K. 1080x1080px square.
Mood: confident, premium, [brand personality adjectives].
```

**Content Slide (tip / step)**
```
Clean Instagram carousel content slide. Off-white (#F8F9FA) background.
Top-left: slide number "[X]" in [accent color] circle, Poppins Bold.
Main headline: "[TITLE]" in [primary color], Poppins SemiBold, large.
Body: "[POINT 1] / [POINT 2] / [POINT 3]" in dark gray, Inter Regular, small.
Bottom-right: small [Brand] wordmark in [primary color].
Minimal. Professional. 4K. 1080x1080px.
```

**Stat / Proof Slide**
```
Bold Instagram stat slide. [Primary color] background.
Centre: giant number "[STAT]" in [accent color], Poppins Bold 120px equivalent.
Below number: short label "[LABEL]" in white, Poppins Regular.
Below label: supporting line "[CONTEXT]" in light gray, small.
Bottom: "[brand url]" in [accent color], small.
Clean, minimal, impactful. 4K. 1080x1080px square.
```

**CTA Slide**
```
Instagram CTA slide. Split design: [primary color] top 60%, off-white (#F8F9FA) bottom 40%.
Top: [brand tagline] in white, Poppins Regular.
Centre headline: "[CTA HEADLINE]" in [accent color], Poppins Bold, large.
Bottom white section: CTA button design "[BUTTON TEXT]" [accent] fill, white text.
Below button: "[brand url]" in [primary color], small.
4K. 1080x1080px square. Premium, clean finish.
```

### nanobanana MCP Call

```json
{
  "prompt": "[engineered prompt from above]",
  "model_tier": "nb2",
  "aspect_ratio": "1:1",
  "resolution": "high",
  "output_path": "outputs/social/instagram/YYYY-MM-DD_[topic]/slide-[N].png"
}
```

Use `"model_tier": "pro"` and `"resolution": "high"` for cover slide only. `nb2` + `"resolution": "high"` for all other slides.

### Logo Overlay (Skip API call)

After generating slides, overlay the brand logo locally using ffmpeg:

```bash
bash scripts/overlay-logo.sh path/to/slide.png path/to/output.png
```

This avoids an extra Gemini call and ensures pixel-perfect logo placement.

### Output Package

```
outputs/social/instagram/YYYY-MM-DD_[topic]/
├── slide-01-cover.png
├── slide-02-problem.png
├── slide-03-content.png
├── slide-04-content.png
├── slide-05-content.png
├── slide-06-proof.png
├── slide-07-cta.png
└── caption.md
```

### Caption Format

```markdown
---
topic: [topic]
slide_count: 7
status: draft
scheduled_date: YYYY-MM-DD HH:MM [timezone]
---

[Hook line — same energy as cover slide]

[2-3 sentences expanding on the carousel topic]

[Value summary: what they just learned in 1 sentence]

[CTA: "Save this 💾" / "Tag someone who needs this" / "Link in bio → [url]"]

.
.
.
[15-20 hashtags]
#[Brand] #[BrandTagline] #[Service1] #[Service2] #[Audience] #[Topic] ...
```

### Hashtag Strategy

- Always use: brand hashtag + brand tagline hashtag
- Service-specific: match the carousel topic (valuation, inspection, etc.)
- Audience: who you're targeting (car owners, buyers, etc.)
- Discovery: carousel format tags, general topic tags
- Avoid: banned tags, overly competitive generic tags (#cars has 100M posts)

---

## Facebook

### Audience Context

Facebook's organic reach is lower than other platforms. It rewards content that generates
comments and shares — not just likes. Post copy should invite conversation.

### Post Formula

```
LINE 1: Hook — question or bold statement (keep under 80 chars — critical for "See more" cut)

[blank line]

2-4 lines of context:
Short paragraphs. Conversational. Like you're talking to a friend, not broadcasting.
Specific detail makes this land better than vague inspiration.

[optional image description: a real photo or visual — not stock]

CTA: Ask a question or give an easy "yes/no" to spark comments.
"Have you dealt with this? Drop a comment below."

Link (if applicable): Put in first comment on promotional posts to avoid reach penalty.
```

### Facebook-Specific Rules

- **Don't link in the post body** if you want organic reach — put the URL in the first comment
- **Keep it under 250 characters** for maximum reach on non-image posts (Facebook truncates at ~480 chars)
- **Ask a direct question** — Facebook's algorithm rewards comment-generating posts
- **Avoid clickbait phrases** — Facebook actively penalises "You won't believe…" style hooks
- **Hashtags**: use 2-3 max — unlike Instagram, Facebook hashtags have minimal discovery effect
- **Native video** gets highest reach — if repurposing a blog, consider a short Reel/video teaser

### Facebook vs LinkedIn Tone

| Dimension | LinkedIn | Facebook |
|-----------|----------|----------|
| Formality | Semi-professional | Casual |
| Length | 1,200–1,800 chars | 100–250 chars (for reach) |
| Hook style | Insight-first | Question or relatable situation |
| Link placement | In body | First comment |
| CTA | "Thoughts?" / "Worth reading" | "Drop a comment" / "Tag a friend" |

### Content Types That Work on Facebook

| Type | Format | Goal |
|------|--------|------|
| Poll | Native poll feature | Engagement, market research |
| Short video | Under 60 sec native upload | Reach, awareness |
| Community question | Text only, end with "?" | Comments, trust building |
| Customer story | 1-2 sentences + photo | Social proof, shares |
| Behind-the-scenes | Photo + short copy | Brand affinity |

---

## Content Repurposer — Blog → Social

When any social deliverable has `adapt_from: blog`, follow this logic:

| Social type | What to extract from blog |
|-------------|--------------------------|
| `linkedin_post` | Most counterintuitive insight OR the H2 with the most actionable advice |
| `twitter_post` | Best single stat or claim → condense to 200 chars |
| `twitter_thread` | 6-8 standalone insights (1 per H2 roughly) |
| `instagram_carousel` | 5 core tips → each becomes a content slide |
| `facebook_post` | Most relatable pain point from blog intro → reframe as community question |

**Adaptation rule**: never just copy-paste from the blog. Rewrite for the platform voice:
- LinkedIn: professional, slightly longer, conversation starter
- Twitter: punchy, standalone, no context assumed
- Instagram: visual-first, minimal text per slide, emotion over information
- Facebook: conversational, community-first, end with a question

---

## Image Defaults by Channel

| Channel | Dimensions | Placement |
|---------|-----------|-----------|
| LinkedIn | 1200×628px banner | `outputs/social/linkedin/images/[slug].png` |
| Twitter post | 1200×675px card | `outputs/social/twitter/images/[slug].png` |
| Twitter thread | 1200×675px (tweet 1 only) | `outputs/social/twitter/images/[slug].png` |
| Instagram post | 1080×1080px square | `outputs/social/instagram/images/[slug].png` |
| Instagram carousel | 1080×1080px × 7 slides | `outputs/social/instagram/YYYY-MM-DD_[topic]/` |
| Facebook | 1200×630px | `outputs/social/facebook/images/[slug].png` |
