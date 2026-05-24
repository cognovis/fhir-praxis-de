#!/usr/bin/env python3
"""Orchestrate trusted FHIR IG preflight, publish handoff, and registry watch."""

# Vendored from cognovis/library-core@7589f980e00435e051e5a2bb417f129cde929786.

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import time
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Callable, Optional
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen

import yaml


DEFAULT_REGISTRY = "https://npm.cognovis.de"
DEFAULT_PUBLISHER_URL = (
    "https://github.com/HL7/fhir-ig-publisher/releases/latest/download/publisher.jar"
)
DEFAULT_PROFILE_FILE = ".fhir-publish.yml"
DEFAULT_LOG_DIR = ".fhir-publish/logs"
DEFAULT_HANDOFF_FILE = ".fhir-publish/preflight.json"
PUBLIC_IG_PATHS = {
    "de.cognovis.fhir.praxis": "https://fhir.cognovis.de/praxis",
    "de.cognovis.fhir.dental": "https://fhir.cognovis.de/dental",
}
REQUIRED_FILES = (
    "VERSION",
    "sushi-config.yaml",
    "scripts/build-package.sh",
    "scripts/qa_gate.py",
)
SELF_HOSTED_LABEL_SETS = (
    ("self-hosted", "Linux", "X64", "docker", "atlas"),
    ("self-hosted", "Linux", "X64", "docker", "atlas-2"),
    ("self-hosted", "Linux", "X64", "docker", "elysium"),
    ("self-hosted", "Linux", "X64", "docker", "kaji-2"),
)
TAIL_LIMIT = 4000


@dataclass(frozen=True)
class RepoMetadata:
    repo: Path
    package_id: str
    version: str
    sushi_version: str
    commit_sha: str | None
    publisher_jar: Path
    publisher_url: str
    publisher_sha256: str | None
    config: dict[str, Any]
    config_path: Path | None
    log_dir: Path
    handoff_file: Path
    cache_state: dict[str, Any]


@dataclass(frozen=True)
class TrustDecision:
    trusted: bool
    reason: str


def tail_text(value: str, limit: int = TAIL_LIMIT) -> str:
    if len(value) <= limit:
        return value
    return value[-limit:]


def envelope(
    status: str,
    summary: str,
    data: dict[str, Any] | None = None,
    errors: list[str] | None = None,
    next_steps: list[str] | None = None,
    warnings: list[str] | None = None,
) -> dict[str, Any]:
    return {
        "status": status,
        "summary": summary,
        "data": data or {},
        "errors": errors or [],
        "next_steps": next_steps or [],
        "warnings": warnings or [],
    }


def safe_phase_name(value: str) -> str:
    sanitized = re.sub(r"[^A-Za-z0-9_.-]+", "-", value).strip("-")
    return sanitized or "phase"


def command_exists(name: str) -> bool:
    return shutil.which(name) is not None


def sha256_file(path: Path) -> str | None:
    if not path.is_file():
        return None
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def phase_result(
    name: str,
    status: str,
    command: list[str] | None = None,
    duration_seconds: float = 0.0,
    returncode: int | None = None,
    stdout_tail: str = "",
    stderr_tail: str = "",
    log_path: Path | None = None,
    warnings: list[str] | None = None,
) -> dict[str, Any]:
    result: dict[str, Any] = {
        "name": name,
        "status": status,
        "command": command or [],
        "duration_seconds": duration_seconds,
        "returncode": returncode,
        "stdout_tail": stdout_tail,
        "stderr_tail": stderr_tail,
    }
    if log_path is not None:
        result["log_path"] = str(log_path)
    if warnings:
        result["warnings"] = warnings
    return result


def run_command(
    command: list[str],
    cwd: Path,
    dry_run: bool,
    name: str,
    timeout: int | None = None,
    log_dir: Path | None = None,
) -> dict[str, Any]:
    started_at = time.monotonic()
    if dry_run:
        return phase_result(name, "planned", command=command)

    result = subprocess.run(
        command,
        cwd=cwd,
        capture_output=True,
        text=True,
        check=False,
        timeout=timeout,
    )
    status = "ok" if result.returncode == 0 else "error"
    log_path = None
    if log_dir is not None:
        log_dir.mkdir(parents=True, exist_ok=True)
        log_path = log_dir / f"{safe_phase_name(name)}.log"
        log_path.write_text(
            "\n".join(
                [
                    f"$ {' '.join(command)}",
                    f"cwd: {cwd}",
                    f"returncode: {result.returncode}",
                    "",
                    "## stdout",
                    result.stdout,
                    "",
                    "## stderr",
                    result.stderr,
                ]
            ),
            encoding="utf-8",
        )
    return phase_result(
        name,
        status,
        command=command,
        duration_seconds=round(time.monotonic() - started_at, 3),
        returncode=result.returncode,
        stdout_tail=tail_text(result.stdout),
        stderr_tail=tail_text(result.stderr),
        log_path=log_path,
    )


def run_git(repo: Path, args: list[str]) -> tuple[int, str]:
    if shutil.which("git") is None:
        return 127, ""
    try:
        result = subprocess.run(
            ["git", *args],
            cwd=repo,
            capture_output=True,
            text=True,
            check=False,
        )
    except OSError:
        return 127, ""
    return result.returncode, result.stdout.strip()


def current_commit(repo: Path) -> str | None:
    returncode, stdout = run_git(repo, ["rev-parse", "HEAD"])
    return stdout if returncode == 0 and stdout else None


def worktree_is_clean(repo: Path) -> bool | None:
    returncode, stdout = run_git(repo, ["status", "--porcelain"])
    if returncode != 0:
        return None
    return stdout == ""


def read_sushi(path: Path) -> dict[str, Any]:
    with path.open(encoding="utf-8") as handle:
        data = yaml.safe_load(handle) or {}
    if not isinstance(data, dict):
        raise ValueError(f"Expected YAML mapping in {path}")
    return data


