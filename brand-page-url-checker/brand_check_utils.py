"""
brand_check_utils.py
Shared utilities for Shoe Station and Shoe Carnival brand page checkers.
Place this file in the same folder as both brand check scripts.
"""

import re
import time
import random
import csv
import os
import json


# ---------------------------------------------------------------------------
# URL / slug helpers
# ---------------------------------------------------------------------------

def slugify(brand: str) -> str:
    """
    Convert a brand name to the URL slug format used by both sites.

    Rules confirmed against live URLs:
        Spaces        -> underscores
        Hyphens       -> preserved  (K-Swiss  -> k-swiss)
        Periods       -> preserved  (Dr.      -> dr.)
        Apostrophes   -> removed    (B'gosh   -> bgosh)
        Ampersands    -> removed    (Rag & Co -> rag_co)
        Commas        -> removed

    Examples:
        "Steve Madden"   -> "steve_madden"
        "Dr. Scholls"    -> "dr._scholls"
        "L'Artiste"      -> "lartiste"
        "Rag & Co"       -> "rag_co"
        "OshKosh B'gosh" -> "oshkosh_bgosh"
        "K-Swiss"        -> "k-swiss"
        "B-52"           -> "b-52"
    """
    s = brand.lower()
    s = re.sub(r"[''']", "", s)         # remove apostrophes
    s = re.sub(r"[,&]", "", s)          # remove commas and ampersands
    s = re.sub(r"\s+", "_", s.strip())  # spaces -> underscores
    s = re.sub(r"_{2,}", "_", s)        # collapse double-underscores
    return s


def brand_in_url(brand: str, url: str) -> bool:
    """
    Return True if the brand's expected slug appears in the URL path.
    Query params and fragments are stripped before comparison.
    """
    slug = slugify(brand)
    path = url.lower().split("?")[0].split("#")[0]
    return slug in path


# ---------------------------------------------------------------------------
# Timing helpers
# ---------------------------------------------------------------------------

def random_delay(min_s: float = 0.5, max_s: float = 1.5) -> None:
    """Brief pause between requests to avoid hammering the server."""
    time.sleep(random.uniform(min_s, max_s))


# ---------------------------------------------------------------------------
# Checkpoint / resume
# ---------------------------------------------------------------------------

def save_checkpoint(results: list, path: str) -> None:
    """Persist completed results to disk after every brand so runs can resume."""
    with open(path, "w", encoding="utf-8") as f:
        json.dump(results, f, indent=2)


def load_checkpoint(path: str) -> list:
    """Load previously saved results. Returns [] if no checkpoint exists."""
    if os.path.exists(path):
        with open(path, encoding="utf-8") as f:
            data = json.load(f)
        print(f"▶  Checkpoint found — {len(data)} brand(s) already completed.")
        return data
    return []


def clear_checkpoint(path: str) -> None:
    """Delete the checkpoint file after a clean run."""
    if os.path.exists(path):
        os.remove(path)


# ---------------------------------------------------------------------------
# CSV output
# ---------------------------------------------------------------------------

def write_csv(results: list, output_file: str, fieldnames: list) -> None:
    with open(output_file, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(results)


# ---------------------------------------------------------------------------
# Summary printer
# ---------------------------------------------------------------------------

def print_summary(results: list, output_file: str) -> None:
    passes = sum(1 for r in results if r["Status"] == "PASS")
    fails  = sum(1 for r in results if r["Status"] == "FAIL")
    errors = sum(1 for r in results if r["Status"] == "ERROR")
    total  = len(results)

    print(f"\n{'='*50}")
    print(f"  Total checked : {total}")
    print(f"  ✅ PASS        : {passes}")
    print(f"  ❌ FAIL        : {fails}")
    print(f"  ⚠️  ERROR       : {errors}")
    print(f"{'='*50}")
    print(f"  📄 Results saved to: {output_file}\n")
