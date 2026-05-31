#!/usr/bin/env python3
"""Verify that a FHIR IG release is visible on all public release surfaces."""

from __future__ import annotations

import argparse
import base64
import json
import os
import sys
import time
from dataclasses import dataclass
from typing import Any
from urllib.error import HTTPError, URLError
from urllib.parse import quote
from urllib.request import Request, urlopen


DEFAULT_REGISTRY = "https://npm.cognovis.de"
DEFAULT_TIMEOUT_SECONDS = 10


@dataclass(frozen=True)
class CheckResult:
    name: str
    ok: bool
    summary: str
    details: dict[str, Any]


def http_json(url: str, headers: dict[str, str] | None = None, timeout: int = DEFAULT_TIMEOUT_SECONDS) -> Any:
    request = Request(url, headers=headers or {})
    with urlopen(request, timeout=timeout) as response:
        return json.loads(response.read().decode("utf-8"))


def http_ok(url: str, headers: dict[str, str] | None = None, timeout: int = DEFAULT_TIMEOUT_SECONDS) -> bool:
    request = Request(url, headers=headers or {}, method="GET")
    with urlopen(request, timeout=timeout) as response:
        return 200 <= response.status < 400


def basic_auth_value(token: str, username: str = "cognovis") -> str:
    token = token.strip()
    if not token:
        return ""

    try:
        decoded = base64.b64decode(token, validate=True).decode("utf-8")
    except Exception:
        decoded = ""

    if ":" in decoded:
        return f"Basic {token}"
    if ":" in token:
        return "Basic " + base64.b64encode(token.encode("utf-8")).decode("ascii")
    return "Basic " + base64.b64encode(f"{username}:{token}".encode("utf-8")).decode("ascii")


def npmrc_auth_header(registry: str) -> str:
    """Read auth for `registry` from the ambient ~/.npmrc.

    So a local releaser who is logged in via ~/.npmrc does NOT need to also export
    VERDACCIO_TOKEN — matching release-fhir-packages.sh, which uses npm (and thus
    ~/.npmrc) directly. Without this, an env-token-only header meant every
    advance-package-list run with only ~/.npmrc hit a 401 on the private registry.
    """
    npmrc = os.path.expanduser("~/.npmrc")
    if not os.path.isfile(npmrc):
        return ""
    host = registry.split("://", 1)[-1].rstrip("/")
    auth = ""
    token = ""
    try:
        with open(npmrc, encoding="utf-8") as handle:
            for raw in handle:
                line = raw.strip()
                if line.startswith(f"//{host}/:_auth="):
                    auth = line.split("=", 1)[1].strip()
                elif line.startswith(f"//{host}/:_authToken="):
                    token = line.split("=", 1)[1].strip()
    except OSError:
        return ""
    if auth:  # already base64("user:pass") as npm stores it
        return f"Basic {auth}"
    if token:
        return f"Bearer {token}"
    return ""


def registry_headers(env: dict[str, str], registry: str = DEFAULT_REGISTRY) -> dict[str, str]:
    token = env.get("VERDACCIO_TOKEN") or env.get("NODE_AUTH_TOKEN") or env.get("NPM_TOKEN")
    if token:
        value = basic_auth_value(token)
        return {"Authorization": value} if value else {}
    # No env token — fall back to the ambient ~/.npmrc (the normal local case).
    value = npmrc_auth_header(registry)
    return {"Authorization": value} if value else {}


def github_headers(env: dict[str, str]) -> dict[str, str]:
    token = env.get("GITHUB_TOKEN") or env.get("GH_TOKEN")
    if not token:
        return {}
    return {
        "Accept": "application/vnd.github+json",
        "Authorization": f"Bearer {token}",
        "X-GitHub-Api-Version": "2022-11-28",
    }


def registry_metadata_url(registry: str, package_id: str) -> str:
    return f"{registry.rstrip('/')}/{quote(package_id, safe='')}"


def github_release_url(repository: str, version: str) -> str:
    return f"https://api.github.com/repos/{repository}/releases/tags/v{version}"


def public_package_list_url(public_ig_path: str) -> str:
    return f"{public_ig_path.rstrip('/')}/package-list.json?release_verify={int(time.time())}"


def verify_registry(
    package_id: str,
    version: str | None,
    registry: str,
    env: dict[str, str],
    timeout: int,
) -> tuple[CheckResult, str | None]:
    url = registry_metadata_url(registry, package_id)
    try:
        data = http_json(url, registry_headers(env, registry), timeout)
    except (HTTPError, URLError, TimeoutError, json.JSONDecodeError) as error:
        return (
            CheckResult(
                "registry",
                False,
                f"Could not read registry metadata for {package_id}: {error}",
                {"url": url},
            ),
            version,
        )

    versions = data.get("versions", {}) if isinstance(data, dict) else {}
    dist_tags = data.get("dist-tags", {}) if isinstance(data, dict) else {}
    latest = str(dist_tags.get("latest", "")) or None
    expected = version or latest

    if not expected:
        return (
            CheckResult(
                "registry",
                False,
                f"Registry metadata for {package_id} has no latest dist-tag",
                {"url": url},
            ),
            None,
        )

    if not isinstance(versions, dict) or expected not in versions:
        return (
            CheckResult(
                "registry",
                False,
                f"{package_id}@{expected} is not present in {registry}",
                {"url": url, "latest": latest},
            ),
            expected,
        )

    return (
        CheckResult(
            "registry",
            True,
            f"Registry version verified: {package_id}@{expected}",
            {"url": url, "latest": latest},
        ),
        expected,
    )


