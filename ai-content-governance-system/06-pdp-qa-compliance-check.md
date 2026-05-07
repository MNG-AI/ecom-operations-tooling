# 06 — PDP Content QA & Compliance Check

**Role:** Final content validation prompt asset  
**Owner:** eCommerce Operations / Content Governance  
**Status:** Approved for Production  
**Version:** v1.0

---

## Business Purpose

Act as a final QA gate before PDPs go live, preventing inaccurate or non-compliant content from reaching the site.

---

## Prompt Text

> *"You are performing a QA review of an eCommerce product description.*
>
> *Check for:*
> *- Product verification*
> *- Correct structure (intro, bullets, applicable features)*
> *- Verified features only*
> *- Approved applicable features*
> *- No filler or assumptions*
>
> *If any rule fails, flag the issue clearly."*

---

## Input Requirements

- Completed PDP description
- Verification sources (if available)

## Output Requirements

- Pass / Fail assessment
- Clear explanation of issues if failed

---

## Known Failure Modes

- Missing attribution validation
- Structural drift

---

## Version History

- v1.0 — Initial production prompt
