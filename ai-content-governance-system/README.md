# AI Content Governance & QA Enablement System (v1)
 
**Type:** Operational governance system — prompt assets, QA frameworks, and process documentation  
**Context:** Built within an eCommerce content operations role at a national footwear retailer  
**Status:** Complete and in active use  
**Scope:** Product Detail Pages (PDPs), AI-assisted content creation, attribute QA, sample workflow intake
 
---
 
## What This System Solves
 
Without guardrails, eCommerce content workflows commonly fail in the following ways:
 
- AI-generated content introduces unverifiable claims
- Product descriptions drift in structure and tone
- PIM system attributes are populated with invalid or invented values
- QA decisions become subjective and inconsistent
- Knowledge is locked to individuals instead of processes
- Sample-to-site timelines slow under volume
This system exists to **stop those failures upstream**.
 
---
 
## Architecture
 
**Create → Validate → Classify → QA → Publish**
 
Each stage has a dedicated document that prevents a known failure mode.
 
---
 
## File Index
 
| File | Role | Prevents |
|---|---|---|
| `01-system-overview.md` | Non-technical system overview | Leadership visibility gaps, AI misuse |
| `02-locked-system-prompt.md` | Core generation rules (system prompt) | Structural drift, speculative content, attribute contamination |
| `03-description-generator.md` | Day-to-day PDP creation prompt | Inconsistent quality, rewrites from unclear descriptions |
| `04-applicable-features-classifier.md` | Attribute enforcement prompt | Invalid filters, broken navigation, PIM data integrity issues |
| `05-exception-edge-case-handler.md` | Risk stop mechanism | Guessed content, downstream customer-facing errors |
| `06-pdp-qa-compliance-check.md` | Final content validation prompt | Non-compliant PDPs going live, late-stage QA rework |
| `07-pass-fail-qa-rubric.md` | Binary QA decision framework | Subjective QA debates, inconsistent enforcement |
| `08-sample-request-training-guide.md` | Cross-team intake clarity doc | Missing info, unclear ownership, sample flow delays |
| `09-operations-impact-report.md` | Performance reporting | System value viewed as anecdotal, loss of institutional knowledge |
 
---
 
## Operating Principles (Non-Negotiable)
 
- Research before generation
- No inference or guessing
- Marketing content and system attributes follow different rules
- Applicable Features use closed vocabulary only
- QA decisions must be enforceable and repeatable
---
 
## Notes
 
This system is designed to scale with volume, tooling changes, and team turnover without relying on individual expertise. Brand and system names have been generalized for portfolio use. The frameworks, prompt structures, rubrics, and operating principles are the original work of the author.
 
