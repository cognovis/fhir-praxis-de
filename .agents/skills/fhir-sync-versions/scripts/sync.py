#!/usr/bin/env python3
"""Synchronize FHIR version pins against fhir-versions.lock.yaml."""

from __future__ import annotations

import argparse
import json
import os
import re
import shutil
import subprocess
import sys
import tarfile
import tempfile
import time
from collections import defaultdict, deque
from dataclasses import dataclass, replace
from pathlib import Path
from typing import Any, Callable, Literal
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen

import yaml


DEFAULT_REGISTRY = "https://npm.cognovis.de"
NPM_TIMEOUT_SECONDS = 5
REGISTRY_BUDGET_SECONDS = 20
REGISTRY_METADATA_BUDGET_SECONDS = 60
REPO_ROOT_MARKER = "fhir-versions.lock.yaml"
SUSHI_CONSUMERS = (
    Path("~/code/fhir-praxis-de/sushi-config.yaml").expanduser(),
    Path("~/code/fhir-dental-de/sushi-config.yaml").expanduser(),
    Path("~/code/fhir-deidentification-de/sushi-config.yaml").expanduser(),
)
PACKAGE_JSON_CONSUMER_ROOTS = (
    Path("~/code/polaris").expanduser(),
    Path("~/code/mira").expanduser(),
)
PACKAGE_JSON_DEPENDENCY_FIELDS = (
    "dependencies",
    "devDependencies",
    "peerDependencies",
    "optionalDependencies",
    "overrides",
    "resolutions",
)
PACKAGE_JSON_EXCLUDED_DIRS = frozenset(
    {
        ".cache",
        ".claude",
        ".codegen-cache",
        ".git",
        ".next",
        ".turbo",
        "build",
        "coverage",
        "dist",
        "node_modules",
    }
)
PACKAGE_JSON_NON_VERSION_PREFIXES = (
    "file:",
    "git+",
    "github:",
    "http://",
    "https://",
    "link:",
    "portal:",
    "workspace:",
)
GENERATED_PROVENANCE_ROOTS = (
    Path("~/code/polaris/packages/fhir-de/generated").expanduser(),
    Path("~/code/polaris/packages/fhir-de/src/client/generated").expanduser(),
)
GENERATED_PROVENANCE_PATTERNS = (
    re.compile(r"\bpkg:\s+(?P<package>[A-Za-z0-9_.@/-]+)#(?P<version>[^\s)]+)"),
    re.compile(r"\bSource:\s+(?P<package>[A-Za-z0-9_.@/-]+)@(?P<version>[^\s]+)"),
)
LOCAL_IG_REPOS = {
    "de.cognovis.fhir.praxis": Path("~/code/fhir-praxis-de").expanduser(),
    "de.cognovis.fhir.dental": Path("~/code/fhir-dental-de").expanduser(),
    "io.cognovis.de-identification.de": Path(
        "~/code/fhir-deidentification-de"
    ).expanduser(),
}
REGISTRY_AUDIT_PACKAGE_PREFIXES = (
    "de.cognovis.",
    "io.cognovis.",
)
AUX_PIN_GLOBS = (
    ".github/workflows/*.yml",
    ".github/workflows/*.yaml",
    ".github/actions/**/*.yml",
    ".github/actions/**/*.yaml",
    "scripts/*.sh",
)
PACKAGE_ALIASES = {
    "de.cognovis.fhir.praxis": ("de.cognovis.fhir.praxis", "fhir-praxis-de", "praxis"),
    "de.cognovis.fhir.dental": ("de.cognovis.fhir.dental", "fhir-dental-de", "dental"),
    "io.cognovis.de-identification.de": (
        "io.cognovis.de-identification.de",
        "fhir-deidentification-de",
        "de-identification",
    ),
}
PUBLIC_PACKAGE_LISTS = {
    "de.cognovis.fhir.praxis": {
        "url": "https://fhir.cognovis.de/praxis/package-list.json",
        "path": "https://fhir.cognovis.de/praxis",
    },
    "de.cognovis.fhir.dental": {
        "url": "https://fhir.cognovis.de/dental/package-list.json",
        "path": "https://fhir.cognovis.de/dental",
    },
}
LEGACY_PACKAGE_LIST_DEPLOY_TARGETS = (
    "116.202.111.75",
    "/var/www/fhir/",
)
VERSION_TOKEN_RE = re.compile(
    r"\bv?(?P<version>\d+\.\d+\.\d+(?:[-+][0-9A-Za-z.-]+)?)\b"
)

DriftAction = Literal[
    "UPDATE",
    "RELEASE_LOCAL_OR_UPDATE_MANIFEST",
    "REGENERATE",
    "REGISTRY_METADATA_STALE",
    "AUX_PIN_DRIFT",
    "TAG_VERSION_MISMATCH",
    "TAG_WITHOUT_RELEASE",
    "TAG_WITHOUT_REGISTRY_PACKAGE",
    "PUBLIC_PACKAGE_LIST_STALE",
    "LEGACY_PACKAGE_LIST_DEPLOY_TARGET",
]
RELEASE_AUDIT_ACTIONS = frozenset(
    {
        "REGISTRY_METADATA_STALE",
        "AUX_PIN_DRIFT",
        "TAG_VERSION_MISMATCH",
        "TAG_WITHOUT_RELEASE",
        "TAG_WITHOUT_REGISTRY_PACKAGE",
        "PUBLIC_PACKAGE_LIST_STALE",
        "LEGACY_PACKAGE_LIST_DEPLOY_TARGET",
    }
)
NON_APPLYABLE_ACTIONS = RELEASE_AUDIT_ACTIONS | frozenset(
    {"RELEASE_LOCAL_OR_UPDATE_MANIFEST", "REGENERATE"}
)


@dataclass(frozen=True)
class Drift:
    file: Path
    package: str
    current: str
    expected: str
    action: DriftAction
    registry: str = ""


