#!/usr/bin/env python3
"""
HELIX Governance Coverage Check

Makes sure governance keeps up with the data model. Run it after adding,
renaming, or removing any resource in core/resources/.

It fails (exit code 1) if:
  - a Core resource is missing from govern/access-control-matrix.json, or listed twice
  - a resource in the matrix is missing grants for any role
  - a column exception names a column that isn't in the resource schema
  - a masking policy in govern/lakehouse-rbac-model.json names a column that isn't in the schema
  - a restricted resource gives helix_analyst_standard or helix_research row-level read in gold
  - a Core resource is missing from govern/domain-taxonomy.json
  - a bridge mapping's target_resource isn't a Core resource (for example a stale "(planned)" label)
  - a schema binds an attribute to a code set that doesn't exist

It also lists, without failing, any Core resource that no bridge maps yet.

Usage:
    python tools/check_governance_coverage.py

No dependencies beyond the Python standard library.
"""

import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RESOURCES = os.path.join(ROOT, "core", "resources")
GOVERN = os.path.join(ROOT, "govern")

# Acronym spellings used in docs and the taxonomy
ALIASES = {
    "FERPARestriction": "ferpa_restriction", "GLTransaction": "gl_transaction",
    "APVoucher": "ap_voucher", "ARTransaction": "ar_transaction",
    "SAPEvaluation": "sap_evaluation", "ReturnOfTitleIV": "return_of_title_iv",
}


def title_case(key):
    return "".join(w.capitalize() for w in key.split("_"))


def base_column(ref):
    """'contact.emails[].address (where ...)' -> 'contact'"""
    return ref.split(" ")[0].split("[")[0].split(".")[0]


def main():
    schemas = {}
    for f in sorted(os.listdir(RESOURCES)):
        if f.endswith(".json"):
            with open(os.path.join(RESOURCES, f)) as fh:
                schemas[f[:-5]] = json.load(fh)

    name_to_key = {title_case(k): k for k in schemas}
    name_to_key.update(ALIASES)

    def props(key):
        return schemas[key].get("properties", {})

    def classification(key):
        return props(key).get("meta", {}).get("properties", {}).get("classification", {}).get("default")

    problems = []

    # 1. Access control matrix
    with open(os.path.join(GOVERN, "access-control-matrix.json")) as fh:
        acm = json.load(fh)
    roles = acm["matrix_dimensions"]["roles"]
    seen = []
    for domain in acm["matrix"]:
        for res in domain["resources"]:
            key = name_to_key.get(res)
            if key is None:
                problems.append(f"matrix: '{res}' is not a Core resource")
                continue
            seen.append(key)
            grants = domain.get("access_by_resource", {}).get(res)
            if grants is None:
                problems.append(f"matrix: '{res}' has no grants")
                continue
            for role in roles:
                if role not in grants:
                    problems.append(f"matrix: '{res}' is missing grants for {role}")
            if classification(key) == "restricted":
                for role in ("helix_analyst_standard", "helix_research"):
                    if grants.get(role, {}).get("gold") == "read":
                        problems.append(f"matrix: restricted '{res}' gives {role} row-level read in gold")
        for exc in domain.get("column_exceptions", []):
            key = name_to_key.get(exc["resource"])
            if key is None:
                problems.append(f"matrix exception: unknown resource '{exc['resource']}'")
                continue
            for col in exc["columns"]:
                if base_column(col) not in props(key):
                    problems.append(f"matrix exception: {exc['resource']}.{col} is not in the schema")

    missing = sorted(set(schemas) - set(seen))
    duplicates = sorted({k for k in seen if seen.count(k) > 1})
    for k in missing:
        problems.append(f"matrix: Core resource '{k}' has no access rules")
    for k in duplicates:
        problems.append(f"matrix: '{k}' is listed more than once")

    # 2. Masking policies
    with open(os.path.join(GOVERN, "lakehouse-rbac-model.json")) as fh:
        rbac = json.load(fh)
    for policy in rbac.get("column_level_security", {}).get("masking_policies", []):
        for ref in policy.get("applies_to_columns", []):
            if "." not in ref.split(" ")[0]:
                continue
            res, col = ref.split(".", 1)
            if res not in schemas:
                problems.append(f"masking {policy['policy_name']}: unknown resource '{res}'")
            elif base_column(col) not in props(res):
                problems.append(f"masking {policy['policy_name']}: {res}.{col} is not in the schema")

    # 3. Domain taxonomy
    with open(os.path.join(GOVERN, "domain-taxonomy.json")) as fh:
        taxonomy = json.load(fh)
    listed = set()
    for d in taxonomy["domains"]:
        for res in d.get("helix_resources", d.get("resources", [])):
            key = name_to_key.get(res)
            if key:
                listed.add(key)
    for k in sorted(set(schemas) - listed):
        problems.append(f"taxonomy: Core resource '{k}' is not assigned to a domain")


    # 4. Bridge targets and terminology bindings
    import re
    code_systems = set()
    tdir = os.path.join(ROOT, "core", "terminologies")
    for f in os.listdir(tdir):
        if f.endswith(".json"):
            with open(os.path.join(tdir, f)) as fh:
                code_systems.add(json.load(fh).get("code_system"))
    for key in schemas:
        for attr, spec in props(key).items():
            for cs in re.findall(r"helix/[a-z0-9\-]+", json.dumps(spec)):
                if cs not in code_systems:
                    problems.append(f"binding: {key}.{attr} points at unknown code set {cs}")
    mapped = set()
    for system in ("peoplesoft", "banner", "workday", "colleague", "banner-saas", "outcomes"):
        for dp, dirs, fs in os.walk(os.path.join(ROOT, "bridge", system)):
            dirs[:] = [d for d in dirs if not d.startswith(".")]
            for f in fs:
                if not f.endswith(".json"):
                    continue
                with open(os.path.join(dp, f)) as fh:
                    target = str(json.load(fh).get("target_resource", ""))
                parts = [t.strip() for t in re.split(r"[/,]", target.replace("HELIX ", "")) if t.strip()]
                keys = [name_to_key.get(t) for t in parts]
                if not parts or None in keys:
                    problems.append(f"bridge: {system}/{f} targets '{target}', which isn't a Core resource")
                else:
                    mapped.update(keys)
    unmapped = sorted(set(schemas) - mapped)
    print(f"Core resources:            {len(schemas)}")
    print(f"In access control matrix:  {len(set(seen))}")
    print(f"In domain taxonomy:        {len(listed)}")
    print(f"Mapped by a bridge:        {len(mapped)}")
    if unmapped:
        print(f"\nNot mapped by any bridge yet ({len(unmapped)}): " + ", ".join(unmapped))
    if problems:
        print(f"\nFAIL: {len(problems)} problem(s)")
        for p in problems:
            print(f"  - {p}")
        sys.exit(1)
    print("\nPASS: governance covers every Core resource")


if __name__ == "__main__":
    main()
