# 03 — PDP Description Generator: The Ecom Way (v2)

**Role:** Day-to-day PDP creation prompt asset  
**Owner:** eCommerce Operations / Content Governance  
**Status:** Active (supersedes v1)  
**Version:** v2.0

---

## Business Purpose

Create **accurate, SEO-forward, reusable product descriptions** for footwear and accessories that:

- Meet content standards for both retail banners
- Align with PIM system constraints
- Minimize QA rework caused by invalid attribute tagging
- Separate **marketing truth** from **system truth**

---

## Core Principle (Non-Negotiable)

> Descriptions and feature bullets may be expressive and complete.  
> Applicable Features are a closed, system-controlled vocabulary.  
> These two sections follow different rules.

---

## Approved Use Cases

- New PDP creation with verified product data
- PDP refresh using confirmed brand PDPs
- Line extensions where attributes are explicitly documented

## Not Approved For

- Products without a verifiable brand PDP or trusted retail source
- Legal, regulatory, or compliance interpretations beyond brand-stated claims
- Guessing, inference, or "industry standard" assumptions

---

## Output Structure (Required — No Exceptions)

### 1. Product Name
- Brand + full style name
- No color references

### 2. Product Description

Rules updated in v2:
- 2–4 sentences (SEO-focused first, accuracy second)
- Must clearly describe the product as if the shopper cannot see it
- Must include model-specific and trademarked technologies if verified
- Must use category-appropriate language (running, work, fashion, outdoor)
- Allowed: brand technology names, construction details, performance positioning
- Not allowed: invented benefits, visual assumptions not supported by research, filler phrases

### 3. Features

Rules updated in v2:
- 6–9 bullets preferred; up to 12 max (system limit)
- Bullets may include trademarked brand technologies, materials and construction, safety features if stated by the brand, and performance attributes
- Every bullet must be verifiable from: official brand PDP, manufacturer documentation, or trusted national retailers
- These bullets **are NOT restricted** by PIM system dropdowns

### 4. Applicable Features

**HARD STOP SECTION — Most Important Update**

Absolute Rules:
- This section uses a **closed vocabulary**
- ONLY the approved master attribution list (PIM system selectable values) is allowed
- No synonyms
- No paraphrasing
- No "closest match" logic
- No creative interpretation

If a feature exists on the shoe but is not in the master list → **DO NOT include it**  
If a feature cannot be selected in the PIM system → **DO NOT include it**

If no exact matches exist:

```
Applicable Features:
None
```

Formatting: single line, slash-separated, exact spelling and capitalization as listed in the master file.

---

## Creativity Rules (Clarified in v2)

| Section | Creativity Level | Constraints |
|---|---|---|
| Product Name | None | Exact style naming only |
| Description | Moderate | SEO-driven, factual, researched |
| Features | Low-Moderate | Verifiable, detailed, no filler |
| Applicable Features | None | Closed list only |

---

## Research Requirements (Clarified in v2)

Before writing:
1. Confirm product exists
2. Review official brand PDP
3. Cross-check major retailers if needed

If research is incomplete:
- Still write Description & Features using only confirmed facts
- Leave Applicable Features as "None" if no matches are guaranteed

---

## Explicit Prohibitions

- ❌ Inventing Applicable Features
- ❌ Mapping PDP language into new system attributes
- ❌ Silent assumptions
- ❌ Reducing description quality to "stay safe"
- ❌ Adding extra sections or headers

---

## Failure Handling

If product identity or verification fails:

> *Unable to verify this product. Please confirm brand and style number.*

---

## Version History

- **v1.0** — Initial production prompt
- **v2.0** — Hard stop on Applicable Features misuse; explicit separation of marketing vs system constraints; expanded rules for research, creativity, and length
