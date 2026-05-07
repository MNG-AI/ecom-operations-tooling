# eCommerce Operations & AI Content Tooling
 
**Owner:** Stanley Carter  
**Role Target:** AI Operations | AI Governance | AI Enablement  
**Portfolio:** [stanleycarter.netlify.app](https://stanleycarter.netlify.app) · [LinkedIn](https://www.linkedin.com/in/stanley-carter-jr/)
 
---
 
## About This Repository
 
This repo contains the operational tooling, automation scripts, prompt assets, and governance documentation built during an active eCommerce content operations role at a national footwear retailer. Each artifact addresses a specific failure point in the sample-to-site pipeline, content quality workflow, or AI-assisted production system.
 
These were built and used in production — not exercises.
 
**Volume context:** 80–300 SKUs/week · 1,600+ products tracked · 755 brand URLs audited · Publish cycle reduced from ~15 days to near zero
 
---
 
## Repository Contents
 
### [`ai-content-governance-system/`](./ai-content-governance-system)
A 9-document operational framework governing AI-assisted eCommerce content creation, QA, and publishing. Includes the locked system prompt, prompt assets for generation and classification, a binary pass/fail QA rubric, exception handling rules, cross-team training documentation, and a performance impact report.
 
Built to prevent AI-generated content defects upstream rather than catching them in QA.
 
**Type:** Markdown documents · Prompt engineering · Governance framework
 
---
 
### [`ai-workflow-skills/`](./ai-workflow-skills)
Two production skill files — structured prompt assets that give an AI assistant persistent, specialized behavior for eCommerce content tasks.
 
- **Footwear PDP Writer** — generates QA-ready product descriptions from photos and verified sources, with hard accuracy rules covering safety claims, material inference, and closed-vocabulary attribute enforcement
- **PDP Input Grader** — scores input quality across five dimensions and produces a visual report card showing what output quality a given input set will yield
**Type:** Prompt engineering · AI workflow design · Quality systems
 
---
 
### [`brand-page-url-checker/`](./brand-page-url-checker)
Two Python scripts that audit brand page availability across both retail banners by checking HTTP redirect behavior — the only reliable signal on JavaScript-rendered sites. Identifies genuine missing pages vs. live pages. Includes checkpoint/resume logic for interrupted runs and writes results to CSV.
 
**Scale:** ~755 brand URLs checked across two banners  
**Type:** Python · HTTP · QA automation
 
---
 
### [`product-image-auditor/`](./product-image-auditor)
Python script that checks product image availability on the CDN for every SKU in the master sample list. Distinguishes real images from placeholders by inspecting response payload size. Uses concurrent requests (20 workers) for speed. Writes SHOT / NEEDS PHOTO status and clickable hyperlinks back to the workbook. Saves after each tab to protect completed work.
 
**Type:** Python · Concurrent requests · Excel automation
 
---
 
### [`sample-routing-macro/`](./sample-routing-macro)
Four versions of a VBA macro that evolved from basic department routing into a full workflow tool. Final version (v4) routes rows, applies live VLOOKUP formulas, stamps dates, highlights new rows and low-inventory alerts, sorts by color and priority, removes duplicates, and manages column visibility — all in a single run.
 
**Type:** VBA · Excel automation · Workflow design
 
---
 
## Skills Demonstrated
 
| Area | Evidence |
|---|---|
| AI governance & prompt engineering | `ai-content-governance-system/`, `ai-workflow-skills/` |
| LLM output quality systems | Pass/fail rubric, QA compliance check, exception handler |
| Python tooling & automation | Brand URL checker, image auditor |
| Workflow design & process ops | Sample routing macro (v1→v4), training guide |
| Cross-functional documentation | Sample request training guide, operations impact report |
| Operational impact | 15-day → near-zero publish cycle · 755 URLs audited · 1,600+ products tracked |
