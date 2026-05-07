# AI Workflow Skills
 
**Type:** Claude skill files — structured prompt assets for AI-assisted eCommerce content workflows  
**Format:** Markdown-based skill definitions loaded into Claude as persistent workflow instructions  
**Context:** Built to support a production AI-assisted content operation handling 80–300 SKUs/week
 
---
 
## What Are Skill Files?
 
Skill files are reusable prompt assets loaded into an AI assistant to give it persistent, specialized behavior for a specific task. Rather than re-prompting from scratch each session, skills encode rules, output structures, accuracy requirements, edge case handling, and QA gates that apply every time the task is invoked.
 
These are distinct from one-off prompts. Each skill here was designed to be:
- **Consistent** — same structure and standards regardless of who runs it
- **Enforceable** — includes hard accuracy rules and explicit prohibitions
- **Documented** — failure modes, edge cases, and operating modes are written into the skill itself
---
 
## Files in This Folder
 
### `footwear-pdp-writer.md`
 
Generates strictly formatted, QA-ready eCommerce product descriptions for footwear PDPs.
 
Covers:
- Two operating modes (Photo-Led and Verified) based on available evidence
- Hard accuracy rules covering safety claims, material inference, age/gender categorization
- Required four-section output structure (Customer Friendly Name, Description, Features, Applicable Features)
- Batch processing behavior for high-volume production sessions
- A closed Applicable Features vocabulary with 70+ approved terms
- QA gate checklist and unsupported claim handling
**Why it exists:** At 80–300 SKUs/week, inconsistent AI outputs create downstream QA debt. This skill prevents structural drift and accuracy errors at the generation stage rather than the review stage.
 
---
 
### `pdp-input-grader.md`
 
Grades the quality of inputs provided for writing footwear PDPs and produces a visual report card showing what output quality each input combination will yield.
 
Covers:
- Five grading dimensions: style name accuracy, feature completeness, technical spec accuracy, applicable features, description depth
- Point-based scoring system (100 points total) mapping to letter grades A–F
- Visual report card output with color-coded cells per dimension per attempt
- Plain-language analysis following the visual identifying the biggest gap and turning-point input
**Why it exists:** Output quality is directly determined by input quality. This skill makes that relationship explicit and measurable, helping content teams understand what they need before they start — not after a weak description is already written.
 
---
 
## Relationship to the Governance System
 
These skills are the operational layer of the broader AI Content Governance System in this repo. The governance system defines the rules; these skills implement them inside an AI assistant.
 
| Governance Doc | Implemented By |
|---|---|
| 02 — Locked System Prompt | `footwear-pdp-writer.md` (accuracy rules, output structure) |
| 03 — Description Generator | `footwear-pdp-writer.md` (description + features sections) |
| 04 — Applicable Features Classifier | `footwear-pdp-writer.md` (closed vocabulary enforcement) |
| 06 — QA Compliance Check | `pdp-input-grader.md` (input quality gate) |
| 07 — Pass/Fail QA Rubric | Both skills (internal QA gates) |
