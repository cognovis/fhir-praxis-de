import argparse
import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parents[1] / "scripts"
sys.path.insert(0, str(SCRIPT_DIR))

import publish_ig


def write_ig_repo(tmp_path, version="0.67.0", sushi_version="0.67.0"):
    repo = tmp_path / "fhir-praxis-de"
    (repo / "scripts").mkdir(parents=True)
    (repo / ".github").mkdir()
    (repo / ".github" / "qa-allowlist.yml").write_text("version: '1'\npatterns: []\n")
    (repo / "VERSION").write_text(f"{version}\n", encoding="utf-8")
    (repo / "sushi-config.yaml").write_text(
        f"id: de.cognovis.fhir.praxis\nversion: {sushi_version}\ndependencies: {{}}\n",
        encoding="utf-8",
    )
    (repo / "scripts" / "build-package.sh").write_text("#!/usr/bin/env bash\n", encoding="utf-8")
    (repo / "scripts" / "qa_gate.py").write_text("#!/usr/bin/env python3\n", encoding="utf-8")
    (repo / "scripts" / "check-ig-vendor-leaks.sh").write_text(
        "#!/usr/bin/env bash\n", encoding="utf-8"
    )
    (repo / "input-cache").mkdir()
    (repo / "input-cache" / "publisher.jar").write_text("jar", encoding="utf-8")
    return repo


def namespace(**values):
    defaults = {
        "repo": Path("."),
        "version": None,
        "package_id": None,
        "registry": publish_ig.DEFAULT_REGISTRY,
        "publisher_jar": None,
        "json": True,
        "dry_run": False,
        "allow_dirty": False,
        "handoff_file": None,
        "execute": False,
        "preflight_sha": None,
        "preflight_file": None,
        "trusted_event": False,
        "event_name": None,
        "ref": None,
        "ref_protected": None,
        "repository": None,
        "head_repository": None,
        "target": "registry",
        "commit_sha": None,
        "run_id": None,
        "pr": None,
        "timeout_seconds": 1,
        "poll_interval": 1,
        "check_runners": False,
        "github_owner": "cognovis",
    }
    defaults.update(values)
    return argparse.Namespace(**defaults)


def test_preflight_dry_run_plans_expected_phases(tmp_path, monkeypatch):
    repo = write_ig_repo(tmp_path)
    monkeypatch.setattr(publish_ig, "current_commit", lambda repo: "abc123")
    monkeypatch.setattr(publish_ig, "worktree_is_clean", lambda repo: True)

    result = publish_ig.preflight(
        namespace(repo=repo, dry_run=True, allow_dirty=False)
    )

    assert result["status"] == "ok"
    assert result["data"]["package_id"] == "de.cognovis.fhir.praxis"
    assert result["data"]["cache_state"]["publisher_jar_present"] is True
    phase_names = [phase["name"] for phase in result["data"]["phases"]]
    assert phase_names == [
        "publisher-jar",
        "publisher-jar-sha256",
        "sushi",
        "vendor-leak-guard",
        "ig-publisher",
        "qa-gate",
        "build-package-final",
    ]
    assert all(
        phase["status"] in {"planned", "cache-hit", "skipped"}
        for phase in result["data"]["phases"]
    )
    assert all("duration_seconds" in phase for phase in result["data"]["phases"])


def test_preflight_version_mismatch_fails_before_commands(tmp_path, monkeypatch):
    repo = write_ig_repo(tmp_path, version="0.67.0", sushi_version="0.66.0")
    monkeypatch.setattr(publish_ig, "current_commit", lambda repo: "abc123")
    monkeypatch.setattr(publish_ig, "worktree_is_clean", lambda repo: True)

    result = publish_ig.preflight(
        namespace(repo=repo, dry_run=True, allow_dirty=False)
    )

    assert result["status"] == "error"
    assert "VERSION 0.67.0 does not match sushi-config.yaml 0.66.0" in result["errors"]


def test_trust_decision_fails_closed_for_unknown_and_fork_pr():
    unknown = publish_ig.trust_from_context(False, None, None, None, None, None)
    fork_pr = publish_ig.trust_from_context(
        False,
        "pull_request",
        "refs/heads/main",
        "true",
        "cognovis/fhir-praxis-de",
        "external/fhir-praxis-de",
    )

    assert unknown.trusted is False
    assert "fail closed" in unknown.reason
    assert fork_pr.trusted is False
    assert "fork PRs" in fork_pr.reason


def test_trust_decision_allows_protected_main_push():
    decision = publish_ig.trust_from_context(
        False,
        "push",
        "refs/heads/main",
        "true",
        "cognovis/fhir-praxis-de",
        None,
    )

    assert decision.trusted is True
    assert "trusted ref" in decision.reason


def test_trust_decision_fails_closed_when_protection_state_is_unknown():
    decision = publish_ig.trust_from_context(
        False,
        "workflow_dispatch",
        "refs/heads/main",
        None,
        "cognovis/fhir-praxis-de",
        None,
    )

    assert decision.trusted is False
    assert "Protection state" in decision.reason


