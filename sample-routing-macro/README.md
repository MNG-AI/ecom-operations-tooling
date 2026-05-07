# Sample BGRP Routing Macro
 
**Language:** VBA (Excel Macro)  
**Use Case:** eCommerce Operations / Sample Workflow Automation  
**Status:** Production — used in active sample-to-site workflow
 
---
 
## What This Does
 
This macro automates the sorting and routing of product sample data inside an Excel workbook used to manage eCommerce sample intake. Instead of manually copying rows between department tabs, the macro reads each sample's BGRP code and routes the full row to the correct tab automatically.
 
Before this existed, sorting samples by department required manual copy-paste across 12+ tabs — a repetitive, error-prone process at high volume (80–300+ SKUs per week).
 
---
 
## How It Works
 
1. Reads each row from the **"Exceptions Report"** sheet starting at row 3
2. Checks the BGRP code in **Column E**
3. Looks up that code in a pre-defined department mapping
4. Copies columns **A through T** to the next available row in the matching department tab
---
 
## Department Mappings
 
| BGRP Codes | Routes To |
|---|---|
| APRL, BAGS, MISC, PROM, SOX | ACCESSORIES |
| SCB, SCC, SCD, SCS, SINF | CHILDREN'S |
| SCBA, SCGA, SINA | C ATH |
| SMAA, SMAB, SMAC, SMAF, SMAR, SMAT, SMAW | M ATH |
| SMBC, SMCT, SMCU, SMCY, SWAC, SWCJ, SWCT, SWCU | MEN'S CASUAL&WORK |
| SMBU, SMBW, SMDT, SMDU, SMS, SMWA | MEN'S BOOTS-DRESS-SANDAL |
| SWAA, SWAB, SWAF, SWAR, SWAT, SWAW | W ATH |
| SWBT, SWBJ, SWBU | WOMEN'S BOOTS |
| SWDJ, SWDT, SWDU | WOMEN'S DRESS |
| SWPJ, SWSJ | WOMEN'S JUNIOR |
| SWPT, SWPU | WOMEN'S TRAD SPORT & CASUAL |
| SWST, SWSU | WOMENS SANDAL |
 
---
 
## Requirements
 
- Microsoft Excel with macros enabled (.xlsm file)
- A sheet named exactly **"Exceptions Report"** with:
  - Data starting at **row 3** (rows 1–2 reserved for headers)
  - BGRP codes in **Column E**
  - Data spanning **Columns A through T**
- All department tabs listed above must exist in the workbook with exact tab names
---
 
## How to Run It
 
1. Open your `.xlsm` workbook
2. Press `Alt + F11` to open the Visual Basic Editor
3. In the left panel, find your workbook under **"VBAProject"**
4. Right-click **"Modules"** → **Insert** → **Module**
5. Paste the contents of `CopyAllSamplesByBgrp.bas` into the module
6. Close the VBA Editor
7. Press `Alt + F8`, select **CopyAllSamplesByBgrp**, and click **Run**
---
 
## Context
 
Built to support a high-volume eCommerce content and sample operations workflow tracking 1,600+ products across a 6-month period. Reduced manual sorting time and routing errors at peak volume (Back-to-School season, 80–300 SKUs/week).
 
Part of a broader operations tooling suite — see the repo root for related scripts and governance documentation.
