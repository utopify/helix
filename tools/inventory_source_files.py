#!/usr/bin/env python3
"""
HELIX Source File Inventory

Fingerprints code that lives on servers rather than in the database: SQR,
COBOL, Pro*C, shell scripts, SQL*Plus scripts, and the like. Run it against
the vendor-delivered directory (or release media) and against the installed
or custom directory, then compare the two outputs with
tools/diff_customizations.py.

Typical pairs:
    PeopleSoft:  PS_HOME/sqr          vs  PS_CUST_HOME/sqr (or PS_HOME on servers without one)
    Banner:      release deliverables vs  $BANNER_HOME on the job server

Output columns match the HELIX inventory format:
    object_type, object_name, sub_key, seq, owner, last_updated,
    last_updated_by, fingerprint, lines_of_code

Usage:
    python tools/inventory_source_files.py --root /mnt/ps_home/sqr --out baseline_files.csv
    python tools/inventory_source_files.py --root /mnt/ps_cust_home/sqr --out production_files.csv

Matching is by file name and relative folder, so delivered and custom copies
of the same program line up. Whitespace is normalized before hashing.
Only the standard library is used.
"""
import argparse
import csv
import datetime
import hashlib
import os
import re

TYPES = {
    ".sqr": "SQR", ".sqc": "SQR_INCLUDE",
    ".cbl": "COBOL", ".cob": "COBOL", ".cpy": "COBOL_COPYBOOK",
    ".pc": "PROC", ".h": "C_HEADER", ".c": "C",
    ".sql": "SQL_SCRIPT", ".pls": "PLSQL", ".plb": "PLSQL_WRAPPED", ".pkb": "PLSQL", ".pks": "PLSQL",
    ".sh": "SHELL", ".ksh": "SHELL", ".csh": "SHELL", ".bat": "BATCH", ".cmd": "BATCH",
    ".ctl": "SQLLOADER_CONTROL", ".par": "PARAMETER_FILE",
    ".rpt": "CRYSTAL", ".xdo": "BI_PUBLISHER", ".rtf": "BI_PUBLISHER_TEMPLATE",
    ".py": "PYTHON", ".pl": "PERL", ".java": "JAVA",
}
WS = re.compile(rb"\s+")


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--root", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--owner", default="", help="label for the owner column, e.g. PS_HOME or BANNER_HOME")
    ap.add_argument("--all-files", action="store_true", help="include files with unrecognized extensions")
    args = ap.parse_args()

    rows = []
    for dp, dirs, files in os.walk(args.root):
        dirs[:] = [d for d in dirs if not d.startswith(".")]
        for f in files:
            ext = os.path.splitext(f)[1].lower()
            otype = TYPES.get(ext)
            if not otype and not args.all_files:
                continue
            path = os.path.join(dp, f)
            with open(path, "rb") as fh:
                data = fh.read()
            loc = sum(1 for line in data.splitlines() if line.strip())
            fp = hashlib.sha256(WS.sub(b" ", data).strip()).hexdigest()
            rel = os.path.relpath(dp, args.root)
            mtime = datetime.datetime.fromtimestamp(os.path.getmtime(path)).strftime("%Y-%m-%d %H:%M:%S")
            rows.append({
                "object_type": otype or "FILE",
                "object_name": f,
                "sub_key": "" if rel == "." else rel.replace(os.sep, "/"),
                "seq": 1,
                "owner": args.owner,
                "last_updated": mtime,
                "last_updated_by": "",
                "fingerprint": fp,
                "lines_of_code": loc,
            })

    cols = ["object_type", "object_name", "sub_key", "seq", "owner", "last_updated",
            "last_updated_by", "fingerprint", "lines_of_code"]
    with open(args.out, "w", newline="", encoding="utf-8") as fh:
        w = csv.DictWriter(fh, fieldnames=cols)
        w.writeheader()
        w.writerows(sorted(rows, key=lambda r: (r["object_type"], r["sub_key"], r["object_name"])))
    print(f"{len(rows)} files fingerprinted under {args.root}")
    print(f"Written: {args.out}")


if __name__ == "__main__":
    main()
