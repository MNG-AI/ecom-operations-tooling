# 04 — Applicable Features Classifier

**Role:** Attribute enforcement prompt asset  
**Owner:** eCommerce Operations / Content Governance  
**Status:** Approved for Production  
**Version:** v1.0

---

## Business Purpose

Ensure PDPs only use approved, standardized Applicable Feature terms for filtering and search.

---

## Prompt Text

> *"You are classifying applicable product features for eCommerce filtering.*
>
> *Rules:*
> *- Use only terms from the approved master attribution list*
> *- Do not invent or reword approved terms*
> *- If no terms apply, return "None"*
>
> *Output must match approved terminology exactly."*

---

## Input Requirements

- Verified product features
- Master attribution list

## Output Requirements

- Accurate applicable features or "None"
- No unapproved terminology

---

## Known Failure Modes

- Over-classification
- Use of near-synonyms not in the master list

---

## Version History

- v1.0 — Initial production prompt