def load_publish_config(repo: Path) -> tuple[dict[str, Any], Path | None, list[str]]:
    config_path = repo / DEFAULT_PROFILE_FILE
    if not config_path.is_file():
        return {}, None, []
    try:
        with config_path.open(encoding="utf-8") as handle:
            data = yaml.safe_load(handle) or {}
    except (OSError, yaml.YAMLError) as error:
        return {}, config_path, [f"Could not read {DEFAULT_PROFILE_FILE}: {error}"]
    if not isinstance(data, dict):
        return {}, config_path, [f"Expected YAML mapping in {DEFAULT_PROFILE_FILE}"]
    return data, config_path, []


def nested_dict(data: dict[str, Any], key: str) -> dict[str, Any]:
    value = data.get(key)
    return value if isinstance(value, dict) else {}


def config_list(data: dict[str, Any], key: str, default: list[str]) -> list[str]:
    value = data.get(key)
    if value is None:
        return default
    if isinstance(value, list) and all(isinstance(item, str) for item in value):
        return value
    raise ValueError(f"{DEFAULT_PROFILE_FILE}:{key} must be a string list")


def normalize_command(value: Any, default: list[str]) -> list[str]:
    if value is None:
        return default
    if isinstance(value, str):
        return ["bash", "-lc", value]
    if isinstance(value, list) and all(isinstance(item, str) for item in value):
        return value
    raise ValueError("Configured command must be a string or string list")


def cache_state(repo: Path, publisher_jar: Path) -> dict[str, Any]:
    fhir_cache = Path.home() / ".fhir" / "packages"
    npm_cache = Path.home() / ".npm"
    gem_cache = Path.home() / ".gem"
    txcache = repo / "input-cache" / "txcache"
    publisher_hash = sha256_file(publisher_jar)
    return {
        "fhir_packages_dir": str(fhir_cache),
        "fhir_packages_present": fhir_cache.is_dir(),
        "fhir_package_count": len(list(fhir_cache.glob("*"))) if fhir_cache.is_dir() else 0,
        "txcache_present": txcache.exists(),
        "publisher_jar": str(publisher_jar),
        "publisher_jar_present": publisher_jar.is_file(),
        "publisher_jar_sha256": publisher_hash,
        "npm_cache_present": npm_cache.exists(),
        "gem_cache_present": gem_cache.exists(),
    }


def metadata_to_dict(metadata: RepoMetadata) -> dict[str, Any]:
    return {
        "repo": str(metadata.repo),
        "package_id": metadata.package_id,
        "version": metadata.version,
        "sushi_version": metadata.sushi_version,
        "commit_sha": metadata.commit_sha,
        "publisher_jar": str(metadata.publisher_jar),
        "publisher_url": metadata.publisher_url,
        "publisher_sha256": metadata.publisher_sha256,
        "config_path": str(metadata.config_path) if metadata.config_path else None,
        "log_dir": str(metadata.log_dir),
        "handoff_file": str(metadata.handoff_file),
        "cache_state": metadata.cache_state,
    }


def load_repo_metadata(
    repo: Path,
    version: str | None,
    package_id: str | None,
    publisher_jar: Path | None,
    require_shape: bool = True,
) -> tuple[RepoMetadata | None, list[str]]:
    repo = repo.expanduser().resolve()
    errors: list[str] = []
    config, config_path, config_errors = load_publish_config(repo)
    errors.extend(config_errors)
    preflight_config = nested_dict(config, "preflight")
    publisher_config = nested_dict(config, "publisher")
    artifact_config = nested_dict(config, "artifacts")

    if require_shape:
        try:
            required_files = config_list(
                preflight_config,
                "required_files",
                list(REQUIRED_FILES),
            )
        except ValueError as error:
            required_files = list(REQUIRED_FILES)
            errors.append(str(error))
        for required in required_files:
            if not (repo / required).is_file():
                errors.append(f"Missing required IG file: {required}")

    version_file = repo / "VERSION"
    sushi_file = repo / "sushi-config.yaml"
    version_value = version_file.read_text(encoding="utf-8").strip() if version_file.is_file() else ""
    sushi_data: dict[str, Any] = {}
    if sushi_file.is_file():
        try:
            sushi_data = read_sushi(sushi_file)
        except (OSError, yaml.YAMLError, ValueError) as error:
            errors.append(str(error))

    sushi_id = str(sushi_data.get("id") or "")
    sushi_version = str(sushi_data.get("version") or "")
    expected_version = version or version_value
    expected_package = package_id or sushi_id

    if version and version_value and version != version_value:
        errors.append(f"--version {version} does not match VERSION {version_value}")
    if package_id and sushi_id and package_id != sushi_id:
        errors.append(f"--package-id {package_id} does not match sushi id {sushi_id}")
    if version_value and sushi_version and version_value != sushi_version:
        errors.append(
            f"VERSION {version_value} does not match sushi-config.yaml {sushi_version}"
        )
    if not expected_version:
        errors.append("Could not determine package version")
    if not expected_package:
        errors.append("Could not determine package id")

    jar_path = (
        publisher_jar.expanduser().resolve()
        if publisher_jar is not None
        else Path(str(publisher_config.get("jar_path") or repo / "input-cache" / "publisher.jar"))
    )
    if not jar_path.is_absolute():
        jar_path = (repo / jar_path).resolve()
    publisher_url = str(publisher_config.get("url") or DEFAULT_PUBLISHER_URL)
    publisher_sha256 = publisher_config.get("sha256")
    if publisher_sha256 is not None:
        publisher_sha256 = str(publisher_sha256)
    log_dir = Path(str(artifact_config.get("log_dir") or DEFAULT_LOG_DIR))
    if not log_dir.is_absolute():
        log_dir = (repo / log_dir).resolve()
    handoff_file = Path(str(artifact_config.get("handoff_file") or DEFAULT_HANDOFF_FILE))
    if not handoff_file.is_absolute():
        handoff_file = (repo / handoff_file).resolve()
    metadata = RepoMetadata(
        repo=repo,
        package_id=expected_package,
        version=expected_version,
        sushi_version=sushi_version,
        commit_sha=current_commit(repo),
        publisher_jar=jar_path,
        publisher_url=publisher_url,
        publisher_sha256=publisher_sha256,
        config=config,
        config_path=config_path,
        log_dir=log_dir,
        handoff_file=handoff_file,
        cache_state=cache_state(repo, jar_path),
    )
    return metadata, errors


