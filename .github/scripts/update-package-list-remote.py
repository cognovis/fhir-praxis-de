#!/usr/bin/env python3
import json
import os
import re
import shutil
import sys
from pathlib import Path
from urllib.parse import urlparse


SEARCH_ROOTS = (
    Path("/var/www"),
    Path("/srv"),
    Path("/usr/share/nginx"),
    Path("/usr/local/www"),
    Path("/opt"),
    Path("/home/fhir"),
    Path("/data"),
    Path("/mnt"),
    Path("/var/lib/docker/volumes"),
)
NGINX_CONFIG_ROOT = Path("/etc/nginx")
ROOT_OR_ALIAS_RE = re.compile(r"\b(root|alias)\s+([^;]+);")
SKIP_DIRS = {
    ".cache",
    ".git",
    "__pycache__",
    "cache",
    "log",
    "logs",
    "node_modules",
    "tmp",
    "vendor",
}


def warn_walk_error(error):
    print(f"WARNING: Could not scan {error.filename}: {error.strerror}", file=sys.stderr)


def iter_nginx_config_files():
    if not NGINX_CONFIG_ROOT.is_dir():
        return

    for root, dirs, files in os.walk(NGINX_CONFIG_ROOT, onerror=warn_walk_error):
        dirs[:] = [name for name in dirs if name not in SKIP_DIRS]
        for name in files:
            yield Path(root) / name


def clean_directive_path(raw_path):
    value = raw_path.strip().strip("\"'")
    parts = value.split()
    if not parts:
        return None

    value = parts[0].strip("\"'")
    if "$" in value:
        return None

    return Path(value)


def iter_nginx_package_lists(public_path):
    public_url_path = urlparse(public_path).path.strip("/")
    public_suffix = Path(public_url_path) if public_url_path else None

    for config_file in iter_nginx_config_files():
        try:
            config = config_file.read_text(encoding="utf-8", errors="ignore")
        except OSError as error:
            print(f"WARNING: Could not read {config_file}: {error}", file=sys.stderr)
            continue

        for directive, raw_path in ROOT_OR_ALIAS_RE.findall(config):
            base_path = clean_directive_path(raw_path)
            if base_path is None:
                continue

            if directive == "alias":
                yield base_path / "package-list.json"
                if public_suffix is not None:
                    yield base_path / public_suffix / "package-list.json"
            else:
                if public_suffix is not None:
                    yield base_path / public_suffix / "package-list.json"
                yield base_path / "package-list.json"


def iter_package_lists(default_path, public_path):
    seen = set()

    default_candidate = Path(default_path)
    if default_candidate not in seen:
        seen.add(default_candidate)
        yield default_candidate

    for candidate in iter_nginx_package_lists(public_path):
        if candidate in seen:
            continue
        seen.add(candidate)
        yield candidate

    for search_root in SEARCH_ROOTS:
        if not search_root.is_dir():
            continue

        for root, dirs, files in os.walk(search_root, onerror=warn_walk_error):
            dirs[:] = [name for name in dirs if name not in SKIP_DIRS]
            if "package-list.json" not in files:
                continue

            candidate = Path(root) / "package-list.json"
            if candidate in seen:
                continue

            seen.add(candidate)
            yield candidate


def read_json(path):
    with path.open(encoding="utf-8") as handle:
        return json.load(handle)


def write_json(path, data):
    with path.open("w", encoding="utf-8") as handle:
        json.dump(data, handle, indent=2)
        handle.write("\n")


def matches_package_list(data, package_id, public_path):
    if not isinstance(data, dict):
        return False

    canonical = str(data.get("canonical", "")).rstrip("/")
    if data.get("package-id") == package_id or canonical == public_path:
        return True

    entries = data.get("list", [])
    if not isinstance(entries, list):
        return False

    for entry in entries:
        if not isinstance(entry, dict):
            continue

        package = entry.get("package")
        if isinstance(package, str) and package.startswith(f"{package_id}#"):
            return True

        entry_path = entry.get("path")
        if isinstance(entry_path, str) and entry_path.rstrip("/") == public_path:
            return True

    return False


def update_package_list(path, data, version, today, package_id, public_path):
    entries = data.setdefault("list", [])
    if not isinstance(entries, list):
        raise ValueError(f"{path} has no list array")

    for entry in entries:
        if isinstance(entry, dict) and "current" in entry:
            entry["current"] = False

    entries[:] = [
        entry
        for entry in entries
        if not (isinstance(entry, dict) and entry.get("version") == version)
    ]

    new_entry = {
        "version": version,
        "date": today,
        "desc": f"Release {version}",
        "path": public_path,
        "status": "trial-use",
        "sequence": "STU1",
        "fhirversion": "4.0.1",
        "current": True,
        "package": f"{package_id}#{version}",
    }

    insert_at = 1 if entries and isinstance(entries[0], dict) and entries[0].get("version") == "current" else 0
    entries.insert(insert_at, new_entry)

    backup = path.with_name(f"{path.name}.bak")
    shutil.copy2(path, backup)
    write_json(path, data)


def main():
    if len(sys.argv) != 6:
        print(
            "usage: update-package-list-remote.py <version> <date> <package-id> <public-path> <default-package-list>",
            file=sys.stderr,
        )
        return 2

    version, today, package_id, public_path, default_path = sys.argv[1:6]
    public_path = public_path.rstrip("/")
    required_path = Path(default_path)

    updated = []
    failures = []
    scanned = 0

    for path in iter_package_lists(default_path, public_path):
        if not path.is_file():
            continue

        scanned += 1

        try:
            data = read_json(path)
        except (OSError, json.JSONDecodeError) as error:
            message = f"{path}: could not read JSON: {error}"
            if path == required_path:
                failures.append(message)
            else:
                print(f"WARNING: {message}", file=sys.stderr)
            continue

        if not matches_package_list(data, package_id, public_path):
            continue

        try:
            update_package_list(path, data, version, today, package_id, public_path)
        except (OSError, ValueError) as error:
            failures.append(f"{path}: could not update: {error}")
            continue

        updated.append(str(path))

    if not updated:
        print(f"ERROR: No matching package-list.json found for {package_id}", file=sys.stderr)
        return 1

    print("Updated package-list.json paths:")
    for path in updated:
        print(path)
    print(f"Scanned {scanned} package-list.json candidates")

    if failures:
        print("ERROR: Some package-list.json files could not be processed:", file=sys.stderr)
        for failure in failures:
            print(f"- {failure}", file=sys.stderr)
        return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