@dataclass(frozen=True)
class ConsumerFile:
    path: Path
    kind: str
    dependencies: dict[str, str]
    package_name: str | None = None


@dataclass(frozen=True)
class GeneratedProvenance:
    path: Path
    package: str
    versions: tuple[str, ...]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Reconcile FHIR package version pins against fhir-versions.lock.yaml."
    )
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--dry-run", action="store_true", help="show drift without editing files")
    mode.add_argument("--apply", action="store_true", help="apply edits and run the drift guard")
    parser.add_argument("--manifest", type=Path, help="path to fhir-versions.lock.yaml")
    parser.add_argument("--registry", default=DEFAULT_REGISTRY, help="npm registry URL")
    parser.add_argument(
        "--release-audit",
        action="store_true",
        help="also check registry package metadata, auxiliary pins, tags, releases, and release order",
    )
    return parser.parse_args()


def find_manifest(explicit_path: Path | None) -> Path:
    if explicit_path:
        path = explicit_path.expanduser().resolve()
        if not path.is_file():
            raise FileNotFoundError(f"Manifest not found: {path}")
        return path

    current = Path.cwd().resolve()
    for directory in (current, *current.parents):
        candidate = directory / REPO_ROOT_MARKER
        if candidate.is_file():
            return candidate
    raise FileNotFoundError(
        f"Could not find {REPO_ROOT_MARKER} in current directory or parents"
    )


def load_yaml(path: Path) -> dict[str, Any]:
    with path.open(encoding="utf-8") as handle:
        data = yaml.safe_load(handle) or {}
    if not isinstance(data, dict):
        raise ValueError(f"Expected YAML mapping in {path}")
    return data


def build_expected_versions(manifest: dict[str, Any]) -> dict[str, str]:
    expected: dict[str, str] = {}
    for section in ("igs", "packages", "bundles"):
        entries = manifest.get(section, {}) or {}
        if not isinstance(entries, dict):
            raise ValueError(f"Manifest section {section!r} must be a mapping")
        for package_name, package_data in entries.items():
            if isinstance(package_data, dict) and "version" in package_data:
                expected[package_name] = str(package_data["version"])
    return expected


def build_transitive_expected_versions(manifest: dict[str, Any]) -> dict[str, str]:
    expected = build_expected_versions(manifest)
    for bundle_name, bundle_data in (manifest.get("bundles", {}) or {}).items():
        if isinstance(bundle_data, dict) and isinstance(bundle_data.get("dependencies"), dict):
            for package_name, version in bundle_data["dependencies"].items():
                expected.setdefault(package_name, str(version))
            if "version" in bundle_data:
                expected[bundle_name] = str(bundle_data["version"])
    for package_name, package_data in (manifest.get("packages", {}) or {}).items():
        if isinstance(package_data, dict) and isinstance(package_data.get("cross_pins"), dict):
            for dep_name, version in package_data["cross_pins"].items():
                anchor = expected.get(dep_name)
                expected.setdefault(dep_name, anchor or str(version))
    return expected


def repo_root_from_manifest(manifest_path: Path) -> Path:
    return manifest_path.resolve().parent


def package_json_files(repo_root: Path) -> list[Path]:
    packages_dir = repo_root / "packages"
    if not packages_dir.is_dir():
        return []
    return sorted(packages_dir.glob("*/package.json"))


def package_json_files_under(root: Path) -> list[Path]:
    if not root.is_dir():
        return []
    package_files: list[Path] = []
    for directory, dirnames, filenames in os.walk(root):
        dirnames[:] = [
            dirname for dirname in dirnames if dirname not in PACKAGE_JSON_EXCLUDED_DIRS
        ]
        if "package.json" in filenames:
            package_files.append(Path(directory) / "package.json")
    return sorted(package_files)


def external_package_json_files() -> list[Path]:
    files: list[Path] = []
    for root in PACKAGE_JSON_CONSUMER_ROOTS:
        files.extend(package_json_files_under(root))
    return files


def read_sushi_dependencies(path: Path) -> dict[str, str]:
    data = load_yaml(path)
    result: dict[str, str] = {}
    package_id = data.get("id")
    package_version = data.get("version")
    if package_id and package_version is not None:
        result[str(package_id)] = str(package_version)

    dependencies = data.get("dependencies", {}) or {}
    if isinstance(dependencies, dict):
        for package_name, value in dependencies.items():
            if isinstance(value, dict):
                version = value.get("version")
            else:
                version = value
            if version is not None:
                result[str(package_name)] = str(version)
        return result
    if isinstance(dependencies, list):
        for item in dependencies:
            if not isinstance(item, dict):
                continue
            package_name = item.get("package") or item.get("id") or item.get("name")
            version = item.get("version")
            if package_name and version is not None:
                result[str(package_name)] = str(version)
        return result
    raise ValueError(f"Unsupported dependencies format in {path}")


def is_package_json_version_pin(value: Any) -> bool:
    if not isinstance(value, str):
        return value is not None and not isinstance(value, (dict, list))
    stripped = value.strip()
    return not stripped.startswith(PACKAGE_JSON_NON_VERSION_PREFIXES)


def read_package_json_dependencies(path: Path) -> dict[str, str]:
    with path.open(encoding="utf-8") as handle:
        data = json.load(handle)
    result: dict[str, str] = {}
    package_name = data.get("name")
    package_version = data.get("version")
    if package_name and package_version is not None:
        result[str(package_name)] = str(package_version)
    for field in PACKAGE_JSON_DEPENDENCY_FIELDS:
        dependencies = data.get(field, {}) or {}
        if not isinstance(dependencies, dict):
            raise ValueError(f"Expected {field} object in {path}")
        for dependency_name, version in dependencies.items():
            if is_package_json_version_pin(version):
                result[str(dependency_name)] = str(version)
    return result