def discover_prefetch_scripts(repo: Path) -> list[Path]:
    scripts_dir = repo / "scripts"
    if not scripts_dir.is_dir():
        return []
    return sorted(scripts_dir.glob("prefetch*.sh"))


def configured_prefetch_commands(metadata: RepoMetadata) -> list[tuple[str, list[str]]]:
    preflight_config = nested_dict(metadata.config, "preflight")
    configured = preflight_config.get("prefetch_commands")
    if configured is None:
        return [
            (f"preload-{script.stem}", ["bash", str(script.relative_to(metadata.repo))])
            for script in discover_prefetch_scripts(metadata.repo)
        ]
    if not isinstance(configured, list):
        raise ValueError("preflight.prefetch_commands must be a list")
    commands: list[tuple[str, list[str]]] = []
    for index, item in enumerate(configured, start=1):
        if isinstance(item, dict):
            name = str(item.get("name") or f"preload-{index}")
            command = normalize_command(item.get("command"), [])
        else:
            name = f"preload-{index}"
            command = normalize_command(item, [])
        if not command:
            raise ValueError(f"preflight.prefetch_commands[{index}] has no command")
        commands.append((name, command))
    return commands


def configured_phase(
    metadata: RepoMetadata,
    phase_name: str,
    default_command: list[str],
    default_required: bool,
) -> tuple[list[str], bool]:
    phases_config = nested_dict(metadata.config, "phases")
    phase_config = nested_dict(phases_config, phase_name)
    command = normalize_command(phase_config.get("command"), default_command)
    required = phase_config.get("required", default_required)
    if not isinstance(required, bool):
        raise ValueError(f"phases.{phase_name}.required must be boolean")
    return command, required


def sushi_command(metadata: RepoMetadata) -> list[str]:
    default = ["sushi", "."] if command_exists("sushi") else ["npx", "--yes", "fsh-sushi", "."]
    command, _required = configured_phase(metadata, "sushi", default, True)
    return command


def skipped_phase(name: str, reason: str) -> dict[str, Any]:
    return phase_result(name, "skipped", stdout_tail=reason)


def verify_publisher_sha256_phase(metadata: RepoMetadata, dry_run: bool) -> dict[str, Any]:
    expected = metadata.publisher_sha256
    if not expected:
        warning = (
            "Publisher jar has no configured SHA256; use publisher.sha256 in "
            f"{DEFAULT_PROFILE_FILE} for reproducible releases."
        )
        return phase_result("publisher-jar-sha256", "skipped", stdout_tail=warning, warnings=[warning])
    if dry_run:
        return phase_result("publisher-jar-sha256", "planned")
    actual = sha256_file(metadata.publisher_jar)
    if actual == expected:
        return phase_result("publisher-jar-sha256", "ok", stdout_tail=actual or "")
    return phase_result(
        "publisher-jar-sha256",
        "error",
        returncode=1,
        stderr_tail=f"Expected {expected}, got {actual or 'missing'}",
    )


def build_preflight_phases(metadata: RepoMetadata, dry_run: bool) -> list[dict[str, Any]]:
    repo = metadata.repo
    phases: list[dict[str, Any]] = []

    for name, command in configured_prefetch_commands(metadata):
        phases.append(
            run_command(
                command,
                repo,
                dry_run,
                name,
                log_dir=metadata.log_dir,
            )
        )

    if not metadata.publisher_jar.is_file():
        if not dry_run:
            metadata.publisher_jar.parent.mkdir(parents=True, exist_ok=True)
        phases.append(
            run_command(
                [
                    "curl",
                    "-fL",
                    metadata.publisher_url,
                    "-o",
                    str(metadata.publisher_jar),
                ],
                repo,
                dry_run,
                "publisher-jar-download",
                log_dir=metadata.log_dir,
            )
        )
    else:
        phases.append(
            phase_result("publisher-jar", "cache-hit")
        )
    phases.append(verify_publisher_sha256_phase(metadata, dry_run))

    vendor_default = ["bash", "scripts/check-ig-vendor-leaks.sh"]
    vendor_command, vendor_required = configured_phase(
        metadata,
        "vendor_leak_guard",
        vendor_default,
        False,
    )
    qa_default = [
        "python3",
        "scripts/qa_gate.py",
        "--qa-html",
        "output/qa.html",
        "--allowlist",
        ".github/qa-allowlist.yml",
    ]
    qa_command, qa_required = configured_phase(metadata, "qa_gate", qa_default, True)
    build_command, build_required = configured_phase(
        metadata,
        "build_package",
        ["bash", "scripts/build-package.sh", "--skip-sushi"],
        True,
    )

    phases.append(
        run_command(sushi_command(metadata), repo, dry_run, "sushi", log_dir=metadata.log_dir)
    )
    if (repo / "scripts" / "check-ig-vendor-leaks.sh").is_file():
        phases.append(
            run_command(
                vendor_command,
                repo,
                dry_run,
                "vendor-leak-guard",
                log_dir=metadata.log_dir,
            )
        )
    elif vendor_required:
        phases.append(
            phase_result(
                "vendor-leak-guard",
                "error",
                returncode=1,
                stderr_tail="Missing required scripts/check-ig-vendor-leaks.sh.",
            )
        )
    else:
        phases.append(
            skipped_phase("vendor-leak-guard", "No scripts/check-ig-vendor-leaks.sh present.")
        )
    phases.append(
        run_command(
            ["java", "-jar", str(metadata.publisher_jar), "-ig", ".", "-no-sushi"],
            repo,
            dry_run,
            "ig-publisher",
            log_dir=metadata.log_dir,
        )
    )
    if (repo / "scripts" / "qa_gate.py").is_file():
        phases.append(
            run_command(
                qa_command,
                repo,
                dry_run,
                "qa-gate",
                log_dir=metadata.log_dir,
            )
        )
    elif qa_required:
        phases.append(
            phase_result(
                "qa-gate",
                "error",
                returncode=1,
                stderr_tail="Missing required scripts/qa_gate.py.",
            )
        )
    else:
        phases.append(skipped_phase("qa-gate", "No scripts/qa_gate.py present."))
    if (repo / "scripts" / "build-package.sh").is_file():
        phases.append(
            run_command(
                build_command,
                repo,
                dry_run,
                "build-package-final",
                log_dir=metadata.log_dir,
            )
        )
    elif build_required:
        phases.append(
            phase_result(
                "build-package-final",
                "error",
                returncode=1,
                stderr_tail="Missing required scripts/build-package.sh.",
            )
        )
    else:
        phases.append(
            skipped_phase("build-package-final", "No scripts/build-package.sh present.")
        )
    return phases


