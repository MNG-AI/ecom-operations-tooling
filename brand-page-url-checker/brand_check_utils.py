"""
brand_check_utils.py

Shared utility module used by both brand check scripts:
  - shoecarnival_brand_check.py
  - shoestation_brand_check.py

This file provides the following helpers:

  slugify(brand)
      Converts a brand name to its URL-safe slug.
      Example: "Steve Madden" → "steve-madden"
      Example: "Dr. Scholls" → "dr-scholls"

  random_delay(min_sec, max_sec)
      Sleeps for a random duration between min and max seconds.
      Used to avoid rate-limiting during sequential requests.

  save_checkpoint(results, filepath)
      Writes the current results list to a JSON file.
      Allows a run to resume if interrupted.

  load_checkpoint(filepath)
      Reads and returns results from a checkpoint file.
      Returns an empty list if the file does not exist.

  clear_checkpoint(filepath)
      Deletes the checkpoint file after a successful run.

  write_csv(results, filepath, fieldnames)
      Writes the full results list to a CSV file.

  print_summary(results, filepath)
      Prints a PASS / FAIL / ERROR count to the console
      and confirms the output CSV location.

------------------------------------------------------------
NOTE: This placeholder documents the expected interface.
The production version of this file is not included in
this repository as it contains internal infrastructure
details. The scripts above will not run without it.

If you are adapting these scripts for your own use,
implement the functions above to match your site's
URL slug convention and preferred checkpoint behavior.
------------------------------------------------------------
"""