def read_consumer_file(path: Path) -> ConsumerFile | None:
    if not path.is_file():
        return None
    if path.name == "sushi-config.yaml":
        data = load_yaml(path)
        package_name = data.get("id")
        return ConsumerFile(
            path=path,
            kind="sushi",
            dependencies=read_sushi_dependencies(path),
            package_name=str(package_name) if package_name else None,
        )
    if path.name == "package.json":
        with path.open(encoding="utf-8") as handle:
            data = json.load(handle)
        package_name = data.get("name")
        return ConsumerFile(
            path=path,
            kind="package-json",
            dependencies=read_package_json_dependencies(path),
            package_name=str(package_name) if package_name else None,
        )
    return None


def discover_consumers(repo_root: Path) -> list[ConsumerFile]:
    paths = [
        *SUSHI_CONSUMERS,
        *package_json_files(repo_root),
        *external_package_json_files(),
    ]
    consumers: list[ConsumerFile] = []
    seen: set[Path] = set()
    for path in paths:
        resolved = path.resolve()
        if resolved in seen:
            continue
        seen.add(resolved)
        consumer = read_consumer_file(path)
        if consumer:
            consumers.append(consumer)
    return consumers


def build_effective_expected_versions(
    manifest: dict[str, Any], consumers: list[ConsumerFile]
) -> dict[str, str]:
    expected = build_transitive_expected_versions(manifest)
    for consumer in consumers:
        if consumer.kind != "sushi" or consumer.package_name is None:
            continue
        if consumer.package_name in expected:
            continue
        version = consumer.dependencies.get(consumer.package_name)
        if version is not None:
            expected[consumer.package_name] = version
    return expected


def read_generated_provenance(root: Path) -> list[GeneratedProvenance]:
    if not root.is_dir():
        return []

    versions_by_package: dict[str, set[str]] = {}
    for path in sorted(root.rglob("*.ts")):
        text = path.read_text(encoding="utf-8", errors="ignore")
        for pattern in GENERATED_PROVENANCE_PATTERNS:
            for match in pattern.finditer(text):
                package_name = match.group("package")
                version = match.group("version")
                versions_by_package.setdefault(package_name, set()).add(version)

    return [
        GeneratedProvenance(
            path=root,
            package=package_name,
            versions=tuple(sorted(versions)),
        )
        for package_name, versions in sorted(versions_by_package.items())
    ]


def discover_generated_provenance(
    roots: tuple[Path, ...] = GENERATED_PROVENANCE_ROOTS,
) -> list[GeneratedProvenance]:
    records: list[GeneratedProvenance] = []
    for root in roots:
        records.extend(read_generated_provenance(root))
    return records


def compute_generated_provenance_drifts(
    expected_versions: dict[str, str],
    roots: tuple[Path, ...],
) -> list[Drift]:
    drifts: list[Drift] = []
    for record in discover_generated_provenance(roots):
        expected = expected_versions.get(record.package)
        if expected is None:
            continue
        if record.versions == (expected,):
            continue
        drifts.append(
            Drift(
                file=record.path,
                package=record.package,
                current=", ".join(record.versions),
                expected=expected,
                action="REGENERATE",
            )
        )
    return drifts


def expected_versions_for_consumer(
    manifest: dict[str, Any], consumer: ConsumerFile, global_expected: dict[str, str]
) -> dict[str, str]:
    if consumer.kind != "package-json" or consumer.package_name is None:
        return global_expected

    expected: dict[str, str] = {}
    bundles = manifest.get("bundles", {}) or {}
    packages = manifest.get("packages", {}) or {}
    if consumer.package_name in bundles:
        bundle_data = bundles[consumer.package_name]
        if isinstance(bundle_data, dict):
            if "version" in bundle_data:
                expected[consumer.package_name] = str(bundle_data["version"])
            for package_name, version in (bundle_data.get("dependencies", {}) or {}).items():
                expected[str(package_name)] = str(version)
    elif consumer.package_name in packages:
        package_data = packages[consumer.package_name]
        if isinstance(package_data, dict):
            if "version" in package_data:
                expected[consumer.package_name] = str(package_data["version"])
            for package_name, version in (package_data.get("cross_pins", {}) or {}).items():
                expected[str(package_name)] = str(version)

    for package_name in consumer.dependencies:
        if package_name not in expected and package_name in global_expected:
            expected[package_name] = global_expected[package_name]
    return expected


def compute_drifts(
    consumers: list[ConsumerFile],
    manifest: dict[str, Any],
    generated_roots: tuple[Path, ...] = (),
) -> list[Drift]:
    global_expected = build_effective_expected_versions(manifest, consumers)
    drifts: list[Drift] = []
    for consumer in consumers:
        expected_versions = expected_versions_for_consumer(
            manifest, consumer, global_expected
        )
        for package_name, current in consumer.dependencies.items():
            expected = expected_versions.get(package_name)
            if expected is None:
                continue
            if current != expected:
                action: DriftAction = "UPDATE"
                is_ahead = (
                    consumer.kind == "sushi"
                    and consumer.package_name == package_name
                    and version_lt(expected, current)
                )
                if is_ahead:
                    action = "RELEASE_LOCAL_OR_UPDATE_MANIFEST"
                drifts.append(
                    Drift(
                        file=consumer.path,
                        package=package_name,
                        current=current,
                        expected=expected,
                        action=action,
                    )
                )
    drifts.extend(compute_generated_provenance_drifts(global_expected, generated_roots))
    return sorted(drifts, key=lambda drift: (display_path(drift.file), drift.package))


def package_names_for_registry_audit(expected_versions: dict[str, str]) -> list[str]:
    return sorted(
        package_name
        for package_name in expected_versions
        if package_name.startswith(REGISTRY_AUDIT_PACKAGE_PREFIXES)
    )


