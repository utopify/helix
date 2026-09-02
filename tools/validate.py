#!/usr/bin/env python3
"""
HELIX Schema Validator
Validates data files (JSON, NDJSON, CSV) against HELIX Core resource schemas.

Usage:
    python validate.py --resource student --file silver_student.json
    python validate.py --resource enrollment --file enrollments.ndjson
    python validate.py --resource student --file students.csv
    python validate.py --list  (shows all available resources)

Requirements:
    pip install jsonschema pandas  (pandas only needed for CSV validation)
"""

import argparse
import json
import sys
import os
from pathlib import Path

try:
    from jsonschema import validate, ValidationError, Draft202012Validator
except ImportError:
    print("ERROR: jsonschema not installed. Run: pip install jsonschema")
    sys.exit(1)


RESOURCE_DIR = os.path.join(os.path.dirname(os.path.dirname(__file__)), "core", "resources")


def list_resources():
    """List all available HELIX resource schemas."""
    resources = []
    for f in sorted(os.listdir(RESOURCE_DIR)):
        if f.endswith(".json"):
            name = f.replace(".json", "")
            with open(os.path.join(RESOURCE_DIR, f)) as fh:
                schema = json.load(fh)
            title = schema.get("title", name)
            resources.append((name, title))
    return resources


def load_schema(resource_name):
    """Load a HELIX Core resource JSON Schema."""
    schema_path = os.path.join(RESOURCE_DIR, f"{resource_name}.json")
    if not os.path.exists(schema_path):
        print(f"ERROR: No schema found for resource '{resource_name}'")
        print(f"Available resources: {', '.join(r[0] for r in list_resources())}")
        sys.exit(1)
    with open(schema_path) as f:
        return json.load(f)


def load_records(file_path):
    """Load records from JSON, NDJSON, or CSV file."""
    ext = Path(file_path).suffix.lower()

    if ext == ".json":
        with open(file_path) as f:
            data = json.load(f)
        if isinstance(data, list):
            return data
        else:
            return [data]

    elif ext in (".ndjson", ".jsonl"):
        records = []
        with open(file_path) as f:
            for line_num, line in enumerate(f, 1):
                line = line.strip()
                if line:
                    try:
                        records.append(json.loads(line))
                    except json.JSONDecodeError as e:
                        print(f"WARNING: Line {line_num} is not valid JSON: {e}")
        return records

    elif ext == ".csv":
        try:
            import pandas as pd
        except ImportError:
            print("ERROR: pandas required for CSV validation. Run: pip install pandas")
            sys.exit(1)
        df = pd.read_csv(file_path)
        return df.to_dict(orient="records")

    else:
        print(f"ERROR: Unsupported file format '{ext}'. Use .json, .ndjson, .jsonl, or .csv")
        sys.exit(1)


def validate_records(records, schema, resource_name):
    """Validate a list of records against a HELIX schema."""
    total = len(records)
    valid = 0
    errors = []

    # Remove $schema and $id for validation compatibility
    schema_clean = {k: v for k, v in schema.items() if k not in ("$schema", "$id")}

    for i, record in enumerate(records):
        try:
            validate(instance=record, schema=schema_clean)
            valid += 1
        except ValidationError as e:
            errors.append({
                "record": i + 1,
                "path": ".".join(str(p) for p in e.absolute_path) or "(root)",
                "message": e.message,
                "helix_id": record.get("helix_id", "N/A")
            })

    return total, valid, errors


def main():
    parser = argparse.ArgumentParser(description="HELIX Schema Validator")
    parser.add_argument("--resource", "-r", help="HELIX resource name (e.g., student, enrollment)")
    parser.add_argument("--file", "-f", help="Path to data file (JSON, NDJSON, CSV)")
    parser.add_argument("--list", "-l", action="store_true", help="List available resources")
    parser.add_argument("--verbose", "-v", action="store_true", help="Show all error details")
    parser.add_argument("--max-errors", type=int, default=20, help="Max errors to display (default: 20)")

    args = parser.parse_args()

    if args.list:
        print("\nAvailable HELIX Core Resources:\n")
        for name, title in list_resources():
            print(f"  {name:<30} {title}")
        print(f"\nUsage: python validate.py --resource <name> --file <path>")
        return

    if not args.resource or not args.file:
        parser.print_help()
        return

    # Load schema
    print(f"\nHELIX Schema Validator")
    print(f"=" * 50)
    schema = load_schema(args.resource)
    print(f"Schema:   {schema.get('title', args.resource)}")
    print(f"File:     {args.file}")

    # Load records
    records = load_records(args.file)
    print(f"Records:  {len(records)}")
    print(f"-" * 50)

    # Validate
    total, valid, errors = validate_records(records, schema, args.resource)

    # Report
    invalid = total - valid
    pass_rate = (valid / total * 100) if total > 0 else 0

    print(f"\nResults:")
    print(f"  Total records:  {total}")
    print(f"  Valid:          {valid} ({pass_rate:.1f}%)")
    print(f"  Invalid:        {invalid}")

    if errors:
        print(f"\nErrors (showing first {min(len(errors), args.max_errors)}):")
        for err in errors[:args.max_errors]:
            print(f"  Record {err['record']} (helix_id: {err['helix_id']})")
            print(f"    Path:    {err['path']}")
            print(f"    Message: {err['message']}")
            print()

        if len(errors) > args.max_errors:
            print(f"  ... and {len(errors) - args.max_errors} more errors. Use --max-errors to see more.")

    print(f"\n{'PASS' if invalid == 0 else 'FAIL'}: {valid}/{total} records conform to HELIX {args.resource} schema")

    sys.exit(0 if invalid == 0 else 1)


if __name__ == "__main__":
    main()