def phase_errors(phases: list[dict[str, Any]]) -> list[str]:
    return [
        f"{phase['name']} failed with exit {phase.get('returncode')}"
        for phase in phases
        if phase.get("status") == "error"
    ]


def phase_warnings(phases: list[dict[str, Any]]) -> list[str]:
    warnings: list[str] = []
    for phase in phases:
        for warning in phase.get("warnings") or []:
            warnings.append(f"{phase['name']}: {warning}")
    return warnings


def write_preflight_handoff(
    path: Path,
    metadata: RepoMetadata,
    status: str,
    phases: list[dict[str, Any]],
) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    payload = {
        "schema": "fhir-publish-ig.preflight.v1",
        "status": status,
        "package_id": metadata.package_id,
        "version": metadata.version,
        "commit_sha": metadata.commit_sha,
        "publisher_jar": str(metadata.publisher_jar),
        "publisher_jar_sha256": sha256_file(metadata.publisher_jar),
        "phases": [
            {
                "name": phase.get("name"),
                "status": phase.get("status"),
                "returncode": phase.get("returncode"),
                "log_path": phase.get("log_path"),
            }
            for phase in phases
        ],
    }
    path.write_text(json.dumps(payload, indent=2, sort_keys=True), encoding="utf-8")


def read_preflight_handoff(path: Path) -> tuple[str | None, list[str]]:
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as error:
        return None, [f"Could not read preflight handoff {path}: {error}"]
    if data.get("schema") != "fhir-publish-ig.preflight.v1":
        return None, [f"Unsupported preflight handoff schema in {path}"]
    if data.get("status") != "ok":
        return None, [f"Preflight handoff {path} did not record status ok"]
    commit_sha = data.get("commit_sha")
    if not isinstance(commit_sha, str) or not commit_sha:
        return None, [f"Preflight handoff {path} does not contain commit_sha"]
    return commit_sha, []


def preflight(args: argparse.Namespace) -> dict[str, Any]:
    metadata, errors = load_repo_metadata(
        args.repo, args.version, args.package_id, args.publisher_jar
    )
    if metadata is None:
        return envelope("error", "Could not read IG repo metadata.", errors=errors)

    clean = worktree_is_clean(metadata.repo)
    if clean is False and not args.allow_dirty:
        errors.append("Git worktree is dirty; pass --allow-dirty only for local preflight.")
    elif clean is None:
        errors.append("Could not determine git worktree status.")

    if errors:
        return envelope(
            "error",
            "FHIR IG preflight cannot start.",
            data={"metadata": metadata_to_dict(metadata)},
            errors=errors,
        )

    phases = build_preflight_phases(metadata, args.dry_run)
    errors.extend(phase_errors(phases))
    warnings = phase_warnings(phases)
    status = "error" if errors else "ok"
    handoff_file = args.handoff_file.expanduser().resolve() if args.handoff_file else metadata.handoff_file
    if status == "ok" and not args.dry_run:
        write_preflight_handoff(handoff_file, metadata, status, phases)
    summary = (
        "FHIR IG preflight planned."
        if args.dry_run and not errors
        else "FHIR IG preflight completed."
        if not errors
        else "FHIR IG preflight failed."
    )
    return envelope(
        status,
        summary,
        data={
            "repo": str(metadata.repo),
            "package_id": metadata.package_id,
            "version": metadata.version,
            "commit_sha": metadata.commit_sha,
            "dry_run": args.dry_run,
            "cache_state": metadata.cache_state,
            "handoff_file": str(handoff_file),
            "phases": phases,
        },
        errors=errors,
        warnings=warnings,
        next_steps=[
            (
                "Publish from the same commit: "
                f"python3 scripts/fhir-publish-ig.py publish "
                f"--repo {metadata.repo} --preflight-file {handoff_file} --execute --json"
            )
        ]
        if status == "ok" and not args.dry_run
        else [],
    )


def trust_from_context(
    trusted_event: bool,
    event_name: str | None,
    ref: str | None,
    ref_protected: str | None,
    repository: str | None,
    head_repository: str | None,
) -> TrustDecision:
    if trusted_event:
        return TrustDecision(True, "Operator supplied --trusted-event.")

    event_name = event_name or os.environ.get("GITHUB_EVENT_NAME")
    ref = ref or os.environ.get("GITHUB_REF")
    ref_protected = ref_protected or os.environ.get("GITHUB_REF_PROTECTED")
    repository = repository or os.environ.get("GITHUB_REPOSITORY")
    head_repository = head_repository or os.environ.get("GITHUB_HEAD_REPOSITORY")

    if not event_name or not ref:
        return TrustDecision(False, "Missing GitHub event context; fail closed.")

    if event_name in {"pull_request", "pull_request_target"}:
        if not repository or not head_repository or repository != head_repository:
            return TrustDecision(False, "Public or unknown fork PRs are not trusted.")

    allowed_ref = (
        ref == "refs/heads/main"
        or ref.startswith("refs/heads/release/")
        or ref.startswith("refs/tags/v")
    )
    if event_name in {"workflow_dispatch", "push"} and allowed_ref:
        if not ref_protected:
            return TrustDecision(False, f"Protection state for {ref} is unknown.")
        if ref_protected.lower() != "true":
            return TrustDecision(False, f"Ref {ref} is not protected.")
        return TrustDecision(True, f"{event_name} on trusted ref {ref}.")

    return TrustDecision(False, f"Event {event_name} on {ref} is not trusted.")


