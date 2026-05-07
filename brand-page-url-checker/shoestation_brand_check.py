"""
shoestation_brand_check.py

Checks each brand's expected URL on shoestation.com using HTTP requests.
Brand list sourced from the official Shoe Station brand directory.

PASS  = server kept URL at the expected brand path (200)
FAIL  = server redirected to /page-not-found (genuine missing page)
ERROR = request failed entirely

Run:
    python shoestation_brand_check.py

Requires:
    pip install requests tqdm
"""

from datetime import datetime

import requests
from tqdm import tqdm

from brand_check_utils import (
    slugify, random_delay,
    save_checkpoint, load_checkpoint, clear_checkpoint,
    write_csv, print_summary,
)

# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------
SITE_URL        = "https://www.shoestation.com"
OUTPUT_CSV      = "shoestation_brand_check_results.csv"
CHECKPOINT_FILE = "shoestation_checkpoint.json"
MAX_RETRIES     = 2
TIMEOUT_SEC     = 15
FIELDNAMES      = ["Brand", "Expected URL", "Final URL", "Status", "Checked At", "Notes"]

HEADERS = {
    "User-Agent": (
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
        "AppleWebKit/537.36 (KHTML, like Gecko) "
        "Chrome/124.0.0.0 Safari/537.36"
    ),
    "Accept-Language": "en-US,en;q=0.9",
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
}

