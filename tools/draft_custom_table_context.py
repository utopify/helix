#!/usr/bin/env python3
"""
HELIX Custom Table Context Drafter

Step 3 of the HELIX Context Route (docs/context/context-route.md). Takes the
columns of historical or custom tables (PeopleSoft custom records, Banner Z
tables, legacy warehouse tables) and suggests which HELIX resource and
attribute each column corresponds to, a proposed classification, and a
starter review sheet for the data steward. No data values are needed and no
model is called; a model drafts definitions afterward from this sheet
(templates/context/prompts/draft-definitions.md).

Input: a CSV with at least table_name, column_name. Optional columns:
    data_type, row_count, null_count, distinct_count, min_value, max_value,
    top_values, register_id
(templates/context/profile-table.sql produces exactly this shape.)

Signals used, strongest first:
    1. Bridge source match: the column name equals a delivered source column
       in a HELIX bridge mapping (for example EMPLID, STRM, SFRSTCR_TERM_CODE)
    2. Name match against the HELIX data dictionary after expanding common
       ERP abbreviations (STDNT, ENRL, CRSE, ACAD, AMT, DT, IND, ...)
    3. Definition word overlap

Usage:
    python tools/draft_custom_table_context.py --input profile.csv \
        --source-system banner --out definition-review.csv

Only the standard library is used.
"""
import argparse
import csv
import difflib
import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
csv.field_size_limit(min(sys.maxsize, 2**31 - 1))

ABBREV = {
    "stdnt": "student", "std": "student", "stu": "student", "enrl": "enrollment", "enr": "enrollment",
    "crse": "course", "crs": "course", "acad": "academic", "prog": "program", "plan": "program",
    "strm": "term", "term": "term", "trm": "term", "sess": "session", "dt": "date", "dte": "date",
    "amt": "amount", "amnt": "amount", "nbr": "number", "num": "number", "no": "number", "cd": "code",
    "ind": "flag", "flg": "flag", "yn": "flag", "desc": "description", "descr": "description",
    "pidm": "person", "emplid": "person", "id": "id", "gpa": "gpa", "hrs": "hours", "hr": "hours",
    "cr": "credit", "cred": "credit", "fa": "aid", "finaid": "aid", "awd": "award", "aidy": "year",
    "dept": "department", "org": "org", "inst": "institution", "lvl": "level", "levl": "level",
    "stat": "status", "sts": "status", "rsts": "status", "typ": "type", "eff": "effective",
    "addr": "address", "phn": "phone", "eml": "email", "emal": "email", "dob": "birth",
    "brth": "birth", "sal": "salary", "comp": "compensation", "pos": "position", "posn": "position",
    "job": "job", "athl": "athlete", "athlete": "athlete", "hon": "honor", "honr": "honor",
    "degr": "degree", "deg": "degree", "majr": "major", "maj": "major", "coll": "college",
    "camp": "campus", "resd": "residency", "ethn": "ethnicity", "sex": "gender", "gndr": "gender",
    "vet": "veteran", "intl": "international", "visa": "visa", "hold": "hold", "srvc": "service",
    "gift": "gift", "pldg": "pledge", "cons": "constituent", "donr": "donor", "cmp": "campaign",
}
SENSITIVE = [
    (r"ssn|social_?sec|natl?_?id|nid\b|tax_?id|itin", "restricted", "national identifier"),
    (r"bank|routing|acct_?num|iban|card", "restricted", "financial account number"),
    (r"sai\b|efc|agi|income|tax_?ret|isir|fafsa", "restricted", "GLBA-covered aid or income data"),
    (r"scholar|award_?amt|aid_?amt|disb|loan|pell", "restricted", "financial aid amount (GLBA)"),
    (r"salary|sal_|pay_?rate|comp_?rate|annual_?rt|hourly_?rt", "restricted", "pay data"),
    (r"birth|dob|brth", "confidential", "birth date"),
    (r"visa|sevis|passport|i20", "restricted", "immigration data"),
    (r"medical|disab|accom|health|fmla", "restricted", "health or disability data"),
    (r"race|ethn|gender|sex\b|religion|veteran", "confidential", "demographic data"),
    (r"grade|gpa|hold|discipl|conduct", "confidential", "education record"),
    (r"capacity|wealth|rating", "confidential", "prospect research"),
    (r"email|phone|addr|street|zip|postal", "confidential", "contact information"),
]