def remote_tag_sha(repo: Path, tag: str) -> str | None:
    returncode, stdout = run_git(repo, ["ls-remote", "--tags", "origin", f"refs/tags/{tag}"])
    if returncode != 0 or not stdout:
        return None
    return stdout.split()[0]


def local_tag_sha(repo: Path, tag: str) -> str | None:
    returncode, stdout = run_git(repo, ["rev-list", "-n", "1", tag])
    if returncode != 0 or not stdout:
        return None
    return stdout


def publish(args: argparse.Namespace) -> dict[str, Any]:
    metadata, errors = load_repo_metadata(
        args.repo, args.version, args.package_id, args.publisher_jar
    )
    if metadata is None:
        return envelope("error", "Could not read IG repo metadata.", errors=errors)

    decision = trust_from_context(
        args.trusted_event,
        args.event_name,
        args.ref,
        args.ref_protected,
        args.repository,
        args.head_repository,
    )
    if not decision.trusted:
        errors.append(decision.reason)

    current_sha = metadata.commit_sha
    preflight_sha = args.preflight_sha
    if not preflight_sha and args.preflight_file:
        preflight_sha, handoff_errors = read_preflight_handoff(
            args.preflight_file.expanduser().resolve()
        )
        errors.extend(handoff_errors)
    if args.execute:
        if not preflight_sha:
            errors.append("--execute requires --preflight-sha for the exact QA-passed commit.")
        elif current_sha and preflight_sha != current_sha:
            errors.append(
                f"--preflight-sha {preflight_sha} does not match HEAD {current_sha}"
            )

    tag = f"v{metadata.version}"
    local_existing = local_tag_sha(metadata.repo, tag)
    remote_existing = remote_tag_sha(metadata.repo, tag)
    if remote_existing and current_sha and remote_existing != current_sha:
        errors.append(f"Remote tag {tag} exists at {remote_existing}, not HEAD {current_sha}")
    if local_existing and current_sha and local_existing != current_sha:
        errors.append(f"Local tag {tag} exists at {local_existing}, not HEAD {current_sha}")

    perform_side_effects = args.execute and not errors
    phases = [
        {
            "name": "preflight-sha-gate",
            "status": "ok" if preflight_sha == current_sha else "planned",
            "command": [],
            "duration_seconds": 0.0,
            "returncode": None,
            "stdout_tail": "",
            "stderr_tail": "",
        },
    ]
    if local_existing == current_sha:
        phases.append(phase_result("create-tag", "skipped", stdout_tail=f"{tag} already exists locally."))
    else:
        phases.append(
            run_command(
                ["git", "tag", tag, current_sha or "HEAD"],
                metadata.repo,
                not perform_side_effects,
                "create-tag",
                log_dir=metadata.log_dir,
            )
        )
    if remote_existing == current_sha:
        phases.append(
            phase_result("push-tag", "skipped", stdout_tail=f"{tag} already exists on origin.")
        )
    else:
        phases.append(
            run_command(
                ["git", "push", "origin", tag],
                metadata.repo,
                not perform_side_effects,
                "push-tag",
                log_dir=metadata.log_dir,
            )
        )
    if perform_side_effects:
        errors.extend(phase_errors(phases))

    status = "error" if errors else "ok"
    next_steps = [
        (
            "Watch registry publication: "
            f"python3 scripts/fhir-publish-ig.py watch "
            f"--repo {metadata.repo} --package-id {metadata.package_id} "
            f"--version {metadata.version} --registry {args.registry} --json"
        ),
        (
            "After registry verification, run fhir-sync-versions with "
            "--release-audit before downstream regeneration."
        ),
    ]
    return envelope(
        status,
        "FHIR IG publish handoff planned." if not args.execute else "FHIR IG publish handoff ran.",
        data={
            "repo": str(metadata.repo),
            "package_id": metadata.package_id,
            "version": metadata.version,
            "commit_sha": current_sha,
            "tag": tag,
            "preflight_sha": preflight_sha,
            "preflight_file": str(args.preflight_file) if args.preflight_file else None,
            "local_tag_sha": local_existing,
            "remote_tag_sha": remote_existing,
            "trusted": decision.trusted,
            "trust_reason": decision.reason,
            "execute": args.execute,
            "phases": phases,
        },
        errors=errors,
        next_steps=next_steps,
    )


RegistryChecker = Callable[[str, str, str], tuple[bool, Optional[str]]]


def npm_registry_checker(package_id: str, version: str, registry: str) -> tuple[bool, str | None]:
    if shutil.which("npm") is None:
        return False, None
    result = subprocess.run(
        [
            "npm",
            "view",
            f"{package_id}@{version}",
            "version",
            "--registry",
            registry,
            "--silent",
        ],
        capture_output=True,
        text=True,
        check=False,
    )
    found = result.returncode == 0 and result.stdout.strip() == version
    if not found:
        return False, None
    latest = subprocess.run(
        [
            "npm",
            "view",
            package_id,
            "dist-tags.latest",
            "--registry",
            registry,
            "--silent",
        ],
        capture_output=True,
        text=True,
        check=False,
    )
    return True, latest.stdout.strip() if latest.returncode == 0 else None


def npm_registry_diagnostics(package_id: str, version: str, registry: str) -> dict[str, Any]:
    if shutil.which("npm") is None:
        return {"ok": False, "reason": "npm is not installed", "returncode": 127}
    result = subprocess.run(
        [
            "npm",
            "view",
            f"{package_id}@{version}",
            "version",
            "--registry",
            registry,
            "--silent",
        ],
        capture_output=True,
        text=True,
        check=False,
    )
    found = result.returncode == 0 and result.stdout.strip() == version
    reason = "found" if found else classify_failure(result.stderr + "\n" + result.stdout)
    return {
        "ok": found,
        "reason": reason,
        "returncode": result.returncode,
        "stdout_tail": tail_text(result.stdout),
        "stderr_tail": tail_text(result.stderr),
    }


