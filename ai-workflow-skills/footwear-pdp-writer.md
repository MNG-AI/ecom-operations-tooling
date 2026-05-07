---
name: footwear-pdp-writer
description: >
  Generates strictly formatted, QA-ready e-commerce footwear product descriptions for Shoe Carnival and Shoe Station PDPs.
  Use this skill whenever the user provides shoe photos (product shots, label photos, or both), asks to write a product description,
  or needs to generate a Customer Friendly Name, description paragraph, feature bullets, or Applicable Features for footwear.
  Trigger even if the user just says "write this up," "describe this shoe," "PDP," or drops photos of footwear without explanation.
---

# Footwear PDP Writer

Creates transactional, neutral, shopper-focused footwear PDP content for Shoe Carnival / Shoe Station.
Priority: clarity, extractable bullets, and search-friendly phrasing grounded in visible or verified evidence.

---

## Input Handling

Typical input is **two photos**: one **label/box/hangtag photo** and one **product photo**.

### Label/Box/Hangtag Photo (preferred for specs)
Extract directly from the image when legible:
- Brand
- Style Name
- Style Number / SKU (capture for internal reference; never place in Customer Friendly Name)
- Colorway (capture for internal reference only; never output color terms unless the user explicitly requests color info)
- Any printed specs (materials, certifications, ratings, technologies, care, intended use)

### Product Photo
Observe and describe only what is visually supported:
- Silhouette/category (sneaker, sandal, boot, etc.)
- Collar height, closure type
- Toe shape, overlays/panels, strap count/placement
- Outsole pattern/tread presence
- Visible branding/logo placement
- Apparent material types only when safe to describe (e.g., mesh-like textile, smooth synthetic)

### If Only One Photo Is Provided
Proceed using what's available. At the end of the output, add a single line:
> ⚠️ Note: Only a [product photo / label photo] was provided. [State what info was missing and how it affected the output.]

---

## Operating Modes

### PHOTO-LED MODE (default)
Use when only photos are available with no external sources.
- Write from visible evidence only.
- Use cautious qualifiers when the observation involves judgment: *appears*, *looks like*, *likely*, *seems*.
- Prefer omission over guessing. If you cannot tell what something is, leave it out rather than risk a wrong claim.

### VERIFIED MODE (auto-upgrade when verified evidence is present)
Activate when any of the following is provided and legible:
- Label/box/hangtag text with specs
- User-pasted text from packaging or product details
- A user-provided retailer/brand PDP link **only if the user explicitly requests web research** (otherwise treat as unverified)

In Verified Mode:
- Incorporate verified facts directly (no qualifiers) **only** for claims explicitly supported by the provided verified evidence.
- Everything not covered by verified evidence still follows Photo-Led rules.

---

## Hard Accuracy Rules

These exist because incorrect safety/performance claims on a PDP can create legal liability and erode shopper trust. Every rule below is grounded in that principle.

### No Unverified Claims
Never invent or imply named technologies, certifications, ratings, or performance properties.

**Do not claim** any of the following unless the specific term is clearly printed on the label/box/hangtag or provided in verified text:
- **Safety/compliance:** Slip Resistant, Safety Toe, Steel Toe, Composite Toe, Alloy Toe, EH (Electrical Hazard), SD, CSA, Met Guard (Internal or External), Puncture Resistant, Abrasion Resistant, Heat Resistant, Ice Traction
- **Protection/environment:** Waterproof, Water Resistant, Insulated
- **Comfort tech:** Memory Foam, or any named cushioning/support technology (e.g., Air Max, Boost, Fresh Foam, FuelCell, OrthoLite, Cloudfoam)
- **Traction:** Any claim beyond "treaded outsole" or "patterned outsole" — the word "slip resistant" specifically requires certification and cannot be inferred from tread pattern alone

**Why this matters:** A shopper who buys a "slip resistant" shoe based on a PDP claim and then slips at work has a legitimate grievance. Same for steel toe, waterproof, EH-rated, etc. These are testable, certifiable properties — describing them without verification is a real risk.

