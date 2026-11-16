#!/usr/bin/env python3
"""
HELIX Context Pack Builder

Generates the context layer for every HELIX silver table and gold metric from
files already in the repo, so definitions live with the data model instead of
inside a vendor's semantic layer.

Reads:
    core/resources/*.json            schemas (descriptions, required, code set bindings)
    core/data-dictionary.json        definitions, classification, FERPA and GLBA flags
    core/terminologies/*.json        code sets
    govern/access-control-matrix.json  domains, column exceptions
    govern/domain-taxonomy.json      stewards and regulatory context
    templates/context/gold-metrics.yaml  gold metric definitions (needs PyYAML; skipped if missing)

Writes to templates/context/generated/ (or --out):
    glue-business-context.json   one entry per silver table: description, columns,
                                 glossary terms, custom metadata, table parameters
    skills/<resource>.md         one skill file per resource (grain, keys, joins,
                                 filters, code sets, access rules)
    gold-skills/<metric>.md      one skill file per gold metric
    helix-ontology.ttl           W3C ontology: OWL classes and properties, SKOS
                                 concept schemes for code sets
    MANIFEST.json                what was generated, from which HELIX version

Usage:
    python tools/build_context_pack.py
    python tools/build_context_pack.py --out /tmp/context --database helix_silver

Only the standard library is required. PyYAML adds the gold metric outputs.
"""
import argparse
import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

ACRONYMS = {"ferpa": "FERPA", "gl": "GL", "ap": "AP", "ar": "AR", "sap": "SAP"}
DISPLAY = {"ferpa_restriction": "FERPARestriction", "gl_transaction": "GLTransaction",
           "ap_voucher": "APVoucher", "ar_transaction": "ARTransaction",
           "sap_evaluation": "SAPEvaluation", "return_of_title_iv": "ReturnOfTitleIV"}

# _ref attribute -> HELIX resource it points to (for join paths and ontology object properties)
REF_TARGETS = {
    "student_ref": "student", "person_ref": "person", "employee_ref": "employee",
    "course_ref": "course", "course_section_ref": "course_section", "program_ref": "program",
    "primary_program_ref": "program", "academic_period_ref": "academic_period",
    "period_ref": "academic_period", "term_ref": "academic_period", "admit_period_ref": "academic_period",
    "start_period_ref": "academic_period", "expected_completion_period_ref": "academic_period",
    "conferral_period_ref": "academic_period", "academic_org_ref": "academic_org",
    "parent_org_ref": "academic_org", "degree_ref": "degree", "primary_degree_ref": "degree",
    "constituent_ref": "constituent", "campaign_ref": "campaign", "pledge_ref": "gift",
    "linked_gift_ref": "gift", "fin_aid_award_ref": "fin_aid_award", "aid_application_ref": "aid_application",
    "position_ref": "position", "incumbent_ref": "employee", "supervisor_ref": "employee",
    "advisor_ref": "employee", "assessor_ref": "employee", "officer_ref": "employee",
    "grant_ref": "grant", "contract_ref": "contract", "requisition_ref": "requisition",
    "equivalent_course_ref": "course",
}

REQUIRED_FILTERS = {
    "student": ["Count enrolled students from Enrollment at census, not from student.status alone"],
    "enrollment": ["Exclude enrollment_status dropped and auditing when counting enrollment",
                   "For official counts, use rows as of academic_period.census_date"],
    "fin_aid_award": ["Exclude award_status declined and cancelled from totals"],
    "aid_package": ["Use packaging_status packaged or finalized for reporting"],
    "employee": ["Filter employment_status for active headcount; use an as-of date for history"],
    "gift": ["Don't add pledge payments to pledges in the same total (CASE rules)"],
    "constituent": ["Exclude status do_not_solicit and do_not_contact from any outreach list"],
    "admission_application": ["Count each applicant once per admit period and application type"],
}


def title_case(key):
    return DISPLAY.get(key, "".join(ACRONYMS.get(w, w.capitalize()) for w in key.split("_")))


def load_json(*parts):
    with open(os.path.join(ROOT, *parts)) as fh:
        return json.load(fh)


def first_sentence(text, limit=240):
    text = re.sub(r"\s+", " ", (text or "").strip())
    if len(text) <= limit:
        return text
    cut = text[:limit]
    return cut[: cut.rfind(" ")] + "..."