def classify_failure(text: str) -> str:
    haystack = text.lower()
    patterns = [
        ("repo-rules", ("repo-rules:check", "repo rules", "repository rules")),
        ("lint", ("bun run lint", "eslint", "biome", "lint failed")),
        ("qa-gate", ("qa_gate", "qa gate", "qa.html", "ig qa")),
        ("missing-jekyll", ("jekyll", "bundler: command not found", "gem install")),
        ("verdaccio-auth", ("e401", "401 unauthorized", "unable to authenticate")),
        ("registry-unreachable", ("econnrefused", "enotfound", "network timeout", "etimedout")),
        ("missing-fhir-package", ("failed to find package", "package not found", ".fhir/packages")),
        ("vendor-leak", ("vendor leak", "check-ig-vendor-leaks")),
        ("branch-protection", ("protected branch", "gh006", "ruleset")),
        ("tag-exists", ("already exists", "would clobber existing tag")),
        ("shell-portability", ("declare: -a", "declare: -a:", "declare: -a: invalid option")),
    ]
    for label, needles in patterns:
        if any(needle in haystack for needle in needles):
            return label
    return "unknown"


def run_gh_json(args: list[str], repo: Path) -> tuple[dict[str, Any] | list[Any] | None, str | None]:
    if shutil.which("gh") is None:
        return None, "gh is not installed"
    result = subprocess.run(
        ["gh", *args],
        cwd=repo,
        capture_output=True,
        text=True,
        check=False,
    )
    if result.returncode != 0:
        reason = classify_failure(result.stderr + "\n" + result.stdout)
        return None, f"gh {' '.join(args)} failed: {reason}: {tail_text(result.stderr)}"
    try:
        return json.loads(result.stdout or "{}"), None
    except json.JSONDecodeError as error:
        return None, f"gh returned invalid JSON: {error}"


def github_run_status(repo: Path, commit_sha: str | None, run_id: str | None) -> dict[str, Any]:
    if run_id:
        data, error = run_gh_json(
            ["run", "view", run_id, "--json", "databaseId,status,conclusion,url,name"],
            repo,
        )
    elif commit_sha:
        data, error = run_gh_json(
            [
                "run",
                "list",
                "--commit",
                commit_sha,
                "--limit",
                "1",
                "--json",
                "databaseId,status,conclusion,url,name,headSha",
            ],
            repo,
        )
        if isinstance(data, list):
            data = data[0] if data else {}
    else:
        return {"ok": False, "complete": False, "error": "github-run watch requires --run-id or commit SHA"}
    if error:
        return {"ok": False, "complete": False, "error": error}
    if not isinstance(data, dict) or not data:
        return {"ok": False, "complete": False, "error": "No GitHub run found"}
    complete = data.get("status") == "completed"
    ok = complete and data.get("conclusion") == "success"
    return {"ok": ok, "complete": complete, "run": data}


def github_release_status(repo: Path, tag: str) -> dict[str, Any]:
    data, error = run_gh_json(
        ["release", "view", tag, "--json", "tagName,isDraft,isPrerelease,url,name"],
        repo,
    )
    if error:
        return {"ok": False, "error": error}
    return {"ok": True, "release": data}


def github_pr_status(repo: Path, pr: str | None) -> dict[str, Any]:
    args = ["pr", "view"]
    if pr:
        args.append(pr)
    args.extend(["--json", "number,state,mergeStateStatus,statusCheckRollup,url"])
    data, error = run_gh_json(args, repo)
    if error:
        return {"ok": False, "error": error}
    checks = data.get("statusCheckRollup", []) if isinstance(data, dict) else []
    failing = [
        check
        for check in checks
        if isinstance(check, dict)
        and check.get("conclusion") not in {None, "SUCCESS", "success"}
        and check.get("status") not in {"COMPLETED", "completed"}
    ]
    return {"ok": not failing, "pr": data, "failing_checks": failing}


def infer_public_ig_path(package_id: str, explicit_path: str | None = None) -> str | None:
    if explicit_path:
        return explicit_path.rstrip("/")
    return PUBLIC_IG_PATHS.get(package_id)


def public_package_list_status(package_id: str, version: str, public_ig_path: str | None) -> dict[str, Any]:
    public_path = infer_public_ig_path(package_id, public_ig_path)
    if public_path is None:
        return {
            "ok": False,
            "complete": True,
            "error": f"No public IG path configured for {package_id}; pass --public-ig-path.",
        }

    url = f"{public_path}/package-list.json?watch={int(time.time())}"
    try:
        request = Request(url)
        with urlopen(request, timeout=10) as response:
            data = json.loads(response.read().decode("utf-8"))
    except (HTTPError, URLError, TimeoutError, json.JSONDecodeError) as error:
        return {"ok": False, "complete": True, "error": f"Could not read {url}: {error}"}

    entries = data.get("list", []) if isinstance(data, dict) else []
    if not isinstance(entries, list):
        return {"ok": False, "complete": True, "error": f"{url} has no list array"}

    expected_package = f"{package_id}#{version}"
    current_entries = [
        entry
        for entry in entries
        if isinstance(entry, dict) and entry.get("current") is True
    ]
    for entry in current_entries:
        entry_path = str(entry.get("path", "")).rstrip("/")
        if (
            entry.get("version") == version
            and entry.get("package") == expected_package
            and entry_path == public_path
        ):
            return {
                "ok": True,
                "complete": True,
                "url": url,
                "entry": entry,
            }

    current = ", ".join(
        f"{entry.get('version')} ({entry.get('package')})"
        for entry in current_entries
    )
    return {
        "ok": False,
        "complete": True,
        "url": url,
        "error": f"{url} does not mark {expected_package} as current. Current entries: {current}",
    }


def poll_status(
    check: Callable[[], dict[str, Any]],
    timeout_seconds: int,
    poll_interval: int,
    stop_on_complete: bool = False,
) -> dict[str, Any]:
    started_at = time.monotonic()
    attempts = 0
    last_result: dict[str, Any] = {}
    while True:
        attempts += 1
        last_result = check()
        if last_result.get("ok"):
            break
        if stop_on_complete and last_result.get("complete"):
            break
        if time.monotonic() - started_at >= timeout_seconds:
            break
        time.sleep(poll_interval)
    last_result["attempts"] = attempts
    last_result["elapsed_seconds"] = round(time.monotonic() - started_at, 3)
    return last_result