AUDIT_COLUMNS = {
    "ACTIVITY_DATE": "meta.updated_at", "USER_ID": "meta.updated_by", "DATA_ORIGIN": "meta.source_system",
    "SURROGATE_ID": "meta.source_key", "VERSION": "meta.version", "VPDI_CODE": "meta.source_partition",
    "LASTUPDDTTM": "meta.updated_at", "LASTUPDOPRID": "meta.updated_by", "SYSTEMMODSTAMP": "meta.updated_at",
    "LASTMODIFIEDDATE": "meta.updated_at", "CREATEDDATE": "meta.created_at",
}
PREFERRED = ["Person", "Student", "Enrollment", "AcademicPeriod", "Employee", "Course", "CourseSection"]


def words(name):
    raw = [w for w in re.split(r"[^a-z0-9]+", name.lower()) if w]
    out = []
    for w in raw:
        if re.fullmatch(r"z+|zz|ps|pstb|tbl|x|u|s", w):
            continue
        out.append(ABBREV.get(w, w))
    return out


def load_dictionary():
    with open(os.path.join(ROOT, "core", "data-dictionary.json")) as fh:
        dd = json.load(fh)
    items = []
    for e in dd.get("entries", []):
        term = e["term"].split(".")[0].split("[")[0]
        if term == "meta":
            continue
        items.append({"resource": e["resource"], "attribute": term,
                      "tokens": set(words(term)), "def_tokens": set(words(e.get("definition", "")))})
    seen, uniq = set(), []
    for i in items:
        k = (i["resource"], i["attribute"])
        if k not in seen:
            seen.add(k)
            uniq.append(i)
    return uniq


def load_bridge_index():
    """delivered source column name -> list of (system, resource, helix attribute)"""
    idx = {}
    for system in ("peoplesoft", "banner", "workday", "colleague", "salesforce"):
        base = os.path.join(ROOT, "bridge", system)
        for dp, dirs, files in os.walk(base):
            dirs[:] = [d for d in dirs if not d.startswith(".")]
            for f in files:
                if not f.endswith(".json"):
                    continue
                with open(os.path.join(dp, f)) as fh:
                    m = json.load(fh)
                res = str(m.get("target_resource", "")).split("/")[0].strip()
                for am in m.get("attribute_mappings", []):
                    for tok in re.findall(r"[A-Za-z][A-Za-z0-9_]{2,}", str(am.get("source", ""))):
                        col = tok.split(".")[-1].upper()
                        if col.startswith("PS_") or len(col) < 3:
                            continue
                        entry = (system, res, am.get("helix_attribute", ""))
                        idx.setdefault(col, []).append(entry)
                        # Banner columns are TABLE_COLUMN: also index the part after the 7-letter table name
                        mm = re.match(r"^[A-Z]{7}_(.+)$", col)
                        if mm:
                            idx.setdefault("~" + mm.group(1), []).append(entry)
    return idx


def strip_table_prefix(colname, table):
    """Banner and many legacy tables prefix every column with the table name."""
    t = (table or "").upper()
    c = colname.upper()
    if t and c.startswith(t + "_"):
        return c[len(t) + 1:]
    return c


def score(colname, dict_items, bridge_idx, source_system, table=""):
    cands = {}
    bare = strip_table_prefix(colname, table)
    hits = [(h, 0.9, "same name as a delivered source column") for h in bridge_idx.get(colname.upper(), [])]
    hits += [(h, 0.75, "same column name as a delivered table") for h in bridge_idx.get("~" + bare, [])]
    for (system, res, attr), base, why in hits:
        k = (res, attr)
        sc = base + (0.05 if system == source_system else 0.0)
        if sc > cands.get(k, (0, ""))[0]:
            cands[k] = (sc, f"{why} ({system})")
    if bare in AUDIT_COLUMNS:
        cands[("(meta)", AUDIT_COLUMNS[bare])] = (0.95, "standard audit column; maps to the HELIX meta block, not an attribute")
    colname = bare
    cw = set(words(colname))
    if cw:
        for it in dict_items:
            inter = cw & it["tokens"]
            if not inter and not (cw & it["def_tokens"]):
                continue
            jac = len(inter) / len(cw | it["tokens"]) if it["tokens"] else 0
            seq = difflib.SequenceMatcher(None, "_".join(sorted(cw)), "_".join(sorted(it["tokens"]))).ratio()
            dov = len(cw & it["def_tokens"]) / len(cw)
            s = 0.55 * jac + 0.3 * seq + 0.15 * dov
            k = (it["resource"], it["attribute"])
            if s > cands.get(k, (0, ""))[0]:
                cands[k] = (round(s, 3), f"name words {sorted(inter) or sorted(cw & it['def_tokens'])}")
    pref = lambda res: PREFERRED.index(res) if res in PREFERRED else len(PREFERRED)
    ranked = sorted(cands.items(), key=lambda kv: (-kv[1][0], pref(kv[0][0])))[:3]
    return [(r, a, round(sc, 2), why) for (r, a), (sc, why) in ranked]