def load_registry_package_json(
    package_name: str, version: str, registry: str
) -> dict[str, Any] | None:
    if shutil.which("npm") is None:
        return None

    with tempfile.TemporaryDirectory() as tempdir:
        result = subprocess.run(
            [
                "npm",
                "pack",
                f"{package_name}@{version}",
                "--registry",
                registry,
                "--json",
                "--silent",
            ],
            cwd=tempdir,
            capture_output=True,
            text=True,
            check=False,
            timeout=NPM_TIMEOUT_SECONDS,
        )
        if result.returncode != 0:
            return None

        tarball_path: Path | None = None
        try:
            packed = json.loads(result.stdout)
        except json.JSONDecodeError:
            packed = []
        if isinstance(packed, list) and packed:
            filename = packed[0].get("filename")
            if isinstance(filename, str):
                tarball_path = Path(tempdir) / filename
        if tarball_path is None or not tarball_path.is_file():
            tarballs = sorted(Path(tempdir).glob("*.tgz"))
            tarball_path = tarballs[0] if tarballs else None
        if tarball_path is None or not tarball_path.is_file():
            return None

        with tarfile.open(tarball_path, "r:gz") as archive:
            try:
                member = archive.getmember("package/package.json")
            except KeyError:
                return None
            extracted = archive.extractfile(member)
            if extracted is None:
                return None
            data = json.load(extracted)

    return data if isinstance(data, dict) else None


RegistryPackageLoader = Callable[[str, str, str], dict[str, Any] | None]


def compute_registry_metadata_drifts(
    expected_versions: dict[str, str],
    registry: str,
    loader: RegistryPackageLoader = load_registry_package_json,
) -> list[Drift]:
    drifts: list[Drift] = []
    started_at = time.monotonic()
    for package_name in package_names_for_registry_audit(expected_versions):
        if time.monotonic() - started_at > REGISTRY_METADATA_BUDGET_SECONDS:
            break
        version = expected_versions[package_name]
        try:
            package_json = loader(package_name, version, registry)
        except (subprocess.TimeoutExpired, json.JSONDecodeError, tarfile.TarError):
            continue
        if not package_json:
            continue

        dependencies = package_json.get("dependencies", {}) or {}
        if not isinstance(dependencies, dict):
            continue
        for dependency_name, current in sorted(dependencies.items()):
            expected = expected_versions.get(str(dependency_name))
            if expected is None:
                continue
            current_value = str(current)
            if current_value == expected:
                continue
            drifts.append(
                Drift(
                    file=Path(f"npm:{package_name}@{version}/package.json"),
                    package=str(dependency_name),
                    current=current_value,
                    expected=expected,
                    action="REGISTRY_METADATA_STALE",
                    registry=f"{package_name}@{version}",
                )
            )
    return drifts


def normalize_version_token(version: str) -> str:
    return version.lstrip("v")


def line_mentions_package(line: str, package_name: str) -> bool:
    lowered = line.lower()
    for marker in ("transitive dep from", "transitive dependency from"):
        if marker in lowered:
            lowered = lowered.split(marker, 1)[0]
            break
    aliases = PACKAGE_ALIASES.get(package_name, (package_name,))
    return any(alias.lower() in lowered for alias in aliases)


def aux_pin_files(
    repo_roots: dict[str, Path] = LOCAL_IG_REPOS,
) -> list[Path]:
    paths: list[Path] = []
    seen: set[Path] = set()
    for root in repo_roots.values():
        if not root.is_dir():
            continue
        for pattern in AUX_PIN_GLOBS:
            for path in sorted(root.glob(pattern)):
                resolved = path.resolve()
                if resolved in seen or not path.is_file():
                    continue
                seen.add(resolved)
                paths.append(path)
    return sorted(paths)


def compute_aux_pin_drifts(
    expected_versions: dict[str, str],
    repo_roots: dict[str, Path] = LOCAL_IG_REPOS,
) -> list[Drift]:
    drifts: list[Drift] = []
    packages = sorted(expected_versions)
    for path in aux_pin_files(repo_roots):
        mismatches: dict[str, list[str]] = defaultdict(list)
        for line_number, line in enumerate(
            path.read_text(encoding="utf-8", errors="ignore").splitlines(), start=1
        ):
            versions = {
                normalize_version_token(match.group("version"))
                for match in VERSION_TOKEN_RE.finditer(line)
            }
            if not versions:
                continue
            for package_name in packages:
                if not line_mentions_package(line, package_name):
                    continue
                expected = expected_versions[package_name]
                stale_versions = sorted(
                    version for version in versions if version != expected
                )
                for version in stale_versions:
                    mismatches[package_name].append(f"{version} (line {line_number})")

        for package_name, current_values in sorted(mismatches.items()):
            unique_values = list(dict.fromkeys(current_values))
            drifts.append(
                Drift(
                    file=path,
                    package=package_name,
                    current=", ".join(unique_values),
                    expected=expected_versions[package_name],
                    action="AUX_PIN_DRIFT",
                )
            )
    return drifts


def run_text_command(
    command: list[str],
    cwd: Path | None = None,
    timeout: int = NPM_TIMEOUT_SECONDS,
) -> tuple[int, str, str] | None:
    try:
        result = subprocess.run(
            command,
            cwd=cwd,
            capture_output=True,
            text=True,
            check=False,
            timeout=timeout,
        )
    except (OSError, subprocess.TimeoutExpired):
        return None
    return result.returncode, result.stdout.strip(), result.stderr.strip()


def git_tag_exists(repo_root: Path, tag: str) -> bool | None:
    if not repo_root.is_dir() or shutil.which("git") is None:
        return None
    result = run_text_command(["git", "tag", "--list", tag], cwd=repo_root)
    if result is None:
        return None
    return result[1].splitlines() == [tag]


def git_show_file(repo_root: Path, ref: str, path: str) -> str | None:
    if shutil.which("git") is None:
        return None
    result = run_text_command(["git", "show", f"{ref}:{path}"], cwd=repo_root)
    if result is None or result[0] != 0:
        return None
    return result[1]