def watch_registry(
    package_id: str,
    version: str,
    registry: str,
    timeout_seconds: int,
    poll_interval: int,
    checker: RegistryChecker = npm_registry_checker,
) -> dict[str, Any]:
    started_at = time.monotonic()
    attempts = 0
    latest: str | None = None
    while True:
        attempts += 1
        found, latest = checker(package_id, version, registry)
        if found:
            return {
                "found": True,
                "attempts": attempts,
                "elapsed_seconds": round(time.monotonic() - started_at, 3),
                "latest": latest,
            }
        if time.monotonic() - started_at >= timeout_seconds:
            return {
                "found": False,
                "attempts": attempts,
                "elapsed_seconds": round(time.monotonic() - started_at, 3),
                "latest": latest,
            }
        time.sleep(poll_interval)


def watch(args: argparse.Namespace) -> dict[str, Any]:
    metadata, errors = load_repo_metadata(
        args.repo,
        args.version,
        args.package_id,
        args.publisher_jar,
        require_shape=False,
    )
    package_id = args.package_id or (metadata.package_id if metadata else "")
    version = args.version or (metadata.version if metadata else "")
    if not package_id:
        errors.append("watch requires --package-id or sushi-config.yaml id.")
    if not version:
        errors.append("watch requires --version or VERSION.")
    if errors:
        return envelope("error", "Registry watch cannot start.", errors=errors)

    tag = f"v{version}"
    commit_sha = args.commit_sha or (metadata.commit_sha if metadata else None)
    if args.target == "all":
        targets = ["registry", "release", "github-run"]
    elif args.target == "postrelease":
        targets = ["registry", "release", "public-package-list"]
    else:
        targets = [args.target]
    results: dict[str, Any] = {}
    if args.dry_run:
        for target in targets:
            results[target] = {"planned": True}
    else:
        for target in targets:
            if target == "registry":
                results[target] = watch_registry(
                    package_id,
                    version,
                    args.registry,
                    args.timeout_seconds,
                    args.poll_interval,
                )
            elif target == "github-run":
                results[target] = poll_status(
                    lambda: github_run_status(
                        metadata.repo if metadata else args.repo,
                        commit_sha,
                        args.run_id,
                    ),
                    args.timeout_seconds,
                    args.poll_interval,
                    stop_on_complete=True,
                )
            elif target == "release":
                results[target] = poll_status(
                    lambda: github_release_status(metadata.repo if metadata else args.repo, tag),
                    args.timeout_seconds,
                    args.poll_interval,
                )
            elif target == "pr":
                results[target] = poll_status(
                    lambda: github_pr_status(metadata.repo if metadata else args.repo, args.pr),
                    args.timeout_seconds,
                    args.poll_interval,
                )
            elif target == "public-package-list":
                results[target] = poll_status(
                    lambda: public_package_list_status(
                        package_id,
                        version,
                        args.public_ig_path,
                    ),
                    args.timeout_seconds,
                    args.poll_interval,
                    stop_on_complete=True,
                )
            else:
                errors.append(f"Unknown watch target: {target}")
    if "registry" in results and not args.dry_run and not results["registry"].get("found"):
        diagnostics = npm_registry_diagnostics(package_id, version, args.registry)
        results["registry"]["diagnostics"] = diagnostics
        errors.append(f"{package_id}@{version} not visible in registry: {diagnostics['reason']}")
    for target in ("github-run", "release", "pr", "public-package-list"):
        if target in results and not args.dry_run and not results[target].get("ok"):
            errors.append(f"{target} watch failed: {results[target].get('error') or 'not ok'}")
    status = "ok" if args.dry_run or not errors else "error"
    next_steps = []
    if status == "ok":
        next_steps.append(
            "Run fhir-sync-versions --dry-run --release-audit after registry verification."
        )
    return envelope(
        status,
        "Registry watch planned." if args.dry_run else "Registry watch completed.",
        data={
            "package_id": package_id,
            "version": version,
            "registry": args.registry,
            "dry_run": args.dry_run,
            "target": args.target,
            "commit_sha": commit_sha,
            "tag": tag,
            "result": results if args.target != "registry" else results.get("registry", {}),
        },
        errors=errors,
        next_steps=next_steps,
    )


def tool_check(name: str, required: bool) -> dict[str, Any]:
    path = shutil.which(name)
    return {
        "name": name,
        "required": required,
        "ok": path is not None,
        "path": path,
    }


def runner_inventory(owner: str) -> tuple[list[dict[str, Any]], str | None]:
    data, error = run_gh_json(
        ["api", f"/orgs/{owner}/actions/runners", "--jq", ".runners"],
        Path.cwd(),
    )
    if error:
        return [], error
    if not isinstance(data, list):
        return [], "GitHub runner API did not return a list"
    return data, None


def runner_label_sets(runners: list[dict[str, Any]]) -> list[dict[str, Any]]:
    configured_sets = [set(labels) for labels in SELF_HOSTED_LABEL_SETS]
    result: list[dict[str, Any]] = []
    for runner in runners:
        labels = {
            label.get("name")
            for label in runner.get("labels", [])
            if isinstance(label, dict) and label.get("name")
        }
        matching = [
            sorted(label_set)
            for label_set in configured_sets
            if label_set.issubset(labels)
        ]
        result.append(
            {
                "name": runner.get("name"),
                "status": runner.get("status"),
                "busy": runner.get("busy"),
                "labels": sorted(labels),
                "matches_known_selector": bool(matching),
                "matching_selectors": matching,
            }
        )
    return result


