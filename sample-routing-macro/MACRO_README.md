# Sample BGRP Routing Macro
 
**Language:** VBA (Excel Macro)  
**Use Case:** eCommerce Operations / Sample Workflow Automation  
**Status:** Production — used in active sample-to-site workflow
 
---
 
## What This Does
 
This macro automates the sorting and routing of product sample data inside an Excel workbook used to manage eCommerce sample intake. Instead of manually copying rows between department tabs, the macro reads each sample's BGRP code and routes the full row to the correct tab automatically.
 
Before this existed, sorting samples by department required manual copy-paste across 12+ tabs — a repetitive, error-prone process at high volume (80–300+ SKUs per week).
 
---
 
## Files in This Folder
 
| File | Version | Use |
|---|---|---|
| `CopyAllSamplesByBgrp.bas` | v1 | Original — core routing only |
| `CopyAllSamplesByBgrp_Clean.bas` | v2 | Adds duplicate removal by Ecom Color # |
| `CopyAllSamplesByBgrp_v3.bas` | v3 | Adds On Hand inventory sync + yellow change flagging |
| `CopyAllSamplesByBgrp_v4.bas` | v4 | Major expansion — live formulas, visual alerts, sort, column management |
 
**Use v4 for production.** Earlier versions are retained for reference and rollback.
 
---
 
## Execution Order (v4)
 
Each run performs four steps automatically:
 
1. **Route + Enrich** — reads BGRP code (Col E), copies rows A:T to department tabs, then adds:
   - Column S: live VLOOKUP formula → On Hand from Exceptions Report
   - Column W: Keep Priority flag (1 if notes exist in Col V, else 0)
   - Column U: date the row was added
   - Full row highlighted **light blue**
   - Column S highlighted **pink** if On Hand < 100
2. **Sort** — each department tab sorted by Ecom Color # (Col M) ascending, then Keep Priority (Col W) descending
3. **Deduplicate** — removes duplicate rows using Ecom Color # (Col M) as the unique key; preserves notes in columns U and V
4. **Hide Columns** — hides buyer-internal columns (A, C, D, G, K, O, P, Q, R, T) from the department content view; resets visibility on each run to prevent stacking
---
 
## Column Reference
 
| Column | Field | Role |
|---|---|---|
| E | BGRP | Routing key |
| M | Ecom Color # | Dedup key, sort key, VLOOKUP lookup value |
| S (19) | On Hand | Live VLOOKUP in v4; static copy in v1–v2; refreshed separately in v3 |
| U (21) | Date Added | Stamped on each new row (v4 only) |
| V (22) | Notes | Preserved across dedup; drives Keep Priority |
| W (23) | Keep Priority | Formula: 1 if notes exist, else 0 (v4 only) |
 
---
 
## Department Mappings
 
| BGRP Codes | Routes To |
|---|---|
| APRL, BAGS, MISC, PROM, SOX | ACCESSORIES |
| SCB, SCC, SCD, SCS, SINF | CHILDREN'S |
| SCBA, SCGA, SINA | C ATH |
| SMAA, SMAB, SMAC, SMAF, SMAR, SMAT, SMAW | M ATH |
| SMBC, SMCT, SMCU, SMCY | MEN'S CASUAL&WORK |
| SMBU, SMBW, SMDT, SMDU, SMS, SMWA | MEN'S BOOTS-DRESS-SANDAL |
| SWAA, SWAB, SWAF, SWAR, SWAT, SWAW, SWAC | W ATH |
| SWBT, SWBJ, SWBU | WOMEN'S BOOTS |
| SWDJ, SWDT, SWDU | WOMEN'S DRESS |
| SWPJ, SWSJ, SWCJ | WOMEN'S JUNIOR |
| SWPT, SWPU, SWCT, SWCU | WOMEN'S TRAD SPORT & CASUAL |
| SWST, SWSU | WOMENS SANDAL |
 
---
 
## Requirements
 
- Microsoft Excel with macros enabled (.xlsm file)
- A sheet named exactly **"Exceptions Report"** with:
  - Data starting at **row 3** (rows 1–2 are title/headers)
  - BGRP codes in **Column E**
  - Ecom Color # in **Column M**
  - On Hand values in **Column S** (used by VLOOKUP in v4)
  - Data spanning **Columns A through T**
  - Notes in **Columns U and V** (preserved during dedup)
- All department tabs must exist with exact names as listed above
---
 
## How to Run
 
1. Open your `.xlsm` workbook
2. Press `Alt + F11` to open the Visual Basic Editor
3. Right-click **Modules** → **Insert** → **Module**
4. Paste the full contents of `CopyAllSamplesByBgrp_v4.bas`
5. Close the VBA Editor
6. Press `Alt + F8` → select **CopyAllSamplesByBgrp_Clean** → click **Run**
A confirmation message appears when all four steps complete.
 
---
 
## Version Changelog
 
| Feature | v1 | v2 | v3 | v4 |
|---|---|---|---|---|
| BGRP routing | ✅ | ✅ | ✅ | ✅ |
| Dynamic last-row detection | ❌ | ✅ | ✅ | ✅ |
| Duplicate removal | ❌ | ✅ | ✅ | ✅ |
| Notes preservation (U, V) | ❌ | ✅ | ✅ | ✅ |
| On Hand — static copy | ✅ | ✅ | — | — |
| On Hand — refresh subroutine | ❌ | ❌ | ✅ | — |
| On Hand — live VLOOKUP formula | ❌ | ❌ | ❌ | ✅ |
| Low inventory pink flag (<100) | ❌ | ❌ | ❌ | ✅ |
| New row light blue highlight | ❌ | ❌ | ❌ | ✅ |
| Date Added stamp (Col U) | ❌ | ❌ | ❌ | ✅ |
| Keep Priority formula (Col W) | ❌ | ❌ | ❌ | ✅ |
| Sort by Color # + Priority | ❌ | ❌ | ❌ | ✅ |
| Hide buyer columns | ❌ | ❌ | ❌ | ✅ |
 
---
 
## Context
 
Built to support a high-volume eCommerce content and sample operations workflow tracking 1,600+ products across a 6-month period. Reduced manual sorting time and routing errors at peak volume (Back-to-School season, 80–300 SKUs/week).
 
Part of a broader operations tooling suite — see the repo root for related scripts and governance documentation.
 
Built to support a high-volume eCommerce content and sample operations workflow tracking 1,600+ products across a 6-month period. Reduced manual sorting time and routing errors at peak volume (Back-to-School season, 80–300 SKUs/week).
 
Part of a broader operations tooling suite — see the repo root for related scripts and governance documentation.