def version_from_sushi_text(text: str) -> str | None:
    data = yaml.safe_load(text) or {}
    if not isinstance(data, dict):
        return None
    version = data.get("version")
    return str(version) if version is not None else None


def github_repo_slug(repo_root: Path) -> str | None:
    if shutil.which("git") is None:
        return None
    result = run_text_command(["git", "remote", "get-url", "origin"], cwd=repo_root)
    if result is None or result[0] != 0:
        return None
    remote = result[1]
    match = re.search(r"github\.com[:/](?P<slug>[^/\s]+/[^/\s]+?)(?:\.git)?$", remote)
    if not match:
        return None
    return match.group("slug")


def github_release_exists(repo_root: Path, tag: str) -> bool | None:
    if shutil.which("gh") is None:
        return None
    slug = github_repo_slug(repo_root)
    if slug is None:
        return None
    result = run_text_command(
        ["gh", "release", "view", tag, "--repo", slug, "--json", "tagName"],
        cwd=repo_root,
    )
    if result is None:
        return None
    return result[0] == 0


def registry_package_version_exists(
    package_name: str, version: str, registry: str
) -> bool | None:
    if shutil.which("npm") is None:
        return None
    result = run_text_command(
        [
            "npm",
            "view",
            f"{package_name}@{version}",
            "version",
            "--registry",
            registry,
            "--silent",
        ]
    )
    if result is None:
        return None
    return result[0] == 0 and result[1] == version


def compute_tag_release_drifts(
    expected_versions: dict[str, str],
    registry: str,
    repo_roots: dict[str, Path] = LOCAL_IG_REPOS,
) -> list[Drift]:
    drifts: list[Drift] = []
    for package_name, repo_root in sorted(repo_roots.items()):
        sushi_path = repo_root / "sushi-config.yaml"
        consumer = read_consumer_file(sushi_path)
        if consumer is None:
            continue
        local_version = consumer.dependencies.get(package_name)
        if local_version is None:
            local_version = expected_versions.get(package_name)
        if local_version is None:
            continue

        tag = f"v{local_version}"
        tag_exists = git_tag_exists(repo_root, tag)
        if tag_exists is not True:
            continue

        tagged_sushi = git_show_file(repo_root, tag, "sushi-config.yaml")
        if tagged_sushi is not None:
            tagged_version = version_from_sushi_text(tagged_sushi)
            if tagged_version is not None and tagged_version != local_version:
                drifts.append(
                    Drift(
                        file=sushi_path,
                        package=package_name,
                        current=f"{tag} contains {tagged_version}",
                        expected=local_version,
                        action="TAG_VERSION_MISMATCH",
                    )
                )

        release_exists = github_release_exists(repo_root, tag)
        if release_exists is False:
            drifts.append(
                Drift(
                    file=repo_root,
                    package=package_name,
                    current=tag,
                    expected=f"GitHub release {tag}",
                    action="TAG_WITHOUT_RELEASE",
                )
            )

        registry_exists = registry_package_version_exists(
            package_name, local_version, registry
        )
        if registry_exists is False:
            drifts.append(
                Drift(
                    file=repo_root,
                    package=package_name,
                    current=tag,
                    expected=local_version,
                    action="TAG_WITHOUT_REGISTRY_PACKAGE",
                    registry="missing",
                )
            )
    return drifts


def fetch_json_url(url: str, timeout: int = NPM_TIMEOUT_SECONDS) -> Any:
    request = Request(url)
    with urlopen(request, timeout=timeout) as response:
        return json.loads(response.read().decode("utf-8"))


def package_list_current_entry(
    data: dict[str, Any],
    package_name: str,
    version: str,
    public_path: str,
) -> dict[str, Any] | None:
    entries = data.get("list", [])
    if not isinstance(entries, list):
        return None

    expected_package = f"{package_name}#{version}"
    expected_path = public_path.rstrip("/")
    for entry in entries:
        if not isinstance(entry, dict) or entry.get("current") is not True:
            continue
        entry_path = str(entry.get("path", "")).rstrip("/")
        if (
            entry.get("version") == version
            and entry.get("package") == expected_package
            and entry_path == expected_path
        ):
            return entry
    return None


def package_list_current_summary(data: dict[str, Any]) -> str:
    entries = data.get("list", [])
    if not isinstance(entries, list):
        return "no list array"
    current_entries = [
        entry
        for entry in entries
        if isinstance(entry, dict) and entry.get("current") is True
    ]
    if not current_entries:
        return "no current entries"
    return ", ".join(
        f"{entry.get('version')} ({entry.get('package')})"
        for entry in current_entries
    )


def compute_public_package_list_drifts(
    expected_versions: dict[str, str],
    fetcher: Callable[[str], Any] = fetch_json_url,
) -> list[Drift]:
    drifts: list[Drift] = []
    for package_name, target in sorted(PUBLIC_PACKAGE_LISTS.items()):
        expected = expected_versions.get(package_name)
        if expected is None:
            continue

        url = str(target["url"])
        public_path = str(target["path"])
        try:
            data = fetcher(f"{url}?release_audit={int(time.time())}")
        except (HTTPError, URLError, TimeoutError, json.JSONDecodeError, OSError) as error:
            drifts.append(
                Drift(
                    file=Path(url),
                    package=package_name,
                    current=f"unreachable: {error}",
                    expected=f"{package_name}#{expected} current",
                    action="PUBLIC_PACKAGE_LIST_STALE",
                    registry=url,
                )
            )
            continue

        if not isinstance(data, dict) or package_list_current_entry(
            data, package_name, expected, public_path
        ) is None:
            current = package_list_current_summary(data) if isinstance(data, dict) else "not a JSON object"
            drifts.append(
                Drift(
                    file=Path(url),
                    package=package_name,
                    current=current,
                    expected=f"{package_name}#{expected} current at {public_path}",
                    action="PUBLIC_PACKAGE_LIST_STALE",
                    registry=url,
                )
            )
    return drifts


