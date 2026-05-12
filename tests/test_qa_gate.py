"""Tests for scripts/qa_gate.py — QA Release Gate for IG Publisher output.

Run: uv run pytest tests/test_qa_gate.py
"""
from __future__ import annotations

import subprocess
import sys
import tempfile
from pathlib import Path

import pytest

# ---------------------------------------------------------------------------
# Helpers to build synthetic qa.html content
# ---------------------------------------------------------------------------

def make_qa_html(errors: list[str], warnings: list[str] | None = None) -> str:
    """Build a minimal IG Publisher qa.html with given error/warning messages.

    The IG Publisher qa.html uses Bootstrap tables where each row has:
      <td class="...">Error</td>  or  <td class="...">Warning</td>
    followed by <td> with the message text.
    """
    warnings = warnings or []
    rows = []
    for msg in errors:
        rows.append(
            f'<tr><td class="bg-danger text-white">Error</td>'
            f'<td>{msg}</td></tr>'
        )
    for msg in warnings:
        rows.append(
            f'<tr><td class="bg-warning">Warning</td>'
            f'<td>{msg}</td></tr>'
        )
    table = (
        '<table class="table">'
        "<thead><tr><th>Severity</th><th>Message</th></tr></thead>"
        "<tbody>" + "".join(rows) + "</tbody>"
        "</table>"
    )
    return f"""<!DOCTYPE html>
<html>
<head><title>QA Report</title></head>
<body>
<h1>QA Report</h1>
{table}
</body>
</html>"""


def run_qa_gate(
    qa_html_content: str | None,
    allowlist_content: str | None,
    *,
    extra_args: list[str] | None = None,
) -> subprocess.CompletedProcess[str]:
    """Run scripts/qa_gate.py in a temp directory with synthetic files.

    If qa_html_content is None, qa.html is not created (missing file test).
    If allowlist_content is None, allowlist is not created.
    """
    script = Path(__file__).parent.parent / "scripts" / "qa_gate.py"
    with tempfile.TemporaryDirectory() as tmpdir:
        tmp = Path(tmpdir)
        if qa_html_content is not None:
            qa_file = tmp / "qa.html"
            qa_file.write_text(qa_html_content, encoding="utf-8")
        if allowlist_content is not None:
            allow_file = tmp / "qa-allowlist.yml"
            allow_file.write_text(allowlist_content, encoding="utf-8")

        cmd = [sys.executable, str(script), "--qa-html", str(tmp / "qa.html")]
        if allowlist_content is not None:
            cmd += ["--allowlist", str(tmp / "qa-allowlist.yml")]
        if extra_args:
            cmd += extra_args

        return subprocess.run(cmd, capture_output=True, text=True)


# ---------------------------------------------------------------------------
# Allowlist fixtures
# ---------------------------------------------------------------------------

VALID_ALLOWLIST = """
version: "1"
patterns:
  - pattern: "Error from https://tx.fhir.org/r4: Error: The filter \\"LIST = LL2255-7\\" is not understood"
    reason: "tx.fhir.org server-side LOINC filter limitation (external service)"
    source: "tx.fhir.org"
  - pattern: "IG URL should refer directly to the ImplementationGuide resource"
    reason: "de.basisprofil.r4 canonical resolution issue (external IG)"
    source: "de.basisprofil.r4"
  - pattern: "Unknown code '1255414003' in the CodeSystem 'http://snomed.info/sct'"
    reason: "SNOMED CT 1255414003 not yet indexed in international release"
    source: "snomed-ct"
  - pattern: "The link 'http://fhir.de/StructureDefinition/coverage-de-gkv"
    reason: "Broken link in multi-coverage.html — external canonical (de.basisprofil.r4)"
    source: "de.basisprofil.r4"
  - pattern: "The link 'http://fhir.de/StructureDefinition/coverage-de-basis"
    reason: "Broken link in multi-coverage.html — external canonical (de.basisprofil.r4)"
    source: "de.basisprofil.r4"
"""