def doctor(args: argparse.Namespace) -> dict[str, Any]:
    metadata, errors = load_repo_metadata(
        args.repo,
        args.version,
        args.package_id,
        args.publisher_jar,
        require_shape=False,
    )
    warnings: list[str] = []
    checks = [
        tool_check("git", True),
        tool_check("curl", True),
        tool_check("java", True),
        tool_check("npm", True),
        tool_check("python3", True),
        tool_check("bash", True),
        tool_check("gh", False),
        tool_check("jq", False),
        tool_check("ruby", False),
        tool_check("jekyll", False),
        tool_check("sushi", False),
        tool_check("npx", False),
    ]
    missing_required = [check["name"] for check in checks if check["required"] and not check["ok"]]
    if missing_required:
        errors.append(f"Missing required tools: {', '.join(missing_required)}")
    if not any(check["name"] in {"sushi", "npx"} and check["ok"] for check in checks):
        errors.append("Missing SUSHI execution path: install sushi or npx")
    if not any(check["name"] in {"jekyll", "ruby"} and check["ok"] for check in checks):
        warnings.append("Ruby/Jekyll path not detected; IG Publisher may fail when templates need Jekyll.")

    registry = (
        npm_registry_diagnostics(metadata.package_id, metadata.version, args.registry)
        if metadata and metadata.package_id and metadata.version
        else {"ok": False, "reason": "package metadata unavailable"}
    )
    if metadata and metadata.publisher_url == DEFAULT_PUBLISHER_URL and not metadata.publisher_sha256:
        warnings.append(
            f"Publisher is configured through latest URL without SHA256; pin publisher.url and publisher.sha256 in {DEFAULT_PROFILE_FILE}."
        )

    runners: list[dict[str, Any]] = []
    runner_error = None
    if args.check_runners:
        inventory, runner_error = runner_inventory(args.github_owner)
        if runner_error:
            warnings.append(runner_error)
        runners = runner_label_sets(inventory)
        online_matching = any(
            runner.get("status") == "online" and runner.get("matches_known_selector")
            for runner in runners
        )
        if inventory and not online_matching:
            warnings.append("No online runner matched the known self-hosted label selectors.")

    return envelope(
        "error" if errors else "ok",
        "FHIR IG publish doctor completed.",
        data={
            "metadata": metadata_to_dict(metadata) if metadata else None,
            "tools": checks,
            "registry": registry,
            "runners": runners,
            "runner_error": runner_error,
        },
        errors=errors,
        warnings=warnings,
    )


def add_common_arguments(parser: argparse.ArgumentParser) -> None:
    parser.add_argument("--repo", type=Path, default=Path.cwd(), help="FHIR IG repo root")
    parser.add_argument("--version", help="expected package version")
    parser.add_argument("--package-id", help="expected FHIR package id")
    parser.add_argument("--registry", default=DEFAULT_REGISTRY, help="npm registry URL")
    parser.add_argument("--public-ig-path", help="public IG base URL for package-list verification")
    parser.add_argument("--publisher-jar", type=Path, help="publisher.jar path")
    parser.add_argument("--json", action="store_true", help="emit JSON envelope")


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Trusted FHIR IG preflight, publish handoff, and registry watch."
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    preflight_parser = subparsers.add_parser("preflight", help="run or plan IG QA preflight")
    add_common_arguments(preflight_parser)
    preflight_parser.add_argument("--dry-run", action="store_true", help="plan only")
    preflight_parser.add_argument(
        "--handoff-file",
        type=Path,
        help="write QA-passed preflight handoff JSON to this path",
    )
    preflight_parser.add_argument(
        "--allow-dirty",
        action="store_true",
        help="allow local preflight on a dirty worktree",
    )
    preflight_parser.set_defaults(handler=preflight)

    publish_parser = subparsers.add_parser("publish", help="create and push release tag")
    add_common_arguments(publish_parser)
    publish_parser.add_argument("--execute", action="store_true", help="perform tag push")
    publish_parser.add_argument("--preflight-sha", help="QA-passed commit SHA")
    publish_parser.add_argument(
        "--preflight-file",
        type=Path,
        help="read QA-passed commit SHA from a preflight handoff JSON",
    )
    publish_parser.add_argument(
        "--trusted-event",
        action="store_true",
        help="operator asserts protected trusted execution context",
    )
    publish_parser.add_argument("--event-name", help="GitHub event name override")
    publish_parser.add_argument("--ref", help="GitHub ref override")
    publish_parser.add_argument("--ref-protected", help="GitHub ref protected override")
    publish_parser.add_argument("--repository", help="GitHub repository override")
    publish_parser.add_argument("--head-repository", help="GitHub PR head repository override")
    publish_parser.set_defaults(handler=publish)

    watch_parser = subparsers.add_parser("watch", help="poll registry for package version")
    add_common_arguments(watch_parser)
    watch_parser.add_argument("--dry-run", action="store_true", help="plan only")
    watch_parser.add_argument(
        "--target",
        choices=["registry", "github-run", "release", "pr", "public-package-list", "postrelease", "all"],
        default="registry",
        help="publication surface to watch",
    )
    watch_parser.add_argument("--commit-sha", help="commit SHA for github-run watch")
    watch_parser.add_argument("--run-id", help="GitHub Actions run id for github-run watch")
    watch_parser.add_argument("--pr", help="PR number or branch for pr watch")
    watch_parser.add_argument("--timeout-seconds", type=int, default=600)
    watch_parser.add_argument("--poll-interval", type=int, default=15)
    watch_parser.set_defaults(handler=watch)

    doctor_parser = subparsers.add_parser("doctor", help="diagnose local, registry, and runner readiness")
    add_common_arguments(doctor_parser)
    doctor_parser.add_argument(
        "--check-runners",
        action="store_true",
        help="query GitHub self-hosted runner inventory via gh",
    )
    doctor_parser.add_argument("--github-owner", default="cognovis", help="GitHub org for runner checks")
    doctor_parser.set_defaults(handler=doctor)

    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    result = args.handler(args)
    print(json.dumps(result, indent=2, sort_keys=True))
    return 0 if result["status"] == "ok" else 1


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, subprocess.TimeoutExpired, yaml.YAMLError, ValueError) as error:
        print(
            json.dumps(
                envelope("error", "FHIR IG publish helper failed.", errors=[str(error)]),
                indent=2,
                sort_keys=True,
            ),
            file=sys.stderr,
        )
        raise SystemExit(2)