def compute_legacy_package_list_deploy_target_drifts(
    repo_roots: dict[str, Path] = LOCAL_IG_REPOS,
) -> list[Drift]:
    drifts: list[Drift] = []
    for package_name, repo_root in sorted(repo_roots.items()):
        if not repo_root.is_dir():
            continue
        candidates = [
            *sorted((repo_root / ".github" / "workflows").glob("*.yml")),
            *sorted((repo_root / ".github" / "workflows").glob("*.yaml")),
            *sorted((repo_root / ".github" / "scripts").glob("*.py")),
        ]
        for path in candidates:
            if not path.is_file():
                continue
            text = path.read_text(encoding="utf-8", errors="ignore")
            found = [
                target
                for target in LEGACY_PACKAGE_LIST_DEPLOY_TARGETS
                if target in text
            ]
            if not found:
                continue
            drifts.append(
                Drift(
                    file=path,
                    package=package_name,
                    current=", ".join(found),
                    expected="/opt/fhir-proxy/html/<ig>/package-list.json via netbird runner",
                    action="LEGACY_PACKAGE_LIST_DEPLOY_TARGET",
                )
            )
    return drifts


def enrich_release_local_drifts(
    drifts: list[Drift], registry: str
) -> list[Drift]:
    enriched: list[Drift] = []
    started_at = time.monotonic()
    for drift in drifts:
        if drift.action != "RELEASE_LOCAL_OR_UPDATE_MANIFEST" or drift.registry:
            enriched.append(drift)
            continue
        registry_version = "unknown"
        if time.monotonic() - started_at <= REGISTRY_BUDGET_SECONDS:
            try:
                registry_version = npm_latest(drift.package, registry) or "unknown"
            except subprocess.TimeoutExpired:
                registry_version = "unknown"
        enriched.append(replace(drift, registry=registry_version))
    return enriched


def compute_release_audit_drifts(
    expected_versions: dict[str, str],
    registry: str,
) -> list[Drift]:
    drifts = [
        *compute_registry_metadata_drifts(expected_versions, registry),
        *compute_aux_pin_drifts(expected_versions),
        *compute_tag_release_drifts(expected_versions, registry),
        *compute_public_package_list_drifts(expected_versions),
        *compute_legacy_package_list_deploy_target_drifts(),
    ]
    return sorted(
        drifts, key=lambda drift: (display_path(drift.file), drift.package, drift.action)
    )


def manifest_dependency_edges(
    manifest: dict[str, Any],
    package_names: set[str],
    consumers: list[ConsumerFile] | None = None,
) -> dict[str, set[str]]:
    edges: dict[str, set[str]] = defaultdict(set)
    for section in ("igs", "packages", "bundles"):
        entries = manifest.get(section, {}) or {}
        if not isinstance(entries, dict):
            continue
        for package_name, package_data in entries.items():
            if package_name not in package_names or not isinstance(package_data, dict):
                continue
            dependency_maps: list[dict[str, Any]] = []
            dependencies = package_data.get("dependencies")
            if isinstance(dependencies, dict):
                dependency_maps.append(dependencies)
            cross_pins = package_data.get("cross_pins")
            if isinstance(cross_pins, dict):
                dependency_maps.append(cross_pins)
            for dependency_map in dependency_maps:
                for dependency_name in dependency_map:
                    if dependency_name in package_names:
                        edges[str(dependency_name)].add(str(package_name))
    for consumer in consumers or []:
        if consumer.package_name not in package_names:
            continue
        for dependency_name in consumer.dependencies:
            if dependency_name == consumer.package_name:
                continue
            if dependency_name in package_names:
                edges[str(dependency_name)].add(str(consumer.package_name))
    return edges


def topological_release_order(
    manifest: dict[str, Any],
    expected_versions: dict[str, str],
    consumers: list[ConsumerFile] | None = None,
) -> tuple[list[str], list[str]]:
    package_names = {
        package_name
        for package_name in expected_versions
        if package_name.startswith(REGISTRY_AUDIT_PACKAGE_PREFIXES)
    }
    edges = manifest_dependency_edges(manifest, package_names, consumers)
    inbound = {package_name: 0 for package_name in package_names}
    for targets in edges.values():
        for target in targets:
            inbound[target] += 1

    queue = deque(
        sorted(package_name for package_name, count in inbound.items() if count == 0)
    )
    order: list[str] = []
    while queue:
        package_name = queue.popleft()
        order.append(package_name)
        for target in sorted(edges.get(package_name, ())):
            inbound[target] -= 1
            if inbound[target] == 0:
                queue.append(target)

    cycle_nodes = sorted(
        package_name for package_name, count in inbound.items() if count > 0
    )
    return cycle_nodes, order


def package_from_registry_label(label: str) -> str | None:
    if "@" not in label:
        return None
    package_name, version = label.rsplit("@", 1)
    return package_name if package_name and version else None


def relevant_release_packages(
    drifts: list[Drift],
    expected_versions: dict[str, str],
    edges: dict[str, set[str]],
) -> set[str]:
    package_names = set(expected_versions)
    relevant: set[str] = set()
    for drift in drifts:
        if drift.package in package_names:
            relevant.add(drift.package)
        registry_package = package_from_registry_label(drift.registry)
        if registry_package in package_names:
            relevant.add(registry_package)

    changed = True
    while changed:
        changed = False
        for dependency_name, targets in edges.items():
            if targets.intersection(relevant) and dependency_name not in relevant:
                relevant.add(dependency_name)
                changed = True
    return relevant


