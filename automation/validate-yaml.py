#!/usr/bin/env python3
"""Validate every tracked YAML file, including .yml.template files."""

import glob
import sys

import yaml

PATTERNS = ("**/*.yml", "**/*.yaml", "**/*.yml.template")
SKIP = (".git/", "node_modules/", ".venv/")


def main() -> int:
    files = set()
    for pattern in PATTERNS:
        files.update(glob.glob(pattern, recursive=True))
    paths = sorted(path for path in files if not path.startswith(SKIP))
    bad = []
    for path in paths:
        try:
            with open(path, encoding="utf-8") as stream:
                yaml.safe_load(stream)
        except yaml.YAMLError as exc:
            bad.append((path, exc))
    for path, exc in bad:
        print(f"::error file={path}::invalid YAML: {exc}")
    print(f"validated {len(paths)} YAML files")
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