def test_publish_execute_requires_matching_preflight_sha_without_side_effects(
    tmp_path, monkeypatch
):
    repo = write_ig_repo(tmp_path)
    monkeypatch.setattr(publish_ig, "current_commit", lambda repo: "abc123")
    calls = []

    def fake_run(command, cwd, dry_run, name, timeout=None, log_dir=None):
        calls.append((name, dry_run))
        return {
            "name": name,
            "status": "planned" if dry_run else "ok",
            "command": command,
            "duration_seconds": 0.0,
            "returncode": None,
            "stdout_tail": "",
            "stderr_tail": "",
        }

    monkeypatch.setattr(publish_ig, "run_command", fake_run)

    result = publish_ig.publish(
        namespace(
            repo=repo,
            execute=True,
            preflight_sha=None,
            trusted_event=True,
            event_name=None,
            ref=None,
            ref_protected=None,
            repository=None,
            head_repository=None,
        )
    )

    assert result["status"] == "error"
    assert "--execute requires --preflight-sha" in result["errors"][0]
    assert calls == [("create-tag", True), ("push-tag", True)]


def test_watch_registry_success_uses_checker_fixture():
    calls = []

    def checker(package_id, version, registry):
        calls.append((package_id, version, registry))
        return True, version

    result = publish_ig.watch_registry(
        "de.cognovis.fhir.praxis",
        "0.67.0",
        "https://registry.example.invalid",
        timeout_seconds=1,
        poll_interval=1,
        checker=checker,
    )

    assert result["found"] is True
    assert result["latest"] == "0.67.0"
    assert calls == [
        (
            "de.cognovis.fhir.praxis",
            "0.67.0",
            "https://registry.example.invalid",
        )
    ]


def test_watch_dry_run_returns_fhir_sync_next_step(tmp_path):
    result = publish_ig.watch(
        namespace(
            repo=tmp_path / "missing-repo-ok",
            version="0.67.0",
            package_id="de.cognovis.fhir.praxis",
            dry_run=True,
            timeout_seconds=1,
            poll_interval=1,
        )
    )

    assert result["status"] == "ok"
    assert "fhir-sync-versions --dry-run --release-audit" in result["next_steps"][0]


def test_profile_can_make_qa_gate_optional(tmp_path, monkeypatch):
    repo = write_ig_repo(tmp_path)
    (repo / "scripts" / "qa_gate.py").unlink()
    (repo / ".fhir-publish.yml").write_text(
        "\n".join(
            [
                "preflight:",
                "  required_files:",
                "    - VERSION",
                "    - sushi-config.yaml",
                "    - scripts/build-package.sh",
                "phases:",
                "  qa_gate:",
                "    required: false",
            ]
        ),
        encoding="utf-8",
    )
    monkeypatch.setattr(publish_ig, "current_commit", lambda repo: "abc123")
    monkeypatch.setattr(publish_ig, "worktree_is_clean", lambda repo: True)

    result = publish_ig.preflight(namespace(repo=repo, dry_run=True))

    assert result["status"] == "ok"
    qa_phase = next(phase for phase in result["data"]["phases"] if phase["name"] == "qa-gate")
    assert qa_phase["status"] == "skipped"


def test_preflight_writes_handoff_for_exact_commit(tmp_path, monkeypatch):
    repo = write_ig_repo(tmp_path)
    handoff = tmp_path / "preflight.json"
    monkeypatch.setattr(publish_ig, "current_commit", lambda repo: "abc123")
    monkeypatch.setattr(publish_ig, "worktree_is_clean", lambda repo: True)

    def fake_run(command, cwd, dry_run, name, timeout=None, log_dir=None):
        return publish_ig.phase_result(name, "ok", command=command, returncode=0)

    monkeypatch.setattr(publish_ig, "run_command", fake_run)

    result = publish_ig.preflight(namespace(repo=repo, handoff_file=handoff))
    sha, errors = publish_ig.read_preflight_handoff(handoff)

    assert result["status"] == "ok"
    assert sha == "abc123"
    assert errors == []


def test_publish_can_read_matching_preflight_handoff(tmp_path, monkeypatch):
    repo = write_ig_repo(tmp_path)
    handoff = tmp_path / "preflight.json"
    handoff.write_text(
        '{"schema":"fhir-publish-ig.preflight.v1","status":"ok","commit_sha":"abc123"}',
        encoding="utf-8",
    )
    monkeypatch.setattr(publish_ig, "current_commit", lambda repo: "abc123")
    monkeypatch.setattr(publish_ig, "local_tag_sha", lambda repo, tag: "abc123")
    monkeypatch.setattr(publish_ig, "remote_tag_sha", lambda repo, tag: "abc123")

    result = publish_ig.publish(
        namespace(repo=repo, preflight_file=handoff, trusted_event=True, execute=True)
    )

    assert result["status"] == "ok"
    assert result["data"]["preflight_sha"] == "abc123"
    assert [phase["status"] for phase in result["data"]["phases"]] == [
        "ok",
        "skipped",
        "skipped",
    ]


def test_failure_classifier_covers_release_pain_points():
    assert publish_ig.classify_failure("Run bun run repo-rules:check failed") == "repo-rules"
    assert publish_ig.classify_failure("npm ERR! code E401 401 Unauthorized") == "verdaccio-auth"
    assert publish_ig.classify_failure("bundler: command not found: jekyll") == "missing-jekyll"


def test_doctor_reports_pinned_publisher_warning(tmp_path, monkeypatch):
    repo = write_ig_repo(tmp_path)
    monkeypatch.setattr(publish_ig.shutil, "which", lambda name: f"/bin/{name}")
    monkeypatch.setattr(
        publish_ig,
        "npm_registry_diagnostics",
        lambda package_id, version, registry: {"ok": True, "reason": "found"},
    )

    result = publish_ig.doctor(namespace(repo=repo))

    assert result["status"] == "ok"
    assert any("pin publisher.url" in warning for warning in result["warnings"])