def verify_github_release(repository: str, version: str, env: dict[str, str], timeout: int) -> CheckResult:
    url = github_release_url(repository, version)
    try:
        data = http_json(url, github_headers(env), timeout)
    except HTTPError as error:
        return CheckResult("github-release", False, f"GitHub release v{version} not found: {error}", {"url": url})
    except (URLError, TimeoutError, json.JSONDecodeError) as error:
        return CheckResult("github-release", False, f"Could not read GitHub release v{version}: {error}", {"url": url})

    if data.get("draft") is True:
        return CheckResult("github-release", False, f"GitHub release v{version} is still a draft", {"url": url})

    return CheckResult(
        "github-release",
        True,
        f"GitHub release verified: v{version}",
        {"url": data.get("html_url") or url},
    )


def matching_current_entry(data: dict[str, Any], version: str, package_id: str, public_ig_path: str) -> dict[str, Any] | None:
    entries = data.get("list", [])
    if not isinstance(entries, list):
        return None

    expected_package = f"{package_id}#{version}"
    expected_path = public_ig_path.rstrip("/")
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


def current_entry_summary(data: dict[str, Any]) -> str:
    entries = data.get("list", [])
    if not isinstance(entries, list):
        return "no list array"
    current = [entry for entry in entries if isinstance(entry, dict) and entry.get("current") is True]
    if not current:
        return "no current entries"
    return ", ".join(f"{entry.get('version')} ({entry.get('package')})" for entry in current)


def verify_public_package_list(package_id: str, version: str, public_ig_path: str, timeout: int) -> CheckResult:
    url = public_package_list_url(public_ig_path)
    try:
        data = http_json(url, timeout=timeout)
    except (HTTPError, URLError, TimeoutError, json.JSONDecodeError) as error:
        return CheckResult("public-package-list", False, f"Could not read public package-list.json: {error}", {"url": url})

    if not isinstance(data, dict):
        return CheckResult("public-package-list", False, "Public package-list.json is not a JSON object", {"url": url})

    entry = matching_current_entry(data, version, package_id, public_ig_path)
    if entry is None:
        return CheckResult(
            "public-package-list",
            False,
            f"Public package-list.json does not mark {package_id}#{version} as current",
            {"url": url, "current": current_entry_summary(data)},
        )

    return CheckResult(
        "public-package-list",
        True,
        f"Public package-list.json current version verified: {package_id}#{version}",
        {"url": url, "entry": entry},
    )


def verify_public_root(public_ig_path: str, timeout: int) -> CheckResult:
    try:
        ok = http_ok(f"{public_ig_path.rstrip('/')}/", timeout=timeout)
    except (HTTPError, URLError, TimeoutError) as error:
        return CheckResult("public-root", False, f"Could not read public IG root: {error}", {"url": public_ig_path})
    return CheckResult("public-root", ok, f"Public IG root verified: {public_ig_path}", {"url": public_ig_path})


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--package-id", required=True)
    parser.add_argument("--version", help="expected version; defaults to registry latest")
    parser.add_argument("--public-ig-path", required=True)
    parser.add_argument("--repository", default=os.environ.get("GITHUB_REPOSITORY", ""))
    parser.add_argument("--registry", default=DEFAULT_REGISTRY)
    parser.add_argument("--timeout-seconds", type=int, default=DEFAULT_TIMEOUT_SECONDS)
    parser.add_argument("--skip-registry", action="store_true")
    parser.add_argument("--skip-github-release", action="store_true")
    parser.add_argument("--skip-public-package-list", action="store_true")
    parser.add_argument("--check-public-root", action="store_true")
    parser.add_argument("--json", action="store_true", help="emit a JSON summary")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    results: list[CheckResult] = []
    version = args.version

    if not args.skip_registry:
        registry_result, version = verify_registry(
            args.package_id,
            version,
            args.registry,
            os.environ,
            args.timeout_seconds,
        )
        results.append(registry_result)

    if not version:
        results.append(
            CheckResult(
                "version",
                False,
                "No version supplied and registry latest could not be resolved",
                {},
            )
        )
    else:
        if not args.skip_github_release:
            if not args.repository:
                results.append(CheckResult("github-release", False, "--repository or GITHUB_REPOSITORY is required", {}))
            else:
                results.append(verify_github_release(args.repository, version, os.environ, args.timeout_seconds))

        if not args.skip_public_package_list:
            results.append(verify_public_package_list(args.package_id, version, args.public_ig_path, args.timeout_seconds))

        if args.check_public_root:
            results.append(verify_public_root(args.public_ig_path, args.timeout_seconds))

    if args.json:
        print(
            json.dumps(
                {
                    "ok": all(result.ok for result in results),
                    "package_id": args.package_id,
                    "version": version,
                    "results": [result.__dict__ for result in results],
                },
                indent=2,
                sort_keys=True,
            )
        )
    else:
        for result in results:
            stream = sys.stdout if result.ok else sys.stderr
            print(result.summary, file=stream)

    return 0 if all(result.ok for result in results) else 1


if __name__ == "__main__":
    raise SystemExit(main())