EMPTY_ALLOWLIST = """
version: "1"
patterns: []
"""

# ---------------------------------------------------------------------------
# Test 1: Zero errors → gate passes (exit 0)
# ---------------------------------------------------------------------------

def test_zero_errors_passes():
    """qa.html with zero errors → internal_errors=0, gate exits 0."""
    html = make_qa_html(errors=[], warnings=["Some warning message"])
    result = run_qa_gate(html, VALID_ALLOWLIST)
    assert result.returncode == 0, f"Expected exit 0, got {result.returncode}\nstdout: {result.stdout}\nstderr: {result.stderr}"
    assert "internal_errors=0" in result.stdout or "0 internal error" in result.stdout.lower()


# ---------------------------------------------------------------------------
# Test 2: Internal error → gate fails (exit 1)
# ---------------------------------------------------------------------------

def test_internal_error_fails():
    """qa.html with an internal error → internal_errors=1, gate exits 1."""
    html = make_qa_html(errors=["Unknown profile 'http://example.com/StructureDefinition/Foo'"])
    result = run_qa_gate(html, VALID_ALLOWLIST)
    assert result.returncode == 1, f"Expected exit 1, got {result.returncode}\nstdout: {result.stdout}\nstderr: {result.stderr}"
    assert "1" in result.stdout  # internal_errors=1 mentioned


# ---------------------------------------------------------------------------
# Test 3: Allowlisted external errors → gate passes
# ---------------------------------------------------------------------------

def test_allowlisted_errors_pass():
    """qa.html with only external errors matching allowlist → internal_errors=0, gate passes."""
    errors = [
        "Error from https://tx.fhir.org/r4: Error: The filter \"LIST = LL2255-7\" is not understood",
        "Error from https://tx.fhir.org/r4: Error: The filter \"LIST = LL2255-7\" is not understood",
        "IG URL should refer directly to the ImplementationGuide resource",
        "IG URL should refer directly to the ImplementationGuide resource",
        "Unknown code '1255414003' in the CodeSystem 'http://snomed.info/sct'",
        "The link 'http://fhir.de/StructureDefinition/coverage-de-gkv",
        "The link 'http://fhir.de/StructureDefinition/coverage-de-basis",
    ]
    html = make_qa_html(errors=errors)
    result = run_qa_gate(html, VALID_ALLOWLIST)
    assert result.returncode == 0, f"Expected exit 0, got {result.returncode}\nstdout: {result.stdout}\nstderr: {result.stderr}"
    assert "internal_errors=0" in result.stdout or "0 internal error" in result.stdout.lower()


# ---------------------------------------------------------------------------
# Test 4: Mix of internal + allowlisted errors → gate fails
# ---------------------------------------------------------------------------

def test_mixed_errors_fail():
    """1 internal + 2 allowlisted errors → internal_errors=1, gate fails."""
    errors = [
        "Unknown profile 'http://example.com/StructureDefinition/Foo'",
        "IG URL should refer directly to the ImplementationGuide resource",
        "Unknown code '1255414003' in the CodeSystem 'http://snomed.info/sct'",
    ]
    html = make_qa_html(errors=errors)
    result = run_qa_gate(html, VALID_ALLOWLIST)
    assert result.returncode == 1, f"Expected exit 1, got {result.returncode}\nstdout: {result.stdout}\nstderr: {result.stderr}"


# ---------------------------------------------------------------------------
# Test 5: Empty allowlist → all errors counted as internal (fail-closed)
# ---------------------------------------------------------------------------

def test_empty_allowlist_fail_closed():
    """Empty allowlist with any error → fail-closed, gate fails."""
    errors = [
        "IG URL should refer directly to the ImplementationGuide resource",
    ]
    html = make_qa_html(errors=errors)
    result = run_qa_gate(html, EMPTY_ALLOWLIST)
    assert result.returncode == 1, (
        f"Expected exit 1 (fail-closed), got {result.returncode}\n"
        f"stdout: {result.stdout}\nstderr: {result.stderr}"
    )