### Inference Limits: Materials
- Never call a material "leather," "suede," or "nubuck" unless the label/box/hangtag explicitly states it.
- If not verified, use safer phrasing: "smooth synthetic," "textile," "mesh-like textile," "fabric upper," etc.
- The reason: genuine leather is a selling point and a price driver. Calling something leather when it is synthetic misleads the shopper. Going the other direction (calling leather "synthetic") is less harmful but still inaccurate — when in doubt, describe the texture without naming the material category.

### Inference Limits: Age/Gender
- Do not infer Infant / Toddler / Little Kid / Pre-School / Grade-School / Big Kid unless verified by label/box/hangtag or stated by the user.
- Do not infer gendered targeting unless the user states it or the label explicitly indicates it.
- The reason: age categories correspond to specific size ranges in footwear. Mislabeling a Pre-School shoe as Grade-School (or vice versa) creates a sizing mismatch that leads to returns.

### Branding
- Mention visible branding (logo placement, brand name on tongue/heel/outsole) only when you can see it in the product photo or it is confirmed in verified evidence.

### Technology & Feature Names
- If a label shows a technology name (e.g., "OrthoLite," "Primaloft," "Gore-Tex"), use the exact spelling and capitalization from the label. Do not paraphrase branded technology names.
- If you cannot read the full name clearly, omit it rather than guess at the spelling.

---

## Required Output Structure

Always output **all four sections** below in this exact order and with the exact headings.

### 1) Customer Friendly Name
Format: **Brand + Style Name**
Rules:
- No color words
- No style numbers / SKUs
- No extra descriptors beyond what the brand uses as the style name

Example: *Nike Air Max 90*

### 2) Product Description
One short paragraph, **2–4 sentences**, covering:
- What it is (category/silhouette)
- Who it is for (use case/lifestyle) without over-claiming
- Everyday-use benefits supported by visible/verified construction details (e.g., strap adjustability, treaded outsole, padded collar)

Rules:
- No editorial/aesthetic framing (e.g., "fashion-forward," "bold," "monochromatic colorway")
- Ground every benefit in something physical: what the part *is* and what it *does* for the wearer
- Never use the phrase "Step into"
- Do not mention colorways — descriptions must apply across all color versions of the style

### 3) Features
Provide **exactly 5–7 bullets**.

Bullet rules:
- Each bullet is one tight, attribution-style statement about construction, function, or fit
- Start with a noun phrase (e.g., "Adjustable strap…", "Molded footbed…", "Treaded outsole…")
- No color/aesthetic design commentary
- No hype language
- Do not include any claim that falls under the Hard Accuracy Rules unless verified
- Mention visible branding as a feature when present (e.g., "Brand logo at tongue and heel")

### 4) Applicable Features
Select **only** from the closed list in the Applicable Features section at the bottom of this skill.

Rules:
- Use exact names only — no synonyms, no paraphrasing
- Slash-separate multiple values (e.g., `Slip On / Low Top`)
- Include only if clearly supported by visible or verified evidence
- If none are supported, output exactly: `None`
- Non-footwear items in the list (socks, tablet/laptop-friendly) are ignored unless the product is clearly that item category
- Include `Classic/Retro` when the silhouette is a known retro/heritage style (e.g., Chuck Taylor, Air Force 1, Classic Leather) or the design clearly references a vintage era

---

## QA Gate

Before finalizing output, verify every item passes:

1. **Customer Friendly Name** — Brand + Style Name only (no color, no SKU, no added descriptors)
2. **Product Description** — 2–4 sentences; no hype/aesthetic framing; no "Step into"; no colorway mentions
3. **Features** — exactly 5–7 bullets; no unverified claims; noun-phrase starts
4. **Applicable Features** — every value is an exact match from the closed list, or output is `None`
5. **Accuracy sweep** — re-read every sentence and confirm nothing claims a material, technology, safety rating, or age/gender category that is not verified
6. **Banned words check** — none of these appear anywhere: *iconic, next-level, signature, premium feel, game-changing, fashion-forward, bold, sleek, stunning, eye-catching*

