---
name: pdp-input-grader
description: Grades the quality of inputs provided for writing footwear PDPs (product description pages) and produces a visual report card showing what output quality each combination of inputs will yield. Use this skill whenever the user wants to evaluate, score, or compare PDP inputs, asks "what do I need to write a good PDP", wants to know why a PDP output was weak, is reviewing a set of product inputs before writing descriptions, or asks to grade/assess/score any combination of shoe product inputs. Trigger even if the user just says "grade these inputs", "score this", "how good is this output", or shares screenshots of PDP outputs and asks why one is better than another.
---

# PDP Input Grader

Produces a report card grading PDP inputs across five quality dimensions, and assigns an overall letter grade (A–F) with a score out of 100.

## When to use
- User provides one or more sets of inputs and wants to know the output quality
- User shares PDP outputs and asks why one is better than another
- User wants to understand what inputs are needed to hit a target grade
- User wants a presentation-ready visualization comparing input sets

## Input types recognized

| Input | Points | What it unlocks |
|---|---|---|
| Product photo(s) | 15 | Silhouette, visible features, branding |
| Label / tag photo | 20 | Style number, color code, vendor ID |
| Brand website URL | 25 | Style name verification, full feature set, applicable features |
| Spec / highlights doc | 25 | Tech specs, comfort claims, materials, certifications |
| Additional context (category, buyer notes) | 15 | Applicable feature selection, positioning |

## Five grading dimensions

### 1. Style name accuracy
- **Full credit**: Name confirmed via brand URL or spec doc
- **Partial**: Name inferred from label style number only — correct number, unverified name
- **Fail**: Name guessed from photo alone — high error risk

### 2. Feature completeness
- **Full credit**: All functional features present (closure type, insole tech, materials, branding details)
- **Good**: Brand URL fills most features; minor gaps remain
- **Partial**: Visual-only — surface features seen in photos, proprietary systems absent
- **Fail**: No reliable source; guesswork only

### 3. Technical spec accuracy
- **Full credit**: Heel height, certifications, material composition, construction method all sourced
- **Moderate**: Specs present but unsubstantiated (e.g., "arch support" without certification detail)
- **Low**: Closure type and construction inferred from photo — misidentification risk is high
- **Fail**: No spec source; all specs are visual inference

### 4. Applicable features
- **Accurate**: All applicable features match the approved Ecom Attribution master list and are supported by a source
- **Minor gap**: One feature missing or one debatable selection
- **Errors present**: Wrong closure type, wrong silhouette type, or missing key feature like Arch Support Socks

### 5. Description depth
- **Full**: Performance claims backed by data (certifications, foot scan counts, specific measurements)
- **Solid**: Comfort story present but claims not substantiated
- **Surface**: Aesthetic/style language only — no performance or functional claims
- **Fail**: Not enough information to form any product story

## Scoring

Total possible: 100 points across all inputs provided.

| Grade | Score | Verdict |
|---|---|---|
| A | 90–100 | Publication ready |
| B | 75–89 | Publishable with light QA |
| C | 55–74 | Usable — revisions needed |
| D | 30–54 | Not publishable — key inputs missing |
| F | 0–29 | Cannot produce reliable output |

## Output format

Always produce a **visual report card** using the `show_widget` tool. The report card must:

1. Show each attempt or input set as a **column**
2. Show each of the five dimensions as a **row**
3. For each cell: show a status label (✓ Correct / Partial / Errors present / etc.) in the appropriate color, plus a one-sentence note explaining the finding
4. Show an **Overall grade row** at the bottom with letter, score/100, and a one-line verdict per column

### Cell color coding
- `#1D9E75` (green) — correct / complete / accurate
- `#378ADD` (blue) — good / solid / moderate
- `#BA7517` (amber) — partial / surface / minor gap
- `#E24B4A` (red) — incorrect / low / errors present / fail

### Column header
Each column header must list the inputs provided as small tag chips.

### After the visual
Follow the report card with 2–3 sentences of plain-language analysis: what was the biggest gap, what was the turning point input, and if there is a regression between attempts, call it out explicitly.

## Key rules
- Never show the widget without the follow-up text analysis
- Always call out misidentified closure types (lace-up vs. slip-on) — this is a frequent and high-impact error when only photos are available
- If Applicable Features are wrong, name the specific incorrect or missing feature
- If a style name is wrong, state the incorrect name and the correct one side by side
- Scores are not averages — they reflect the points unlocked by the inputs provided, not a mean of dimension scores
