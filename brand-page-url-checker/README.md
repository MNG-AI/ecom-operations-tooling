# Brand Page URL Checker
 
**Language:** Python  
**Use Case:** eCommerce QA / Pre-Launch Brand Page Validation  
**Status:** Production — used to audit brand page availability across both retail banners  
**Scale:** 755 brand URLs checked across Shoe Carnival and Shoe Station
 
---
 
## What This Does
 
Brand pages on eCommerce sites break silently — a redirect to `/page-not-found` looks like a 200 response to a basic check. This tool audits every brand's expected URL on both sites, identifies genuine missing pages by inspecting redirect behavior, and writes results to a CSV for review and action.
 
Before this existed, broken brand links went undetected until a customer hit one or someone manually checked. At 200–300+ brands per banner, manual checking wasn't viable.
 
---
 
## Files in This Folder
 
| File | Description |
|---|---|
| `shoecarnival_brand_check.py` | Audits all brand URLs on shoecarnival.com |
| `shoestation_brand_check.py` | Audits all brand URLs on shoestation.com |
| `brand_check_utils.py` | Shared utility module (see dependency note below) |
 
---
 
## How It Works
 
For each brand in the list:
 
1. Converts the brand name to a URL slug — `"Steve Madden"` → `/steve-madden`
2. Constructs the expected brand page URL
3. Makes an HTTP GET request with redirect following enabled
4. Evaluates the **final URL** after all redirects resolve:
   - Final URL matches expected → **PASS**
   - Final URL contains `/page-not-found` or `/404` → **FAIL**
   - Request fails entirely → **ERROR**
5. Retries up to 2 times on network errors before logging ERROR
6. Saves a checkpoint after each brand — if the run is interrupted, it resumes where it left off
7. Writes final results to CSV
> **Why final URL and not page content?**  
> Both sites are JavaScript-rendered. Page content is unreliable — the server returns 200 with placeholder HTML regardless of whether the brand page exists. The server-side redirect destination is the only trustworthy signal.
 
---
 
## Output
 
Each script writes a CSV file to the working directory:
 
| Column | Description |
|---|---|
| Brand | Brand name as listed in the directory |
| Expected URL | The URL the brand page should be at |
| Final URL | Where the server actually resolved the request |
| Status | `PASS`, `FAIL`, or `ERROR` |
| Checked At | Timestamp of the check |
| Notes | Redirect destination or error message if not PASS |
 
**Shoe Carnival output:** `shoecarnival_brand_check_results.csv`  
**Shoe Station output:** `shoestation_brand_check_results.csv`
 
---
 
## Checkpoint / Resume Behavior
 
Both scripts write a checkpoint JSON file after each brand. If a run is interrupted:
- Delete nothing — just re-run the script
- It will load the checkpoint and skip already-completed brands
- On successful completion, the checkpoint file is automatically deleted
---
 
## Dependency Note
 
Both scripts import from `brand_check_utils.py`. The version in this repo is a documented placeholder that describes the expected interface. The production implementation contains internal infrastructure details not included here.
 
If you are adapting these scripts:
- Implement `slugify()` to match your site's URL convention
- Implement `random_delay()`, `save_checkpoint()`, `load_checkpoint()`, `clear_checkpoint()`, `write_csv()`, and `print_summary()` per the interface described in `brand_check_utils.py`
---
 
## Setup & Usage
 
**Install dependencies:**
```bash
pip install requests tqdm
```
 
**Run Shoe Carnival check:**
```bash
python shoecarnival_brand_check.py
```
 
**Run Shoe Station check:**
```bash
python shoestation_brand_check.py
```
 
**Expected console output:**
```
🔍 Brands to check: 287 / 287
Shoe Carnival Brand Check: 100%|████████████| 287/287 [04:12<00:00]
 
Results written to shoecarnival_brand_check_results.csv
PASS: 241  |  FAIL: 38  |  ERROR: 8
```
 
---
 
## Brand Coverage
 
| Banner | Brands Checked |
|---|---|
| Shoe Carnival | ~287 brands |
| Shoe Station | ~295 brands |
| **Total** | **~755 URLs audited** |
 
Brand lists are sourced from each banner's official brand directory and maintained in the scripts directly.
 
---
 
## Context
 
Built to surface broken brand page links before launch and during routine QA cycles. Identified missing pages across both banners that would otherwise have delivered 404 experiences to customers arriving via brand-specific search traffic.
 
Part of a broader operations tooling suite — see the repo root for related scripts and governance documentation.
 