def classify(colname):
    for pat, level, why in SENSITIVE:
        if re.search(pat, colname.lower()):
            return level, why
    return "internal", "no sensitive pattern in the name; steward to confirm"


COLUMNS = ["review_id", "source_system", "source_table", "column_name", "data_type", "profile_summary",
           "register_id", "candidate_1", "candidate_1_score", "candidate_1_reason", "candidate_2",
           "candidate_2_score", "candidate_3", "candidate_3_score", "proposed_classification",
           "classification_reason", "drafted_definition", "drafted_by", "steward_definition",
           "steward_classification", "helix_link", "status", "steward", "reviewed_date", "notes"]


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--input", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--source-system", default="other")
    args = ap.parse_args()

    dict_items = load_dictionary()
    bridge_idx = load_bridge_index()
    rows = []
    with open(args.input, newline="", encoding="utf-8-sig") as fh:
        reader = csv.DictReader(fh)
        reader.fieldnames = [f.strip().lower() for f in reader.fieldnames]
        records = list(reader)
    person_tables = {(r.get("table_name") or "").strip() for r in records
                     if re.search(r"pidm|emplid|student_?id|person_?id|universal_?id|contact_?id|worker",
                                  (r.get("column_name") or "").lower())}
    if True:
        for i, r in enumerate(records, 1):
            col = (r.get("column_name") or "").strip()
            if not col:
                continue
            table = (r.get("table_name") or "").strip()
            cands = score(col, dict_items, bridge_idx, args.source_system, table)
            level, why = classify(strip_table_prefix(col, table))
            if level == "internal" and table in person_tables:
                level, why = "confidential", "table is keyed to a person; treat as an education or employment record unless the steward says otherwise"
            prof = []
            for k in ("row_count", "null_count", "distinct_count", "min_value", "max_value"):
                if (r.get(k) or "").strip():
                    prof.append(f"{k}={r[k].strip()}")
            if (r.get("top_values") or "").strip():
                prof.append(f"top={r['top_values'].strip()[:120]}")
            row = {"review_id": f"CTX-{i:05d}", "source_system": args.source_system,
                   "source_table": (r.get("table_name") or "").strip(), "column_name": col,
                   "data_type": (r.get("data_type") or "").strip(), "profile_summary": "; ".join(prof),
                   "register_id": (r.get("register_id") or "").strip(),
                   "proposed_classification": level, "classification_reason": why,
                   "status": "draft", "drafted_by": "tools/draft_custom_table_context.py"}
            for n, (res, attr, sc, reason) in enumerate(cands, 1):
                row[f"candidate_{n}"] = attr if res == "(meta)" else f"{res}.{attr}"
                row[f"candidate_{n}_score"] = sc
                if n == 1:
                    row["candidate_1_reason"] = reason
            rows.append(row)
    with open(args.out, "w", newline="", encoding="utf-8") as fh:
        w = csv.DictWriter(fh, fieldnames=COLUMNS, extrasaction="ignore")
        w.writeheader()
        w.writerows(rows)
    strong = sum(1 for r in rows if float(r.get("candidate_1_score") or 0) >= 0.6)
    print(f"Columns: {len(rows)}  strong HELIX matches (>= 0.6): {strong}  "
          f"restricted proposals: {sum(1 for r in rows if r['proposed_classification'] == 'restricted')}")
    print(f"Review sheet written: {args.out}")


if __name__ == "__main__":
    main()
