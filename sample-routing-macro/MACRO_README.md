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
 
**Use v3 for production.** v1 and v2 are retained for reference and rollback.
 
---
 
## Execution Order (v3)
 
Each run performs three steps automatically:
 
1. **Route** — reads BGRP code (Column E) from "Exceptions Report" and copies each row to the matching department tab
2. **Deduplicate** — removes duplicate entries in each department tab using Ecom Color # (Column M) as the unique key; preserves notes in columns U and V
3. **Sync On Hand** — reads Column S (On Hand inventory) from "Exceptions Report" and pushes updated values to matching rows in department tabs; highlights changed cells yellow
---
 
## Department Mappings (v3)
 
| BGRP Codes | Routes To |
|---|---|
| APRL, BAGS, MISC, PROM, SOX | ACCESSORIES |
| SCB, SCC, SCD, SCS, SINF | CHILDREN'S |
| SCBA, SCGA, SINA | C ATH |
| SMAA, SMAB, SMAC, SMAF, SMAR, SMAT, SMAW | M ATH |
| SMBC, SMCT, SMCU, SMCY | MEN'S CASUAL&WORK |
| SMBU, SMBW, SMDT, SMDU, SMS, SMWA | MEN'S BOOTS-DRESS-SANDAL |
| SWAA, SWAB, SWAF, SWAR, SWAT, SWAW, **SWAC** | W ATH |
| SWBT, SWBJ, SWBU | WOMEN'S BOOTS |
| SWDJ, SWDT, SWDU | WOMEN'S DRESS |
| SWPJ, SWSJ, **SWCJ** | WOMEN'S JUNIOR |
| SWPT, SWPU, **SWCT**, **SWCU** | WOMEN'S TRAD SPORT & CASUAL |
| SWST, SWSU | WOMENS SANDAL |
 
**Bold** = reclassified in v3 from MEN'S CASUAL&WORK to correct women's tabs.
 
---
 
## Requirements
 
- Microsoft Excel with macros enabled (.xlsm file)
- A sheet named exactly **"Exceptions Report"** with:
  - Data starting at **row 3** (rows 1–2 are title/headers)
  - BGRP codes in **Column E**
  - Ecom Color # in **Column M**
  - On Hand values in **Column S** (used by v3 sync)
  - Data spanning **Columns A through T**
  - Notes in **Columns U and V** (preserved during dedup)
- All department tabs must exist with exact names as listed above
---
 
## How to Run
 
1. Open your `.xlsm` workbook
2. Press `Alt + F11` to open the Visual Basic Editor
3. Right-click **Modules** under your workbook → **Insert** → **Module**
4. Paste the full contents of `CopyAllSamplesByBgrp_v3.bas`
5. Close the VBA Editor
6. Press `Alt + F8` → select **CopyAllSamplesByBgrp_Clean** → click **Run**
A confirmation message appears when all three steps complete.
 
---
 
## Version Changelog
 
| Feature | v1 | v2 | v3 |
|---|---|---|---|
| BGRP routing | ✅ | ✅ | ✅ |
| Row limit method | Hardcoded (3000) | Dynamic | Dynamic |
| Duplicate removal | ❌ | ✅ | ✅ |
| Notes preservation (U, V) | ❌ | ✅ | ✅ |
| On Hand sync from source | ❌ | ❌ | ✅ |
| Changed cells highlighted yellow | ❌ | ❌ | ✅ |
| SWAC/SWCJ/SWCT/SWCU corrected | ❌ | ❌ | ✅ |
 
---
 
## Context
 
Built to support a high-volume eCommerce content and sample operations workflow tracking 1,600+ products across a 6-month period. Reduced manual sorting time and routing errors at peak volume (Back-to-School season, 80–300 SKUs/week).
 
Part of a broader operations tooling suite — see the repo root for related scripts and governance documentation.
 
Built to support a high-volume eCommerce content and sample operations workflow tracking 1,600+ products across a 6-month period. Reduced manual sorting time and routing errors at peak volume (Back-to-School season, 80–300 SKUs/week).
 
Part of a broader operations tooling suite — see the repo root for related scripts and governance documentation.
