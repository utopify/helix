#!/usr/bin/env python3
"""
HELIX Customization Diff

Compares an inventory of a vanilla (baseline) installation with an inventory
of production and writes a customization register: one row for every object
that was added, modified, or removed compared to vanilla.

Inputs are CSV files produced by the inventory queries in
templates/customization-discovery/{peoplesoft,banner}/ or by
tools/inventory_source_files.py. Required columns:

    object_type, object_name

Optional columns (used when present):

    sub_key, seq, owner, last_updated, last_updated_by,
    definition_text  (or fingerprint, if you hashed in the database),
    usage_runs, usage_last_run, local_name_flag, lines_of_code

Rows that share object_type + owner + object_name + sub_key are one object.
Their definition_text is joined in seq order, whitespace is normalized, and
the result is hashed. Two objects match when their hashes match.

Usage:
    python tools/diff_customizations.py \
        --baseline baseline.csv --production production.csv \
        --source-system banner --source-release "9.x (fill in)" \
        --out customization-register.csv

Options:
    --case-insensitive   compare text ignoring case (useful for SQL and PL/SQL)
    --ignore-owner       match objects across schemas (useful when vanilla was
                         installed under different schema names)
    --include-unchanged  also write rows for objects that match vanilla

Only the standard library is used. Python 3.8 or later.
"""
import argparse
import csv
import hashlib
import re
import sys
from collections import defaultdict

csv.field_size_limit(min(sys.maxsize, 2**31 - 1))

REGISTER_COLUMNS = [
    "customization_id", "source_system", "source_release", "object_type", "object_name",
    "sub_key", "owner", "change_type", "baseline_fingerprint", "production_fingerprint",
    "last_updated", "last_updated_by", "lines_of_code", "usage_runs_12mo", "usage_last_run",
    "local_name_flag", "functional_area", "business_owner", "helix_resources_touched",
    "complexity", "disposition", "target_platform", "target_object", "conversion_tool",
    "conversion_status", "reviewer", "verified_date", "notes",
]

WS = re.compile(r"\s+")


def norm_key(row, ignore_owner):
    owner = "" if ignore_owner else (row.get("owner") or "").strip().upper()
    return (
        (row.get("object_type") or "").strip().upper(),
        owner,
        (row.get("object_name") or "").strip().upper(),
        (row.get("sub_key") or "").strip().upper(),
    )


def seq_of(row):
    try:
        return float(row.get("seq") or 0)
    except ValueError:
        return 0.0


def load(path, ignore_owner, case_insensitive):
    groups = defaultdict(list)
    with open(path, newline="", encoding="utf-8-sig") as fh:
        reader = csv.DictReader(fh)
        if reader.fieldnames is None:
            sys.exit(f"{path}: empty file")
        fields = [f.strip().lower() for f in reader.fieldnames]
        reader.fieldnames = fields
        for need in ("object_type", "object_name"):
            if need not in fields:
                sys.exit(f"{path}: missing required column '{need}'")
        for row in reader:
            if not (row.get("object_type") or "").strip():
                continue
            groups[norm_key(row, ignore_owner)].append(row)

    objects = {}
    for key, rows in groups.items():
        rows.sort(key=seq_of)
        first = rows[0]
        if (first.get("fingerprint") or "").strip():
            fp = first["fingerprint"].strip().lower()
            loc = (first.get("lines_of_code") or "").strip()
        else:
            text = "\n".join((r.get("definition_text") or "") for r in rows)
            loc = sum(1 for line in text.splitlines() if line.strip())
            text = WS.sub(" ", text).strip()
            if case_insensitive:
                text = text.upper()
            fp = hashlib.sha256(text.encode("utf-8")).hexdigest()
        latest = max(rows, key=lambda r: (r.get("last_updated") or ""))
        objects[key] = {
            "fingerprint": fp,
            "lines_of_code": loc,
            "last_updated": (latest.get("last_updated") or "").strip(),
            "last_updated_by": (latest.get("last_updated_by") or "").strip(),
            "usage_runs_12mo": (first.get("usage_runs") or "").strip(),
            "usage_last_run": (first.get("usage_last_run") or "").strip(),
            "local_name_flag": (first.get("local_name_flag") or "").strip(),
            "owner": (first.get("owner") or "").strip(),
            "display": (
                (first.get("object_type") or "").strip(),
                (first.get("object_name") or "").strip(),
                (first.get("sub_key") or "").strip(),
            ),
        }
    return objects


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--baseline", required=True)
    ap.add_argument("--production", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--source-system", required=True, help="peoplesoft, banner, colleague, or other")
    ap.add_argument("--source-release", default="")
    ap.add_argument("--case-insensitive", action="store_true")
    ap.add_argument("--ignore-owner", action="store_true")
    ap.add_argument("--include-unchanged", action="store_true")
    args = ap.parse_args()

    base = load(args.baseline, args.ignore_owner, args.case_insensitive)
    prod = load(args.production, args.ignore_owner, args.case_insensitive)

    rows = []
    counts = defaultdict(int)
    for key in sorted(set(base) | set(prod)):
        b, p = base.get(key), prod.get(key)
        if b and p:
            change = "unchanged" if b["fingerprint"] == p["fingerprint"] else "modified"
        elif p:
            change = "added"
        else:
            change = "removed"
        counts[change] += 1
        if change == "unchanged" and not args.include_unchanged:
            continue
        src = p or b
        otype, oname, sub = src["display"]
        rows.append({
            "source_system": args.source_system,
            "source_release": args.source_release,
            "object_type": otype,
            "object_name": oname,
            "sub_key": sub,
            "owner": src["owner"],
            "change_type": change,
            "baseline_fingerprint": b["fingerprint"][:16] if b else "",
            "production_fingerprint": p["fingerprint"][:16] if p else "",
            "last_updated": src["last_updated"],
            "last_updated_by": src["last_updated_by"],
            "lines_of_code": src["lines_of_code"],
            "usage_runs_12mo": src["usage_runs_12mo"],
            "usage_last_run": src["usage_last_run"],
            "local_name_flag": src["local_name_flag"],
            "disposition": "",
            "conversion_status": "not_started",
        })

    prefix = {"peoplesoft": "PS", "banner": "BN", "colleague": "CL"}.get(args.source_system.lower(), "XX")
    for i, r in enumerate(rows, 1):
        r["customization_id"] = f"{prefix}-{i:05d}"

    with open(args.out, "w", newline="", encoding="utf-8") as fh:
        w = csv.DictWriter(fh, fieldnames=REGISTER_COLUMNS, extrasaction="ignore")
        w.writeheader()
        w.writerows(rows)

    by_type = defaultdict(lambda: defaultdict(int))
    for r in rows:
        by_type[r["object_type"]][r["change_type"]] += 1

    print(f"Baseline objects:    {len(base)}")
    print(f"Production objects:  {len(prod)}")
    print(f"Added:     {counts['added']}")
    print(f"Modified:  {counts['modified']}")
    print(f"Removed:   {counts['removed']}")
    print(f"Unchanged: {counts['unchanged']}")
    print("\nBy object type (added / modified / removed):")
    for t in sorted(by_type):
        c = by_type[t]
        print(f"  {t:<22} {c['added']:>6} {c['modified']:>6} {c['removed']:>6}")
    print(f"\nRegister written: {args.out} ({len(rows)} rows)")


if __name__ == "__main__":
    main()
