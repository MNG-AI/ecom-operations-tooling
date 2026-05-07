# Product Image Auditor
 
**Language:** Python  
**Use Case:** eCommerce Operations / Pre-Launch QA  
**Status:** Production — used to audit CDN image availability before site launch
 
---
 
## What This Does
 
Before a product can go live, its photography must exist on the CDN. This script automates that check across every SKU in the master sample list. It constructs the expected image URL for each style/color combination, makes a live request to the CDN, determines whether a real image exists (vs. a placeholder), and writes the result directly back into the workbook.
 
Without this, the check was manual — opening URLs one at a time. At 80–300+ SKUs per week, that wasn't viable.
 
---
 
## What It Checks
 
For each row in a target tab, the script builds a URL:
 
```
https://i8.amplience.net/s/scvl/{style_number}_{color_number}_SET
```
 
It then checks whether the response payload is larger than the known placeholder image size (12,302 bytes). If yes — real image exists. If no — placeholder or missing.
 
---
 
## Output
 
Results are written back to the workbook in two columns:
 
| Column | Field | Value |
|---|---|---|
| T (20) | Image Status | `SHOT` or `NEEDS PHOTO` |
| U (21) | Photo Link | Clickable `HYPERLINK` formula if image confirmed; blank if not |
 
The workbook is saved after each tab completes, so a crash mid-run doesn't lose already-audited tabs.
 
---
 
## Performance
 
- Uses `ThreadPoolExecutor` with **20 concurrent workers** to check all rows in a tab in parallel
- Progress logged every 100 rows
- Runtime scales with tab size and network conditions — a 300-row tab typically completes in under 60 seconds
---
 
## Tabs Audited
 
```
M ATH | W ATH | C ATH | MENS | WOMENS | CHILDRENS | ACCESSORIES
```
 
Tabs not found in the workbook are skipped with a log message. "BGRP Summary" is excluded — different column structure.
 
---
 
## Column Configuration
 
All column positions are defined as constants at the top of the script. If the workbook layout changes, update these values — no other changes needed:
 
```python
COL_STYLE  = 12   # Column L: Ecom Style Number
COL_COLOR  = 13   # Column M: Ecom Color Number
COL_STATUS = 20   # Column T: Output — SHOT / NEEDS PHOTO
COL_LINK   = 21   # Column U: Output — hyperlink to image
```
 
---
 
## Setup & Usage
 
**Install dependencies:**
```bash
pip install openpyxl requests
```
 
**Update the file path** at the top of the script to match your local workbook location:
```python
FILE_PATH = r"C:\path\to\your\Master Sample List 2026.xlsx"
```
 
**Run:**
```bash
python product_image_auditor.py
```
 
**Expected output:**
```
Loading workbook...
 
Auditing tab: M ATH
  Checking 214 rows...
    100/214 checked...
    200/214 checked...
  SHOT: 178 | NEEDS PHOTO: 36
  Saving after M ATH...
  Saved.
 
Auditing tab: W ATH
  ...
 
All tabs complete.
```
 
---
 
## Notes
 
- The placeholder size threshold (`PLACEHOLDER_SIZE = 12302`) was determined by inspecting the Amplience CDN's default response for unresolved image keys. If the CDN changes its placeholder, this value may need to be updated.
- The script uses streaming requests and reads only enough bytes to make the determination — it does not download full images.
- All exceptions (timeouts, connection errors) are caught and treated as "no image found."
---
 
## Context
 
Built to eliminate manual URL checking during pre-launch QA. Deployed against a workbook tracking 1,600+ products. Confirmed image status for hundreds of SKUs per run, reducing pre-launch review time significantly.
 
Part of a broader operations tooling suite — see the repo root for related scripts and governance documentation.