---

## Unsupported Claim Handling

If the user requests a specific claim (e.g., "make sure to mention it is slip resistant") that cannot be verified from the provided evidence:

1. Exclude the claim from the output.
2. After the Features section, add one line in this format:
   > ⚠️ Unverified: "[requested claim]" could not be confirmed from the provided photos/text. Closest supported alternative used: "[what was used instead, e.g., treaded outsole]."
3. If there is no reasonable alternative, state that plainly instead of inventing one.

---

## Batch Processing

When handling multiple products in a single session (common workflow: ~100 descriptions/day):

- **Consistency:** Maintain the same output structure and tone across every product. Do not let description quality drift as the batch progresses.
- **Isolation:** Treat each product independently. Do not carry over details (materials, technologies, features) from one product to the next — each output is based solely on its own photos/evidence.
- **Efficiency:** If the user provides photos for multiple products at once, process them in the order received. Label each output block with the Brand + Style Name so the user can match outputs to products when pasting into Oracle.
- **Error flagging:** If a photo set is unclear, incomplete, or appears to show the wrong product, flag it immediately rather than guessing. The user can correct and re-submit that one product without redoing the whole batch.
- **Shorthand accepted:** If the user drops photos without explanation mid-batch, treat it as a new product request and proceed with the standard output structure. No need to re-state instructions each time.

---

## Tone Rules

- Neutral, transactional, shopper-useful language
- Benefits are fine when grounded: *everyday wear*, *casual outings*, *all-day wear* (only if supported by visible comfort elements like padding/footbed)
- Avoid hype: *iconic, next-level, signature, premium feel, game-changing, fashion-forward, bold, sleek, stunning, eye-catching*
- Never use "Step into" as an opening or anywhere in the description

---

## Handling User Feedback

- "Be less cautious / more direct" → write more assertively about **visible** attributes; all accuracy limits still apply
- Requests for unsupported Applicable Features → exclude silently (output only supported values or `None`)
- Revision requests → update only the flagged section(s); preserve unchanged sections exactly as they were
- "Add [specific feature/claim]" → verify against evidence first; if unverified, follow Unsupported Claim Handling

---

## Applicable Features (closed list — exact names only)

10" Workboots / 6" Workboots / 8" Workboots / Abrasion Resistant / Adjustable Strap / Alloy Toe / Ankle / Ankle Strap / Arch Support Socks / Big Kid / CSA / Canvas / Cap Toe / Character / Classic/Retro / Composite Toe / Crew Socks / Cusioned Socks / Defined Heel / Electrical Hazard / Espadrille / External Met Guard / Faux Fur / Footies / Fringe / Grade-School / Heat Resistant / High and Mid Top / Hiker Low / Hiker Mid / Ice Traction / Infant / Insulated / Internal Met Guard / Knee High / Knee High Socks / Lace Up / Laptop friendly / Leather / Light Up / Light Weight / Little Kid / Low Cut Socks / Low Top / Mary Jane / Memory Foam / Met Guard / Mid Calf / Moc Toe / Mutilation Free / No Show Socks / Non Metallic / Non-Binding Socks / Nonporous / Open Toe / Over The Calf Socks / Over The Knee / Peep Toe / Performance / Pointy Toe / Pre-School / Pull On / Puncture Resistant / Quarter Length Socks / SD / SD 10 / Safety Toe / Slingback / Slip On / Slip Resistant / Steel Toe / Tablet friendly / Thermal Socks / Thong / Toddler / Trail / Uniform / Velcro / Water Resistant / Waterproof / Wellington / Wide Calf / Wing Tip / Zip Up

> ⚠️ This list was reconstructed from available records and may be incomplete. If you encounter a valid feature from the Ecom Attribution master list that is missing here, add it and update this file.
