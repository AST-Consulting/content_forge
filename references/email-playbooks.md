# Email Playbooks — Brandforge

Load this file when producing any email deliverable: `email_newsletter`, `email_campaign`,
or `email_sequence`.

---

## Email Deliverable Types

| Type | What it is | Typical length | Cadence |
|------|-----------|---------------|---------|
| `email_newsletter` | Curated update to subscribers | 300–600 words | Weekly / fortnightly |
| `email_campaign` | Standalone promotional email | 150–400 words | Event-driven |
| `email_sequence` | Multi-email automated drip | 3–7 emails | Triggered by action |

---

## 1 — Email Newsletter

### Structure

```
SUBJECT LINE   (40–60 chars · curiosity gap or specific promise)
PREVIEW TEXT   (90–130 chars · complements subject, adds new info)

[GREETING — use first name token if platform supports: "Hi {{first_name}},"]

HOOK           (1-2 sentences · what's in this issue and why it matters now)

SECTION 1      (primary story / update — 150-250 words)
               [CTA 1 — single link, descriptive anchor text]

SECTION 2      (secondary item — 80-120 words, optional)
               [CTA 2]

QUICK HITS     (3 bullets — each a useful fact/tip/link — optional)

SIGN-OFF       (brand voice sign-off · avoid "Best regards")
FOOTER         (unsubscribe link · brand address — legal requirement)
```

### Subject Line Formulas

| Formula | Example |
|---------|---------|
| Specific number | "3 things we learned selling 10,000 cars last quarter" |
| Curiosity gap | "Why most used-car buyers overpay (and how to avoid it)" |
| Direct value | "Your free car valuation checklist — inside" |
| News hook | "RBI cuts rates: what it means for car finance in India" |

### Anti-spam Rules

- Avoid: FREE, GUARANTEED, EARN MONEY (caps triggers spam filters)
- Avoid: Excessive punctuation in subject `!!! ???`
- Avoid: All-caps subject lines
- Always: Text-to-image ratio ≥ 60% text
- Always: Plain-text version available

---

## 2 — Email Campaign

### Structure

```
SUBJECT LINE   (40–55 chars · benefit-driven or urgency-driven)
PREVIEW TEXT   (shorter: 60–100 chars)

HERO SECTION   (headline + 1-2 sentences of context)
BODY           (problem → solution → proof, max 250 words)
PRIMARY CTA    (single button · action verb · high contrast)
               "Get My Free Valuation" > "Click Here"
TRUST LINE     (1 short proof point below CTA — reduces anxiety)
FOOTER
```

### Frameworks for Campaigns

| Framework | Use when |
|-----------|---------|
| **PAS** (Problem → Agitate → Solution) | Reactivation, re-engagement, cold list |
| **AIDA** (Attention → Interest → Desire → Action) | Launch, new offer |
| **BAB** (Before → After → Bridge) | Case study / testimonial-driven campaign |
| **Single CTA** | Any campaign — one goal per email, always |

### Campaign Types and Notes

| Campaign type | Key constraint | Tone |
|--------------|---------------|------|
| Promotional (sale / offer) | Urgency must be real — never fake countdowns | Energetic, direct |
| Re-engagement | "We miss you" framing; offer an easy win | Warm, low pressure |
| Launch / announcement | Lead with the benefit, not the feature | Exciting, specific |
| Seasonal | Tie to a real occasion; don't force relevance | Contextual, useful |
| Transactional (receipt, etc.) | Mandatory content first, upsell subtle | Clear, reassuring |

---

## 3 — Email Sequence (Drip / Automation)

### Trigger Types

| Trigger | Sequence goal |
|---------|--------------|
| New subscriber (opt-in) | Welcome + establish value + soft CTA |
| Free resource download | Deliver value → educate → convert |
| Trial / free plan signup | Activate → retain → upgrade |
| Abandoned form | Remind → overcome objection → re-engage |
| Post-purchase | Delight → upsell → referral ask |

### Welcome Sequence Template (5 emails)

```
Email 1 — Deliver on the promise (send immediately)
  · What they signed up for + what's coming
  · Single CTA: the thing they asked for (resource, confirmation, etc.)
  · Tone: warm, specific, personal

Email 2 — Your origin story (send Day 2)
  · Why the brand exists · founder/team story or brand belief
  · No hard CTA — relationship building only
  · Tone: human, direct, credible

Email 3 — Proof (send Day 4)
  · One case study or proof point · real numbers
  · Soft CTA: "Curious how this could work for you?"
  · Tone: confident, evidence-based

Email 4 — Common objection handled (send Day 6)
  · Pick the #1 reason people don't convert · address it head-on
  · CTA: FAQ page or booking link
  · Tone: honest, empathetic

Email 5 — Clear offer (send Day 8)
  · Make the ask · explicit offer or next step
  · Hard CTA: book / buy / start
  · Tone: direct, low-pressure, deadline only if real
```

### Sequence Rules

- **One goal per email.** Don't ask for two different things in the same email.
- **One primary CTA per email.** Secondary links (footer, PS) are fine but must be lower-priority.
- **Subject lines should work as a series.** Threads help — readers recognise the sender.
- **Unsubscribes in a sequence are healthy.** Don't suppress the link to improve list quality metrics.
- **Re-permission after 90 days of silence** — don't mail cold lists without a re-opt-in.

---

## 4 — Copy Audit for Emails (5 Sweeps)

Run before any email ships. Adapted from the 7-sweep copy audit for email's constraints.

| Sweep | Check |
|-------|-------|
| 1. Subject + Preview | Together, do they make a compelling case to open? Not misleading? |
| 2. First sentence | Does the first line earn the click to keep reading? No "I hope this email finds you…" |
| 3. CTA clarity | Is the action 100% clear? Is the button text a verb + benefit, not "Click here"? |
| 4. Brand voice | Sounds like the brand, not generic marketing copy? Proof point present? |
| 5. Deliverability | No spam triggers in subject/body? Text-to-image ratio okay? Unsubscribe link present? |

---

## 5 — Output Format

Save email files to: `outputs/email/[type]/YYYY-MM-DD_[slug].md`

**Frontmatter for each email file:**

```markdown
---
type: email_newsletter | email_campaign | email_sequence
sequence_email: 1 of 5   # (only for sequences)
subject_line: "[subject]"
preview_text: "[preview]"
from_name: "[Brand Name]"
target_list: [list segment or "all subscribers"]
send_date: YYYY-MM-DD    # human sets this
status: draft
---

[Email body in markdown — use --- to separate sections for easy CMS paste]
```

For sequences, create one file per email, numbered: `01_welcome.md`, `02_story.md`, etc.,
inside a folder: `outputs/email/sequences/YYYY-MM-DD_[sequence-name]/`