# ---------------------------------------------------------------------------
# Official Shoe Station brand list
# ---------------------------------------------------------------------------
BRANDS = [
    "AETREX", "ALEGRIA", "ASICS", "AW Items", "Academie Gear", "Accessory Innovations",
    "AdTec", "Adidas", "Aerosoles", "Air Walk", "American Glamour BadgleyM", "Anne Klein",
    "Ariat", "Ashley Kahen", "Avalanche", "Avenger Work Boots", "Avia", "Azura", "B-52",
    "BEN SHERMAN", "BOBS", "BOC", "BZEES", "Baby Deer", "Badgley Mischka", "Bandolino",
    "Baretraps", "Bates", "Beach by Matisse", "Bearpaw", "Bebe", "Bella Vita",
    "Bella Vita Italy", "Berness", "Betsey Johnson", "Beverly Hills Polo Club", "Birkenstock",
    "Blowfish Malibu", "Blu D'or", "Blue Aura", "Blundstone", "Bobs Apparel", "Body Glove",
    "Bogg Bag", "Bogs Footwear", "Born", "Brooks", "Brumate", "Bueno", "Bueno Of California",
    "Bull Boxer", "CL By Laundry", "CLOUD90", "Cali Gear", "Calvin Klein", "Capelli New York",
    "Carhartt", "Carolina Boots", "Carters", "Case IH", "Caterpillar", "Catherine Malandrino",
    "Champion", "Charles River Apparel", "Charles by Charles David", "Chelsea Crew",
    "Chic by Lady Couture", "Chinese Laundry", "Chooka", "Christina Royale", "City Classified",
    "Clarks", "Cliffs by White Mountain", "Cobian", "Coconuts by Matisse", "Cole Haan",
    "Columbia", "Comfortiva", "Converse", "Copper Fit", "Corky's", "Cougar",
    "Critter Creations", "Crocs", "Crocs Jibbitz", "Crocs Work", "DC", "DC Comics",
    "DIBA TRUE", "DKNY", "DV BY DOLCE VITA", "Daisy Fuentes", "Dan Post", "Dansko",
    "David and Young", "DeWALT", "Dearfoams", "Deer Stags", "Delicious", "Dingo Boot",
    "Dirty Laundry", "Disney", "Dockers", "Dockers Accessories", "Dolce Vita", "Double-H",
    "Dr. Martens", "Dr. Scholls", "Drive-In Originals", "Dunlop Boots", "Durango",
    "EDDIE BAUER", "Earth Origins", "Eastland", "Easy Spirit", "Easy Street",
    "Easy Works by Easy Street", "Esprit", "Essentials by MUK LUKS", "Etnies", "EuroSoft",
    "Feld Motor Sports INC", "Felipe Stefano", "Fila", "Fireside by Dearfoams", "Flexus",
    "Flojos", "Florsheim", "Florsheim Work", "Four Seasons Handbags", "FreeShield", "Freeman",
    "French Connection", "French Shriner", "French Toast", "Frye & Co.", "Frye Supply",
    "GC Shoes", "GOODYEAR", "GRINCH", "Genuine Grip", "Georgia Boot", "Gloria Vanderbilt",
    "Ground Up", "Guess", "HEYDUDE", "Hammer Head", "Happy Socks", "Harborsides", "Heelys",
    "Hello Kitty", "Henry Ferrara", "Hoka", "Huk", "Hurley", "Impacto",
    "International Harvester", "Ipanema", "Irish Setter", "Iron Age", "Island Surf",
    "It's a Girl Thing", "Italian Shoemakers", "Itasca Sonoma", "J Renee", "JBU", "Jambu",
    "Jansport Sportbags", "Jellypop", "Jessica Simpson", "John Deere by Skechers",
    "Johnston and Murphy", "Jones New York", "Jordan", "Josmo", "Journee Collection",
    "Journee Signature", "Juicy", "Justin Boots", "K-Swiss", "KEEN Utility", "KENSIE",
    "KLOGS Footwear", "Kamik", "Kanga LLC", "Keds", "Keen Outdoor", "Kenneth Cole",
    "Kensie Girl", "Korks", "L'Artiste", "LEGALE", "Lacrosse", "Lady Couture",
    "Lamo Footwear", "Laredo Western Boots", "Laura Ashley", "Lauren Lorraine",
    "Leather Goods by MUK LUKS", "Lee Footwear", "Levi's Accessories", "Levis", "LifeStride",
    "Lily Grace", "London Fog", "London Rag", "Los Cabos", "Lotto", "Lugz", "MARC FISHER",
    "MARVEL", "MARY SQUARE", "MAYIM HYDRATION", "MIA", "MUK LUKS", "Madden", "Madden Girl",
    "Madison Ave.", "Makalu", "Marc Fisher Children's", "Margaritaville", "Me Too", "Merrell",
    "Merrell Work", "Mia Amore", "Michelin", "Minecraft", "Minnetonka", "Muck Boots",
    "Mundi/Westport Corp.", "N by Nina", "NORTH FACE", "NYC Underground", "Natural Steps",
    "Naturalizer", "Nautica", "New Balance", "New Balance Work", "New York and Company",
    "Nickelodeon", "Nicole Miller", "Nike", "Nina", "Nine West", "Ninety Union", "Northikee",
    "Northside", "Nunn Bush", "Nurse Mates", "OMG Accessories", "OUTWOODS", "Oboz Footwear",
    "Olivia Miller", "Oofos", "Oomphies", "OshKosh B'gosh", "PHINS", "PUPPIE LOVE",
    "Pacific Mountain", "Paris Blues", "Patrizia", "Penguin", "Perry Ellis", "Petalia",
    "Pierre Dumas", "Polo", "Powerstep Insoles", "Propet", "Puma", "Puma Safety", "RAWLINGS",
    "REEBOK WORK", "RM by Rebecca Minkoff", "ROAN by BED STU", "RUSH Gordon Rush",
    "Rachel Shoes", "Rachel by Rachel Roy", "Rag & Co", "Rampage", "Reebok", "Reef",
    "Reserved Footwear", "RideTecs", "Rocket Dog", "Rockport", "Rockport Works", "Rocky",
    "Roxy", "Roxy at Work", "Rugged Bear", "Ryka", "SBICCA", "SKECHERS X SNOOP DOGG",
    "SPRING STEP", "STEEL BLUE", "STRAIGHT UP SOUTHERN", "SUN-SAN", "Sail", "Sam & Libby",
    "Sam Edelman", "Sanuk", "Sas", "Saucony", "Self Esteem", "Sesame Street Accessories",
    "Shaboom", "Shaq", "Shu Shop", "Simply Southern", "Skechers", "Skechers Cali",
    "Skechers Go", "Skechers Go Apparel", "Skechers Street", "Skechers Work", "Smart Step",
    "Soda", "Sof Sole", "Softwalk", "Solanz", "Sorel", "Soul Naturalizer", "Sperry",
    "Spiderman Spider Sense", "Splendid", "Squishmallow", "Stacy Adams", "Staheekum",
    "Starter", "Steve Madden", "Stone Canyon", "Stride Rite 360", "Strive", "Sugar",
    "Superfeet", "Superlamb", "TAOS", "TOMS", "TWISTED X", "Tahari", "Taryn Rose", "Tecs",
    "Territory", "Teva", "Thomas & Vine", "Thorogood", "Timberland", "Timberland Pro",
    "Tingley", "Tommy Hilfiger", "Torgeis", "Totes", "Touch Of Nina", "Tretorn", "Trotters",
    "Tuscany by Easy Street", "US Polo Assn", "Under Armour", "Unionbay", "Unisa", "Unr8ed",
    "VINTAGE HAVANA", "Vance Co.", "Vanessa", "Vans", "Very G", "Very Volatile",
    "Vince Camuto", "Vintage 7 Eight", "Vionic", "Volatile", "Volcom Work", "Wanted",
    "Wembley", "Western Chief", "White Mountain", "Winter Tecs", "Wolverine", "Woz",
    "XTRATUF", "Xena", "Xray Footwear", "Y-Not", "Yellow Box",
]


