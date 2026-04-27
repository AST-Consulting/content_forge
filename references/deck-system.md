# Deck System — PPTX, XLSX, Themes & Generative Art

Full reference for creating and editing presentations, spreadsheets, and visual assets.

---

## Table of Contents

1. [PPTX Builder (pptxgenjs)](#1--pptx-builder)
2. [XLSX Builder (openpyxl + pandas)](#2--xlsx-builder)
3. [Theme Factory](#3--theme-factory)
4. [Generative Art (p5.js)](#4--generative-art)
5. [QA Checklist](#5--qa-checklist)
6. [Standard Deck Templates](#6--standard-deck-templates)

---

## 1 — PPTX Builder

### Dependencies

```bash
npm install -g pptxgenjs    # or: npm install pptxgenjs in project
pip install "markitdown[pptx]" Pillow  # for reading + QA
```

### Creating a Deck (pptxgenjs)

```javascript
const pptxgen = require("pptxgenjs");
const prs = new pptxgen();

// --- Slide master setup ---
prs.layout = "LAYOUT_WIDE";  // 16:9
prs.title = "[Deck title]";
prs.subject = "[Deck subject]";

// --- Title slide ---
const slide1 = prs.addSlide();
slide1.background = { color: "[PRIMARY_HEX]" };  // e.g. "0A1F44"

slide1.addText("[Brand name]", {
  x: 0.5, y: 1.5, w: 9, h: 1,
  fontSize: 44, bold: true,
  color: "FFFFFF", fontFace: "Poppins"
});

slide1.addText("[Tagline]", {
  x: 0.5, y: 2.8, w: 9, h: 0.6,
  fontSize: 20, color: "[ACCENT_HEX]",
  fontFace: "Poppins"
});

slide1.addText("[Date]", {
  x: 0.5, y: 4.5, w: 9, h: 0.5,
  fontSize: 14, color: "CCCCCC", fontFace: "Inter"
});

// --- Save ---
prs.writeFile({ fileName: "outputs/presentations/YYYY-MM-DD_[name]_v1.pptx" });
```

### Slide Components

**Stat callout card:**
```javascript
slide.addShape(prs.ShapeType.rect, {
  x: 0.5, y: 1.0, w: 4.0, h: 3.0,
  fill: { color: "0A1F44" }, line: { color: "0A1F44" }
});
slide.addText("[NUMBER]", {
  x: 0.5, y: 1.2, w: 4.0, h: 1.5,
  fontSize: 72, bold: true, color: "F7941D",
  align: "center", fontFace: "Poppins"
});
slide.addText("[Label]", {
  x: 0.5, y: 2.9, w: 4.0, h: 0.6,
  fontSize: 16, color: "FFFFFF",
  align: "center", fontFace: "Inter"
});
```

**3-column "how it works" row:**
```javascript
const steps = ["Step 1 title", "Step 2 title", "Step 3 title"];
const descs = ["Step 1 desc", "Step 2 desc", "Step 3 desc"];
steps.forEach((title, i) => {
  const x = 0.5 + i * 3.2;
  slide.addText(`${i+1}`, {
    x, y: 1.5, w: 0.7, h: 0.7,
    fontSize: 28, bold: true,
    color: "FFFFFF", fontFace: "Poppins",
    fill: { color: "F7941D" }, align: "center"
  });
  slide.addText(title, {
    x, y: 2.3, w: 3.0, h: 0.6,
    fontSize: 18, bold: true, color: "0A1F44", fontFace: "Poppins"
  });
  slide.addText(descs[i], {
    x, y: 3.0, w: 3.0, h: 1.0,
    fontSize: 13, color: "444444", fontFace: "Inter"
  });
});
```

### Editing an Existing Deck

For targeted edits, use the unzip → edit XML → rezip approach:

```bash
# 1. Unpack
cp presentation.pptx presentation.zip
unzip presentation.zip -d presentation_extracted/

# 2. Edit slide XML
# Slides are in: presentation_extracted/ppt/slides/slide[N].xml
# Edit the XML directly for text/color changes

# 3. Repack
cd presentation_extracted/
zip -r ../presentation_edited.pptx . -x "*.DS_Store"
```

For comprehensive rebuilds, recreate with pptxgenjs rather than editing XML.

### Reading a Deck

```bash
# Extract all text content
python -m markitdown presentation.pptx

# Check for placeholder text
python -m markitdown presentation.pptx | grep -iE "xxxx|lorem|ipsum|\[insert\]"

# Convert to images for visual inspection
soffice --headless --convert-to pdf presentation.pptx
pdftoppm -jpeg -r 150 presentation.pdf slide
# → generates slide-01.jpg, slide-02.jpg etc.
```

---

## 2 — XLSX Builder

### Dependencies

```bash
pip install openpyxl pandas
```

### Creating a Spreadsheet

```python
import openpyxl
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
from openpyxl.utils import get_column_letter

wb = openpyxl.Workbook()
ws = wb.active
ws.title = "[Sheet name]"

# --- Brand header row ---
BRAND_NAVY = "0A1F44"
BRAND_ORANGE = "F7941D"

headers = ["Date", "Type", "Topic", "Status", "Owner", "File Path"]
for col_idx, header in enumerate(headers, start=1):
    cell = ws.cell(row=1, column=col_idx, value=header)
    cell.font = Font(bold=True, color="FFFFFF", name="Calibri")
    cell.fill = PatternFill("solid", fgColor=BRAND_NAVY)
    cell.alignment = Alignment(horizontal="center", vertical="center")

# --- Freeze header row ---
ws.freeze_panes = "A2"

# --- Auto-width columns ---
for col in ws.columns:
    max_len = max(len(str(cell.value or "")) for cell in col)
    ws.column_dimensions[get_column_letter(col[0].column)].width = min(max_len + 4, 40)

# --- Save ---
wb.save("outputs/presentations/YYYY-MM-DD_[name].xlsx")
```

### Common XLSX Use Cases

| Use case | Approach |
|----------|----------|
| Content calendar | Dates as rows, type/topic/status as columns, conditional formatting by status |
| Content registry export | Read CONTENT-REGISTRY.csv → openpyxl with brand formatting |
| Campaign tracker | Campaign name, channel, budget, CPA, ROAS, status |
| Monthly metrics dashboard | Data table + basic charts (bar, line) via openpyxl chart API |

---

## 3 — Theme Factory

### Available Themes

When the user wants a specific aesthetic beyond the brand defaults, pick from:

| Theme | Mood | Colors | Best for |
|-------|------|--------|---------|
| `corporate-dark` | Premium, trustworthy | Dark navy + gold accents | Investor decks, board presentations |
| `tech-minimal` | Clean, modern | White + electric blue | Product demos, feature overviews |
| `bold-agency` | High energy | Black + neon accent | Campaign briefs, creative pitches |
| `warm-editorial` | Approachable, human | Cream + warm terracotta | Brand presentations, culture decks |
| `data-forward` | Analytical, precise | Dark gray + bright green | Analytics reviews, performance decks |

### Applying a Theme

1. Show user a theme preview description or PDF (theme-showcase if available)
2. User picks a theme
3. Read the theme definition: applies on top of brand base colors
4. Override only: background, card backgrounds, accent choices — keep brand primary + logo

---

## 4 — Generative Art (p5.js)

Use for: abstract hero slide backgrounds, brand motion concepts, creative campaign visuals.

### Seeded Sketch Template

```javascript
// Save as: slide-art-[description].js
// Run with: node -e "require('./slide-art.js')" or p5.js server

let seed = 42;  // Change seed to get different but reproducible outputs

function setup() {
  createCanvas(1920, 1080);  // 16:9 for slide backgrounds
  // OR: createCanvas(1080, 1080) for Instagram
  randomSeed(seed);
  noiseSeed(seed);
  background("[PRIMARY_HEX]");  // Brand primary color
  noLoop();
}

function draw() {
  // Flow field example — adapt to brand aesthetic
  stroke("[ACCENT_HEX]");  // Brand accent
  strokeWeight(0.8);

  let scale = 0.003;
  for (let x = 0; x < width; x += 6) {
    for (let y = 0; y < height; y += 6) {
      let angle = noise(x * scale, y * scale) * TWO_PI * 2;
      let len = 20;
      line(x, y, x + cos(angle) * len, y + sin(angle) * len);
    }
  }

  // Save output
  saveCanvas("slide-art-" + seed, "png");
}
```

### Art Styles for Brand Slides

| Style | Description | When to use |
|-------|-------------|------------|
| Flow field | Organic wave patterns | Hero/title backgrounds |
| Particle system | Dots drifting and connecting | Tech/AI slide backgrounds |
| Geometric grid | Repeating shapes with noise offset | Data/metrics slides |
| Brand gradient blur | Soft gradient using brand colors | Section dividers |

### Integration into Deck

After generating art PNG:
1. Save to `outputs/presentations/art/[name]-seed-[N].png`
2. In pptxgenjs, add as background image:

```javascript
slide.addImage({
  path: "outputs/presentations/art/[name]-seed-42.png",
  x: 0, y: 0, w: "100%", h: "100%"
});
// Then layer text on top with sufficient contrast
```

---

## 5 — QA Checklist

Run before declaring any deck done.

**Content**
- [ ] No placeholder text (XXXX, Lorem ipsum, [INSERT], TBD)
- [ ] All claims match approved brand proof points
- [ ] Slide count matches agreed structure
- [ ] Speaker notes added where relevant

**Brand**
- [ ] All slides use brand color palette only (no off-palette colors)
- [ ] Correct brand fonts throughout
- [ ] Logo present on cover and final slide
- [ ] Tagline on cover slide

**Visual**
- [ ] No text overflow or cutoff at any slide boundary
- [ ] No overlapping elements
- [ ] Consistent margins (min 0.5 inch / 0.5 slide unit on all edges)
- [ ] Dark slides: white text visible, sufficient contrast (WCAG AA = 4.5:1 minimum)
- [ ] No two identical layouts back-to-back
- [ ] Every slide has at least one visual element (not text-only)

**File**
- [ ] Saved to `outputs/presentations/` with correct naming convention
- [ ] Version number in filename (`_v1`, `_v2`, etc.)
- [ ] Previous version preserved (not overwritten)

---

## 6 — Standard Deck Templates

### Investor Deck (12–16 slides)

```
1.  Cover           — Logo, tagline, date, presenter name
2.  Problem         — The pain your customer feels; make it visceral
3.  Solution        — Your product/service; show the transformation
4.  How It Works    — 3-step flow with icons
5.  Product         — Key features with benefit framing
6.  Traction        — Customer count, GMV, growth metrics, logos
7.  Market Size     — TAM / SAM / SOM with sources
8.  Business Model  — Revenue streams; how you make money
9.  Competition     — Positioning map; your differentiation
10. Go-To-Market    — Geographic expansion, channel strategy
11. Team            — Founders/leadership with credentials
12. Financials      — Key metrics; 3-year projection
13. Ask             — Funding amount + use of funds breakdown
14. Thank You       — Contact info, tagline
```

### Campaign Brief (8–10 slides)

```
1.  Cover           — Campaign name, date, owner
2.  Objective       — SMART goal (Specific, Measurable, Achievable, Relevant, Time-bound)
3.  Target Audience — Persona, geography, intent, job-to-be-done
4.  Key Message     — Single message + 3 supporting proof points
5.  Creative Direction — Visual style, tone, reference examples
6.  Channel Plan    — Platform breakdown with budget %
7.  Timeline        — Week-by-week execution calendar
8.  KPIs            — Success metrics per channel
9.  Budget          — Allocation table (optional: pie chart)
10. Next Steps      — Owner, deadline, action items
```

### Monthly Marketing Review (8–10 slides)

```
1.  Cover           — Month, date
2.  Executive Summary — 3 bullets: what worked / what didn't / what's next
3.  Content Performance — Blog traffic, top posts, SEO gains
4.  Social Performance — LinkedIn + Twitter metrics
5.  Paid Performance — Ad spend, CPA, ROAS (if applicable)
6.  Lead Funnel     — MQL, SQL, conversions
7.  Key Wins
8.  Learnings & Pivots
9.  Next Month Plan
10. Appendix        — Raw data tables
```

### Product / Sales Overview (6–8 slides)

```
1.  Cover           — "[Brand]: [Tagline]"
2.  Problem We Solve
3.  Services        — Icon grid (all services with headlines)
4.  How It Works    — 3-step flow
5.  Why [Brand]     — 5 differentiators vs. alternatives
6.  Traction        — Social proof: customer count, coverage, press
7.  CTA             — Get started + contact
```

### Brand Presentation — Agency/Vendor Briefing (10–12 slides)

```
1.  Cover           — Brand overview title slide
2.  Brand Foundation — Purpose, vision, mission
3.  Brand Values    — 4-5 values with definitions
4.  Brand Personality
5.  Color Palette   — Swatches with hex codes, usage rules
6.  Typography      — Font specimens, size scale
7.  Logo Usage      — Do's and don'ts with examples
8.  Voice & Tone    — Examples of on-brand vs. off-brand copy
9.  CTA Language    — Approved CTAs and their alternatives
10. Visual Examples — Approved imagery style (mood board)
11. Do / Don't      — Quick reference card
12. Contact / Brand Owner
```