def print_release_plan(
    manifest: dict[str, Any],
    expected_versions: dict[str, str],
    drifts: list[Drift],
    consumers: list[ConsumerFile] | None = None,
) -> None:
    package_names = {
        package_name
        for package_name in expected_versions
        if package_name.startswith(REGISTRY_AUDIT_PACKAGE_PREFIXES)
    }
    edges = manifest_dependency_edges(manifest, package_names, consumers)
    cycle_nodes, order = topological_release_order(
        manifest, expected_versions, consumers
    )
    relevant_packages = relevant_release_packages(drifts, expected_versions, edges)
    relevant_order = [package_name for package_name in order if package_name in relevant_packages]
    print("\nRelease-chain plan:")
    print(f"Dependency graph cycles: {'yes' if cycle_nodes else 'no'}")
    if cycle_nodes:
        print("Cycle nodes:")
        for package_name in cycle_nodes:
            print(f"- {package_name}@{expected_versions[package_name]}")
    if relevant_order:
        print("Relevant release order:")
        for package_name in relevant_order:
            print(f"- {package_name}@{expected_versions[package_name]}")
    elif order:
        print("Release order:")
        for package_name in order:
            print(f"- {package_name}@{expected_versions[package_name]}")
    else:
        print("Release order: no Cognovis registry packages found.")

    if any(drift.action == "REGISTRY_METADATA_STALE" for drift in drifts):
        print(
            "Downstream pin updates should wait until upstream registry metadata is clean."
        )


def display_path(path: Path) -> str:
    path_text = str(path)
    if not path.is_absolute() and path_text.startswith("npm:"):
        return path_text
    home = Path.home()
    try:
        return "~/" + str(path.resolve().relative_to(home))
    except ValueError:
        return path_text


def print_drift_table(drifts: list[Drift]) -> None:
    rows = [
        (
            display_path(drift.file),
            drift.package,
            drift.current,
            drift.expected,
            drift.registry,
            drift.action,
        )
        for drift in drifts
    ]
    headers = (
        "FILE",
        "PACKAGE",
        "LOCAL/ACTUAL",
        "MANIFEST/EXPECTED",
        "REGISTRY",
        "ACTION",
    )
    widths = [
        max(len(headers[index]), *(len(row[index]) for row in rows))
        if rows
        else len(headers[index])
        for index in range(len(headers))
    ]
    print(
        "  ".join(
            header.ljust(widths[index]) for index, header in enumerate(headers)
        )
    )
    for row in rows:
        print(
            "  ".join(
                value.ljust(widths[index]) for index, value in enumerate(row)
            )
        )
    if not rows:
        print("No drift found.")


def print_regeneration_followup(drifts: list[Drift]) -> None:
    regenerate_drifts = [drift for drift in drifts if drift.action == "REGENERATE"]
    if not regenerate_drifts:
        return

    packages = ", ".join(
        f"{drift.package} {drift.current} -> {drift.expected}"
        for drift in regenerate_drifts
    )
    paths = ", ".join(sorted({display_path(drift.file) for drift in regenerate_drifts}))

    print("\nRegeneration follow-up suggested:")
    print(
        "Create a new Polaris bead/workstream to regenerate @polaris/fhir-de "
        f"generated output for: {packages}."
    )
    print(f"Generated provenance roots: {paths}")
    print("Expected follow-up workflow:")
    print("1. File and claim a Polaris bead for the regeneration work.")
    print("2. Work in a separate workstream/branch in ~/code/polaris.")
    print("3. Apply/update FHIR package pins before regenerating.")
    print("4. Run: bun run --cwd packages/fhir-de generate")
    print("5. Run: bun run --cwd packages/fhir-de check:deidentification")
    print("6. Fix generation/type/test issues and rerun the relevant Polaris checks.")
    print("7. Commit, pull --rebase or merge current main, push beads data, and git push.")


def npm_latest(package_name: str, registry: str) -> str | None:
    if shutil.which("npm") is None:
        return None
    result = subprocess.run(
        [
            "npm",
            "view",
            package_name,
            "dist-tags.latest",
            "--registry",
            registry,
            "--silent",
        ],
        capture_output=True,
        text=True,
        check=False,
        timeout=NPM_TIMEOUT_SECONDS,
    )
    if result.returncode != 0:
        return None
    latest = result.stdout.strip()
    return latest or None


def version_key(version: str) -> tuple[int, ...] | None:
    normalized = version.strip().lstrip("^~")
    match = re.match(r"^(\d+)(?:\.(\d+))?(?:\.(\d+))?", normalized)
    if not match:
        return None
    return tuple(int(part) for part in match.groups("0"))


def registry_is_behind(latest: str, expected: str) -> bool:
    if version_lt(latest, expected):
        return True
    latest_key = version_key(latest)
    expected_key = version_key(expected)
    if latest_key is None or expected_key is None:
        return latest != expected
    return False


def version_lt(a: str, b: str) -> bool:
    a_key = version_key(a)
    b_key = version_key(b)
    return a_key is not None and b_key is not None and a_key < b_key


def print_unpublished_report(expected_versions: dict[str, str], registry: str) -> None:
    if shutil.which("npm") is None:
        print("\nRegistry check skipped: npm not found on PATH.")
        return

    unpublished: list[tuple[str, str, str]] = []
    skipped = 0
    started_at = time.monotonic()
    for package_name, expected in sorted(expected_versions.items()):
        if time.monotonic() - started_at > REGISTRY_BUDGET_SECONDS:
            skipped += 1
            break
        try:
            latest = npm_latest(package_name, registry)
        except subprocess.TimeoutExpired:
            skipped += 1
            continue
        if latest is None:
            continue
        if registry_is_behind(latest, expected):
            unpublished.append((package_name, latest, expected))

    print("\nUnpublished packages:")
    if skipped:
        print(f"Registry check skipped {skipped} package(s): npm timed out.")
    if not unpublished:
        print("None detected.")
        return

    headers = ("PACKAGE", "REGISTRY", "MANIFEST")
    widths = [
        max(len(headers[index]), *(len(row[index]) for row in unpublished))
        for index in range(len(headers))
    ]
    print(
        "  ".join(
            header.ljust(widths[index]) for index, header in enumerate(headers)
        )
    )
    for row in unpublished:
        print(
            "  ".join(
                value.ljust(widths[index]) for index, value in enumerate(row)
            )
        )


