#!/usr/bin/env python3
import json
import sys


def main():
    if len(sys.argv) != 4:
        print(
            "usage: verify-public-package-list.py <version> <package-id> <public-path>",
            file=sys.stderr,
        )
        return 2

    version, package_id, public_path = sys.argv[1:4]
    public_path = public_path.rstrip("/")

    data = json.load(sys.stdin)
    entries = data.get("list", [])
    if not isinstance(entries, list):
        print("ERROR: Public package-list.json has no list array", file=sys.stderr)
        return 1

    current_entries = [
        entry
        for entry in entries
        if isinstance(entry, dict) and entry.get("current") is True
    ]
    expected_package = f"{package_id}#{version}"

    for entry in current_entries:
        entry_path = str(entry.get("path", "")).rstrip("/")
        if (
            entry.get("version") == version
            and entry.get("package") == expected_package
            and entry_path == public_path
        ):
            print(f"Public package-list.json current version verified: {expected_package}")
            return 0

    seen = ", ".join(
        f"{entry.get('version')} ({entry.get('package')})"
        for entry in current_entries
        if isinstance(entry, dict)
    )
    print(
        f"ERROR: Public package-list.json does not mark {expected_package} as current. Current entries: {seen}",
        file=sys.stderr,
    )
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