def clean(text):
    """Plain punctuation for generated prose."""
    text = (text or "").replace(" \u2014 ", ", ").replace("\u2014", ", ").replace(" \u2013 ", " to ").replace("\u2013", "-")
    return text


def pattern_definition(attr, spec, ref_target=None):
    """Fallback when HELIX has no written definition. Marked so stewards can replace it."""
    words = attr.replace("_ref", "").replace("_", " ").strip()
    phrase = words[:1].upper() + words[1:]
    typ = spec.get("type") if isinstance(spec.get("type"), str) else ""
    if ref_target:
        return f"HELIX ID of the related {ref_target} record."
    if attr.startswith("is_") or attr.endswith("_flag") or typ == "boolean":
        return f"{phrase.replace(' flag', '')}: true or false."
    if spec.get("format") in ("date", "date-time") or attr.endswith("_date"):
        return f"{phrase}."
    if typ in ("number", "integer"):
        return f"{phrase} (numeric)."
    return f"{phrase}."


def ttl_str(s):
    s = clean(s)
    return '"' + (s or "").replace("\\", "\\\\").replace('"', '\\"').replace("\n", " ") + '"'


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--out", default=os.path.join(ROOT, "templates", "context", "generated"))
    ap.add_argument("--database", default="helix_silver", help="Glue database for silver tables")
    ap.add_argument("--gold-database", default="helix_gold")
    ap.add_argument("--helix-version", default="")
    args = ap.parse_args()

    rdir = os.path.join(ROOT, "core", "resources")
    schemas = {f[:-5]: load_json("core", "resources", f) for f in sorted(os.listdir(rdir)) if f.endswith(".json")}
    dd = load_json("core", "data-dictionary.json")
    tdir = os.path.join(ROOT, "core", "terminologies")
    terms = {}
    for f in sorted(os.listdir(tdir)):
        if f.endswith(".json"):
            t = load_json("core", "terminologies", f)
            terms[t["code_system"]] = t
    acm = load_json("govern", "access-control-matrix.json")
    taxonomy = load_json("govern", "domain-taxonomy.json")

    entries = {}
    for e in dd.get("entries", []):
        key = os.path.basename(e.get("source_file", ""))[:-5]
        entries.setdefault(key, {})[e["term"]] = e

    domain_of, col_rules = {}, {}
    for d in acm.get("matrix", []):
        for r in d.get("resources", []):
            domain_of[r] = d["domain"]
        for ce in d.get("column_exceptions", []) or []:
            col_rules.setdefault(ce.get("resource"), []).append(ce)
    steward_of = {}
    for d in taxonomy.get("domains", []):
        for r in d.get("helix_resources", []):
            steward_of[r] = {"steward": d.get("typical_steward", ""), "trustee": d.get("typical_trustee", ""),
                             "regulatory": d.get("regulatory_context", [])}

    os.makedirs(os.path.join(args.out, "skills"), exist_ok=True)
    os.makedirs(os.path.join(args.out, "gold-skills"), exist_ok=True)

    referenced_by = {}
    for key, s in schemas.items():
        for attr in s.get("properties", {}):
            tgt = REF_TARGETS.get(attr)
            if tgt and tgt in schemas and tgt != key:
                referenced_by.setdefault(tgt, []).append((key, attr))

    glue_tables = []
    pattern_count = [0]
    for key, s in schemas.items():
        name = title_case(key)
        props = s.get("properties", {})
        meta = props.get("meta", {}).get("properties", {})
        classification = meta.get("classification", {}).get("default", "confidential")
        ferpa = meta.get("ferpa_flags", {}).get("properties", {}) if "ferpa_flags" in meta else {}
        is_edu = bool(ferpa) and ferpa.get("is_education_record", {}).get("default", True)
        dentries = entries.get(key, {})
        glba = any(v.get("glba") for v in dentries.values())
        steward = steward_of.get(name, {})
        bindings = {}
        columns = []
        for attr, spec in props.items():
            if attr == "meta" or not isinstance(spec, dict):
                continue
            de = dentries.get(attr, {})
            cs = [c for c in re.findall(r"helix/[a-z0-9\-]+", json.dumps(spec)) if c in terms]
            if cs:
                bindings[attr] = cs[0]
            written = de.get("definition") or spec.get("description") or ""
            if re.fullmatch(r"\s*Bound to HELIX terminology: helix/[a-z0-9\-]+\.?\s*", written or ""):
                written = ""
            ref_t = title_case(REF_TARGETS[attr]) if attr in REF_TARGETS and REF_TARGETS[attr] in schemas else None
            if written:
                desc, status = clean(first_sentence(written)), "written"
            else:
                desc, status = pattern_definition(attr, spec, ref_t), "pattern"
                pattern_count[0] += 1
            if cs and "helix/" not in desc:
                desc = desc.rstrip(".") + f". Values from {cs[0]}."
            col = {"name": attr, "description": desc,
                   "custom_metadata": {"helix.attribute": f"{name}.{attr}",
                                       "helix.required": str(attr in s.get("required", [])).lower(),
                                       "helix.definition_status": status}}
            if cs:
                col["custom_metadata"]["helix.code_set"] = cs[0]
            if attr in REF_TARGETS and REF_TARGETS[attr] in schemas:
                col["custom_metadata"]["helix.references"] = title_case(REF_TARGETS[attr])
            if de.get("classification") and de["classification"] != classification:
                col["custom_metadata"]["helix.classification"] = de["classification"]
            columns.append(col)
        for ce in col_rules.get(name, []):
            for c in ce.get("columns", []):
                base = c.split(" ")[0].split("[")[0].split(".")[0]
                for col in columns:
                    if col["name"] == base:
                        col["custom_metadata"]["helix.column_rule"] = ce.get("classification", "")
                        if ce.get("masking_policy"):
                            col["custom_metadata"]["helix.masking_policy"] = ce["masking_policy"]
        table_params = {
            "helix.resource": name,
            "helix.domain": domain_of.get(name, ""),
            "helix.classification": classification,
            "helix.ferpa_education_record": str(is_edu).lower(),
            "helix.glba_covered": str(glba).lower(),
            "helix.steward": steward.get("steward", ""),
            "helix.schema": f"core/resources/{key}.json",
            "helix.skill": f"templates/context/generated/skills/{key}.md",
        }
        glossary = sorted({name, domain_of.get(name, "")} | {terms[c]["title"].replace("HELIX Terminology: ", "") for c in bindings.values()})
        glue_tables.append({
            "database": args.database,
            "table": key,
            "description": clean(first_sentence(s.get("description", ""), 900)),
            "table_parameters": table_params,
            "glossary_terms": [g for g in glossary if g],
            "columns": columns,
        })

        # ---- skill file
        req = s.get("required", [])
        keys = ["helix_id"] + [a for a in req if a.endswith("_ref")]
        outbound = [(a, REF_TARGETS[a]) for a in props if a in REF_TARGETS and REF_TARGETS[a] in schemas]
        lines = [f"# {name}", "",
                 f"**Table:** `{args.database}.{key}` · **Classification:** {classification} · "
                 f"**FERPA education record:** {'yes' if is_edu else 'no'} · **GLBA:** {'yes' if glba else 'no'}",
                 "", clean(first_sentence(s.get("description", ""), 1200)), "",
                 "## Grain and keys", "",
                 f"One row per {name} record, keyed by `helix_id`. Required references: "
                 + (", ".join(f"`{a}`" for a in req if a.endswith('_ref')) or "none") + ".", ""]
        if outbound:
            lines += ["## Joins", "", "| Column | Joins to |", "|--------|----------|"]
            lines += [f"| `{a}` | `{args.database}.{t}.helix_id` ({title_case(t)}) |" for a, t in outbound]
            lines.append("")
        if referenced_by.get(key):
            lines += ["Referenced by: " + ", ".join(f"`{k}.{a}`" for k, a in referenced_by[key][:15]), ""]
        filt = REQUIRED_FILTERS.get(key, [])
        lines += ["## Required filters and usage rules", ""]
        lines += [f"- {f}" for f in filt] or []
        if is_edu:
            lines += ["- FERPA education record: access needs legitimate educational interest (99.31(a)(1)). "
                      "Exclude students with an active directory restriction from anything shared outside the "
                      "institution (ACM-SPECIAL-001)."]
        if glba:
            lines += ["- GLBA-covered: only the restricted financial aid role sees cleartext; never return individual "
                      "values in agent answers (govern/agent-guardrails.json)."]
        lines += ["- Publish counts only with small-cell suppression (N under 5) per govern/ferpa-suppression-policy.json."
                  if is_edu else "- Follow the classification above for any output.", ""]
        if bindings:
            lines += ["## Code sets", "", "| Column | Code set | Values |", "|--------|----------|--------|"]
            for a, c in bindings.items():
                vals = ", ".join(f"`{x['code']}`" for x in terms[c].get("codes", [])[:12])
                more = " ..." if len(terms[c].get("codes", [])) > 12 else ""
                lines.append(f"| `{a}` | `{c}` | {vals}{more} |")
            lines.append("")
        if col_rules.get(name):
            lines += ["## Column rules", ""]
            for ce in col_rules[name]:
                lines.append(f"- {', '.join('`'+c+'`' for c in ce.get('columns', []))}: {ce.get('classification','')}. "
                             f"{clean(first_sentence(ce.get('override',''), 300))}")
            lines.append("")
        lines += ["## Columns", "", "| Column | Definition |", "|--------|-----------|"]
        lines += [f"| `{c['name']}` | {c['description'].replace('|', '/')}"
                  + (" *(generated from the name; steward to confirm)*" if c["custom_metadata"]["helix.definition_status"] == "pattern" else "")
                  + " |" for c in columns]
        lines += ["", f"Steward: {steward.get('steward') or 'see govern/domain-taxonomy.json'}. "
                  f"Source schema: `core/resources/{key}.json`.", "",
                  "*Generated by tools/build_context_pack.py. Add institution-specific notes in a separate file.*", ""]
        with open(os.path.join(args.out, "skills", f"{key}.md"), "w") as fh:
            fh.write("\n".join(lines))

    with open(os.path.join(args.out, "glue-business-context.json"), "w") as fh:
        json.dump({"helix_version": args.helix_version, "database": args.database,
                   "how_to_apply": "tools/apply_glue_context.py writes description, column comments, and table "
                                   "parameters (generally available). glossary_terms and custom_metadata are for the "
                                   "Glue Data Catalog business context preview; map them to the preview API in your account.",
                   "tables": glue_tables}, fh, indent=2)

    # ---- ontology
    T = ["@prefix helix: <https://helixedu.org/ontology#> .",
         "@prefix owl: <http://www.w3.org/2002/07/owl#> .",
         "@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .",
         "@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .",
         "@prefix skos: <http://www.w3.org/2004/02/skos/core#> .",
         "@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .", "",
         "<https://helixedu.org/ontology> a owl:Ontology ;",
         f'  rdfs:label "HELIX Higher Education Ontology" ; owl:versionInfo {ttl_str(args.helix_version or "unversioned")} .', ""]
    xsd = {"string": "xsd:string", "integer": "xsd:integer", "number": "xsd:decimal", "boolean": "xsd:boolean"}
    for d in sorted(set(domain_of.values())):
        T.append(f"helix:{re.sub(r'[^A-Za-z]', '', d)}Domain a skos:Concept ; skos:prefLabel {ttl_str(d)} .")
    T.append("")
    for key, s in schemas.items():
        name = title_case(key)
        T.append(f"helix:{name} a owl:Class ; rdfs:label {ttl_str(name)} ;")
        T.append(f"  rdfs:comment {ttl_str(clean(first_sentence(s.get('description',''), 500)))} ;")
        T.append(f"  helix:classification {ttl_str(SCH_CLASS(s))} ;")
        T.append(f"  helix:inDomain helix:{re.sub(r'[^A-Za-z]', '', domain_of.get(name, 'Other'))}Domain .")
    T.append("")
    for key, s in schemas.items():
        name = title_case(key)
        for attr, spec in s.get("properties", {}).items():
            if attr in ("meta", "helix_id") or not isinstance(spec, dict):
                continue
            pid = f"helix:{name}_{attr}"
            if attr in REF_TARGETS and REF_TARGETS[attr] in schemas:
                T.append(f"{pid} a owl:ObjectProperty ; rdfs:domain helix:{name} ; "
                         f"rdfs:range helix:{title_case(REF_TARGETS[attr])} ; rdfs:label {ttl_str(attr)} .")
            else:
                rng = xsd.get(spec.get("type") if isinstance(spec.get("type"), str) else "string", "xsd:string")
                if spec.get("format") in ("date",):
                    rng = "xsd:date"
                elif spec.get("format") == "date-time":
                    rng = "xsd:dateTime"
                cs = [c for c in re.findall(r"helix/[a-z0-9\-]+", json.dumps(spec)) if c in terms]
                extra = f" ; helix:codeSet helix:cs_{cs[0].split('/')[1].replace('-', '_')}" if cs else ""
                T.append(f"{pid} a owl:DatatypeProperty ; rdfs:domain helix:{name} ; rdfs:range {rng} ; "
                         f"rdfs:label {ttl_str(attr)}{extra} .")
    T.append("")
    for cs, t in terms.items():
        sid = f"helix:cs_{cs.split('/')[1].replace('-', '_')}"
        T.append(f"{sid} a skos:ConceptScheme ; skos:prefLabel {ttl_str(t['title'].replace('HELIX Terminology: ', ''))} ; "
                 f"skos:notation {ttl_str(cs)} .")
        for c in t.get("codes", []):
            cid = f"{sid}__{re.sub(r'[^A-Za-z0-9_]', '_', c['code'])}"
            T.append(f"{cid} a skos:Concept ; skos:inScheme {sid} ; skos:notation {ttl_str(c['code'])} ; "
                     f"skos:prefLabel {ttl_str(clean(c.get('display', c['code'])))} ; skos:definition {ttl_str(clean(c.get('definition','')))} .")
    with open(os.path.join(args.out, "helix-ontology.ttl"), "w") as fh:
        fh.write("\n".join(T) + "\n")

    # ---- gold metrics
    gold = []
    gpath = os.path.join(ROOT, "templates", "context", "gold-metrics.yaml")
    try:
        import yaml  # noqa: F401
        with open(gpath) as fh:
            gold = yaml.safe_load(fh).get("metrics", [])
    except ImportError:
        print("PyYAML not installed: skipping gold metric skills", file=sys.stderr)
    for m in gold:
        L = [f"# Gold metric: {m['name']}", "",
             f"**Id:** `{m['id']}` · **Domain:** {m.get('domain','')} · **Owner:** {m.get('owner_role','')} · "
             f"**Output classification:** {m.get('output_classification','')}", "",
             f"**Approved:** {m.get('approved_by') or 'not yet approved'}" + (f" on {m['approved_date']}" if m.get('approved_date') else ""), "",
             "## Grain", "", m.get("grain", ""), "", "## Population", ""]
        L += [f"- {p}" for p in m.get("population", [])]
        L += ["", "## Formula", "", m.get("formula", ""), "", "## Source columns", ""]
        L += [f"- `{args.database}.{x}`" for x in m.get("sources", [])]
        L += ["", "## Standard", "", m.get("standard", ""), "", "## Suppression", "", m.get("suppression", ""), "",
              "## Notes", "", m.get("notes", ""), "",
              f"Defined in `templates/context/gold-metrics.yaml`. Don't answer this metric any other way.", ""]
        with open(os.path.join(args.out, "gold-skills", f"{m['id']}.md"), "w") as fh:
            fh.write("\n".join(L))

    total_cols = sum(len(t["columns"]) for t in glue_tables)
    manifest = {"helix_version": args.helix_version, "silver_tables": len(glue_tables),
                "columns": total_cols, "columns_with_written_definitions": total_cols - pattern_count[0],
                "columns_with_pattern_definitions": pattern_count[0],
                "skills": len(glue_tables), "gold_skills": len(gold), "code_sets": len(terms),
                "outputs": ["glue-business-context.json", "helix-ontology.ttl", "skills/", "gold-skills/"]}
    with open(os.path.join(args.out, "MANIFEST.json"), "w") as fh:
        json.dump(manifest, fh, indent=2)
    print(json.dumps(manifest, indent=2))


def SCH_CLASS(s):
    return s.get("properties", {}).get("meta", {}).get("properties", {}).get("classification", {}).get("default", "confidential")


if __name__ == "__main__":
    main()