def apply_package_json(path: Path, expected_versions: dict[str, str]) -> bool:
    with path.open(encoding="utf-8") as handle:
        data = json.load(handle)

    changed = False
    package_name = data.get("name")
    if package_name in expected_versions and data.get("version") != expected_versions[package_name]:
        data["version"] = expected_versions[package_name]
        changed = True

    for field in PACKAGE_JSON_DEPENDENCY_FIELDS:
        dependencies = data.get(field)
        if dependencies is None:
            continue
        if not isinstance(dependencies, dict):
            continue
        for package_name, expected in expected_versions.items():
            current = dependencies.get(package_name)
            if (
                package_name in dependencies
                and is_package_json_version_pin(current)
                and current != expected
            ):
                dependencies[package_name] = expected
                changed = True

    if changed:
        with path.open("w", encoding="utf-8") as handle:
            json.dump(data, handle, ensure_ascii=False, indent=2)
            handle.write("\n")
    return changed


def apply_sushi(path: Path, expected_versions: dict[str, str]) -> bool:
    lines = path.read_text(encoding="utf-8").splitlines(keepends=True)
    changed = False
    in_dependencies = False
    dependency_indent: int | None = None

    for index, line in enumerate(lines):
        stripped = line.strip()
        if not stripped or stripped.startswith("#"):
            continue

        indent = len(line) - len(line.lstrip(" "))
        if stripped == "dependencies:":
            in_dependencies = True
            dependency_indent = None
            continue

        if in_dependencies:
            if indent == 0 and not line.startswith((" ", "\t")):
                break
            if dependency_indent is None and ":" in stripped:
                dependency_indent = indent
            if dependency_indent is not None and indent < dependency_indent:
                break
            match = re.match(
                r"^(?P<prefix>\s*)(?P<name>[^:#][^:]*):(?P<space>\s*)(?P<value>[^#\n]*?)(?P<suffix>\s*(?:#.*)?)(?P<newline>\r?\n?)$",
                line,
            )
            if not match:
                continue
            package_name = match.group("name").strip().strip("'\"")
            expected = expected_versions.get(package_name)
            if expected is None:
                continue
            current = match.group("value").strip().strip("'\"")
            if not current:
                for child_index in range(index + 1, len(lines)):
                    child_line = lines[child_index]
                    child_stripped = child_line.strip()
                    if not child_stripped or child_stripped.startswith("#"):
                        continue
                    child_indent = len(child_line) - len(child_line.lstrip(" "))
                    if child_indent <= indent:
                        break
                    if child_indent not in {indent + 2, indent + 4}:
                        continue
                    version_match = re.match(
                        r"^(?P<prefix>\s*)version:(?P<space>\s*)(?P<value>[^#\n]*?)(?P<suffix>\s*(?:#.*)?)(?P<newline>\r?\n?)$",
                        child_line,
                    )
                    if not version_match:
                        continue
                    child_current = version_match.group("value").strip().strip("'\"")
                    if child_current != expected:
                        lines[child_index] = (
                            f"{version_match.group('prefix')}version: "
                            f"{expected}{version_match.group('suffix')}{version_match.group('newline')}"
                        )
                        changed = True
                    break
                continue
            if current == expected:
                continue
            lines[index] = (
                f"{match.group('prefix')}{match.group('name')}: "
                f"{expected}{match.group('suffix')}{match.group('newline')}"
            )
            changed = True

    if changed:
        path.write_text("".join(lines), encoding="utf-8")
    return changed


def apply_drifts(consumers: list[ConsumerFile], manifest: dict[str, Any]) -> None:
    global_expected = build_effective_expected_versions(manifest, consumers)
    for consumer in consumers:
        expected_versions = expected_versions_for_consumer(
            manifest, consumer, global_expected
        )
        if consumer.kind == "sushi":
            apply_sushi(consumer.path, expected_versions)
        elif consumer.kind == "package-json":
            apply_package_json(consumer.path, expected_versions)


def run_drift_guard(repo_root: Path, manifest_path: Path) -> int:
    guard = repo_root / "scripts" / "check-fhir-version-drift.sh"
    if not guard.is_file():
        print(f"Drift guard not found: {guard}", file=sys.stderr)
        return 1
    result = subprocess.run(
        [str(guard), str(manifest_path), str(repo_root / "packages")],
        cwd=repo_root,
        check=False,
    )
    return result.returncode


def main() -> int:
    args = parse_args()
    manifest_path = find_manifest(args.manifest)
    repo_root = repo_root_from_manifest(manifest_path)
    manifest = load_yaml(manifest_path)
    consumers = discover_consumers(repo_root)
    drifts = compute_drifts(consumers, manifest, GENERATED_PROVENANCE_ROOTS)
    expected_versions = build_effective_expected_versions(manifest, consumers)
    drifts = enrich_release_local_drifts(drifts, args.registry)
    if args.release_audit:
        drifts = sorted(
            [
                *drifts,
                *compute_release_audit_drifts(expected_versions, args.registry),
            ],
            key=lambda drift: (display_path(drift.file), drift.package, drift.action),
        )

    print_drift_table(drifts)
    sys.stdout.flush()
    print_unpublished_report(expected_versions, args.registry)
    if args.release_audit:
        print_release_plan(manifest, expected_versions, drifts, consumers)
    print_regeneration_followup(drifts)

    if args.apply:
        apply_drifts(consumers, manifest)
        guard_status = run_drift_guard(repo_root, manifest_path)
        if guard_status != 0:
            return guard_status
        if any(drift.action in NON_APPLYABLE_ACTIONS for drift in drifts):
            return 1
        return guard_status

    return 1 if drifts else 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (FileNotFoundError, ValueError, yaml.YAMLError, json.JSONDecodeError) as error:
        print(f"ERROR: {error}", file=sys.stderr)
        raise SystemExit(2)
