# 05 — Exception & Edge Case Handler

**Role:** Risk stop mechanism  
**Owner:** eCommerce Operations / Content Governance  
**Status:** Approved for Production  
**Version:** v1.0

---

## Business Purpose

Prevent unverified or risky content from entering production.

---

## Prompt Text

> *"If product verification fails or data is incomplete:*
>
> *Return:*
> *"Unable to verify this product. Please confirm brand and style number before proceeding."*
>
> *Do not generate descriptive content."*

---

## Output Requirements

- Clear stop condition
- No speculative content

---

## Known Failure Modes

- Missing attribution validation
- Structural drift

---

## Version History

- v1.0 — Initial production prompt