# ---------------------------------------------------------------------------
# Core test logic
# ---------------------------------------------------------------------------

def run_brand_test(session, brand):
    slug         = slugify(brand)
    expected_url = f"{SITE_URL}/{slug}"

    for attempt in range(MAX_RETRIES + 1):
        try:
            response  = session.get(expected_url, timeout=TIMEOUT_SEC, allow_redirects=True)
            final_url = response.url.rstrip("/")
            clean_expected = expected_url.rstrip("/")

            # Only trust server-side redirect behavior — not page content.
            # JS-rendered sites return 200 with placeholder HTML regardless,
            # so page text is unreliable. URL is the only signal we can trust.
            if "page-not-found" in final_url or "404" in final_url:
                status = "FAIL"
                note   = "Redirected to /page-not-found — brand page does not exist"

            elif final_url.lower() == clean_expected.lower():
                status = "PASS"
                note   = ""

            else:
                status = "FAIL"
                note   = f"Redirected away from expected path — landed: {final_url}"

            return {
                "Brand":        brand,
                "Expected URL": expected_url,
                "Final URL":    final_url,
                "Status":       status,
                "Checked At":   datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
                "Notes":        note,
            }

        except requests.exceptions.RequestException as exc:
            if attempt < MAX_RETRIES:
                random_delay(2, 4)
                continue
            return {
                "Brand":        brand,
                "Expected URL": expected_url,
                "Final URL":    "ERROR",
                "Status":       "ERROR",
                "Checked At":   datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
                "Notes":        f"[attempt {attempt + 1}] {exc}",
            }


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

def main():
    results   = load_checkpoint(CHECKPOINT_FILE)
    completed = {r["Brand"] for r in results}
    remaining = [b for b in BRANDS if b not in completed]

    if not remaining:
        print("✅ All brands already completed. Delete the checkpoint file to re-run.")
        write_csv(results, OUTPUT_CSV, FIELDNAMES)
        print_summary(results, OUTPUT_CSV)
        return

    print(f"🔍 Brands to check: {len(remaining)} / {len(BRANDS)}")

    session = requests.Session()
    session.headers.update(HEADERS)

    try:
        for brand in tqdm(remaining, desc="Shoe Station Brand Check"):
            result = run_brand_test(session, brand)
            results.append(result)
            save_checkpoint(results, CHECKPOINT_FILE)
            random_delay(0.5, 1.5)

    finally:
        write_csv(results, OUTPUT_CSV, FIELDNAMES)
        print_summary(results, OUTPUT_CSV)
        clear_checkpoint(CHECKPOINT_FILE)


if __name__ == "__main__":
    main()