# ---------------------------------------------------------------------------
# Test 6: Missing qa.html → error/exit 1
# ---------------------------------------------------------------------------

def test_missing_qa_html_fails():
    """Missing qa.html → exit 1 with error message."""
    result = run_qa_gate(qa_html_content=None, allowlist_content=VALID_ALLOWLIST)
    assert result.returncode != 0, (
        f"Expected non-zero exit for missing qa.html, got {result.returncode}\n"
        f"stdout: {result.stdout}\nstderr: {result.stderr}"
    )


# ---------------------------------------------------------------------------
# Test 7: Malformed/empty qa.html → error/exit 1
# ---------------------------------------------------------------------------

def test_empty_qa_html_fails():
    """Empty qa.html content → exit 1 with error message."""
    result = run_qa_gate(qa_html_content="", allowlist_content=VALID_ALLOWLIST)
    assert result.returncode != 0, (
        f"Expected non-zero exit for empty qa.html, got {result.returncode}\n"
        f"stdout: {result.stdout}\nstderr: {result.stderr}"
    )


# ---------------------------------------------------------------------------
# Test 8: Missing allowlist → exit 1 (fail-closed: no allowlist = block all)
# ---------------------------------------------------------------------------

def test_missing_allowlist_fails():
    """Missing allowlist file → exit 1 (fail-closed)."""
    html = make_qa_html(errors=["Some error"])
    result = run_qa_gate(html, allowlist_content=None)
    # With --allowlist not passed, script should fail or use empty allowlist
    # Fail-closed: no allowlist → treat as no patterns → all errors are internal
    assert result.returncode != 0, (
        f"Expected non-zero exit for missing allowlist with errors, got {result.returncode}\n"
        f"stdout: {result.stdout}\nstderr: {result.stderr}"
    )


# ---------------------------------------------------------------------------
# Test 9: Malformed YAML allowlist → exit 1
# ---------------------------------------------------------------------------

def test_malformed_allowlist_fails():
    """Malformed YAML in allowlist → exit 1."""
    malformed_yaml = "patterns: [unclosed bracket\nbroken: yaml: content: [\n"
    html = make_qa_html(errors=[], warnings=["some warning"])
    result = run_qa_gate(html, malformed_yaml)
    assert result.returncode != 0, (
        f"Expected non-zero exit for malformed YAML, got {result.returncode}\n"
        f"stdout: {result.stdout}\nstderr: {result.stderr}"
    )


# ---------------------------------------------------------------------------
# Test 10: v0.59.0 baseline — all 7 external errors → internal_errors=0
# ---------------------------------------------------------------------------

def test_v059_baseline_no_internal_errors():
    """Simulate v0.59.0 QA report: 7 external errors, all allowlisted → gate passes."""
    errors = [
        # 2x LOINC filter error
        "Error from https://tx.fhir.org/r4: Error: The filter \"LIST = LL2255-7\" is not understood",
        "Error from https://tx.fhir.org/r4: Error: The filter \"LIST = LL2255-7\" is not understood",
        # 2x IG URL error
        "IG URL should refer directly to the ImplementationGuide resource",
        "IG URL should refer directly to the ImplementationGuide resource",
        # 1x SNOMED error
        "Unknown code '1255414003' in the CodeSystem 'http://snomed.info/sct'",
        # 2x broken link errors
        "The link 'http://fhir.de/StructureDefinition/coverage-de-gkv' could not be resolved",
        "The link 'http://fhir.de/StructureDefinition/coverage-de-basis' could not be resolved",
    ]
    html = make_qa_html(errors=errors)
    result = run_qa_gate(html, VALID_ALLOWLIST)
    assert result.returncode == 0, (
        f"v0.59.0 baseline should produce zero internal errors, got exit {result.returncode}\n"
        f"stdout: {result.stdout}\nstderr: {result.stderr}"
    )
    assert "internal_errors=0" in result.stdout or "0 internal error" in result.stdout.lower()
