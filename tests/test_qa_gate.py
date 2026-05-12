"""Tests for scripts/qa_gate.py — QA Release Gate for IG Publisher output.

Run: uv run pytest tests/test_qa_gate.py
"""
from __future__ import annotations

import subprocess
import sys
import tempfile
from pathlib import Path

import pytest

# Make qa_gate importable for unit-level tests
sys.path.insert(0, str(Path(__file__).parent.parent / "scripts"))

# ---------------------------------------------------------------------------
# Helpers to build synthetic qa.html content
# ---------------------------------------------------------------------------


def make_qa_html(error_messages: list[str], info_messages: list[str] | None = None) -> str:
    """Create synthetic qa.html matching real IG Publisher v2.2.4 format.

    Error rows use background-color: #ffcccc (parsed by gate).
    Info rows use background-color: #fffff2 (ignored by gate — not errors).
    The HTML comment provides authoritative counts used for the fast path.
    """
    info_messages = info_messages or []
    n_errors = len(error_messages)
    n_info = len(info_messages)

    # Build error rows (background: #ffcccc) — IG Publisher v2.2.x format:
    # <td>location</td><td><b>error</b></td><td><b>message</b></td><td>context</td>
    error_rows = ""
    for msg in error_messages:
        error_rows += (
            f'   <tr style="background-color: #ffcccc">\n'
            f'     <td><a href="test.html">test/resource.json</a></td>'
            f'<td><b>error</b></td>'
            f'<td><b>{msg}</b></td>'
            f'<td><a href="ctx.html">Context</a></td>\n'
            f'   </tr>\n'
        )

    # Build info rows (background: #fffff2) — must NOT be counted as errors
    info_rows = ""
    for msg in info_messages:
        info_rows += (
            f'   <tr style="background-color: #fffff2">\n'
            f'     <td><a href="test.html">test/resource.json</a></td>'
            f'<td><b>{msg}</b></td>'
            f'<td><a href="ctx.html">Context</a></td>\n'
            f'   </tr>\n'
        )

    return f"""<!DOCTYPE HTML>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<!-- broken links = 0, errors = {n_errors}, warn = 0, info = {n_info}-->
<head><title>Test IG : Validation Results</title></head>
<body>
<p>Generated Tue May 12 2026 for test.ig#0.1.0</p>
<tr><td>Summary:</td><td> errors = {n_errors}, warn = 0, info = {n_info}, broken links = 0.</td></tr>
<a name="sorted"> </a>
<p><b>Errors sorted by type</b></p>
<table class="grid">
{error_rows}{info_rows}
</table>
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
    If allowlist_content is None, --allowlist arg is not passed.
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
    html = make_qa_html(error_messages=[], info_messages=["Some informational message"])
    result = run_qa_gate(html, VALID_ALLOWLIST)
    assert result.returncode == 0, (
        f"Expected exit 0, got {result.returncode}\n"
        f"stdout: {result.stdout}\nstderr: {result.stderr}"
    )
    assert "internal_errors=0" in result.stdout or "0 internal error" in result.stdout.lower()


# ---------------------------------------------------------------------------
# Test 2: Internal error → gate fails (exit 1)
# ---------------------------------------------------------------------------


def test_internal_error_fails():
    """qa.html with an internal error → internal_errors=1, gate exits 1."""
    html = make_qa_html(error_messages=["Unknown profile 'http://example.com/StructureDefinition/Foo'"])
    result = run_qa_gate(html, VALID_ALLOWLIST)
    assert result.returncode == 1, (
        f"Expected exit 1, got {result.returncode}\n"
        f"stdout: {result.stdout}\nstderr: {result.stderr}"
    )
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
    html = make_qa_html(error_messages=errors)
    result = run_qa_gate(html, VALID_ALLOWLIST)
    assert result.returncode == 0, (
        f"Expected exit 0, got {result.returncode}\n"
        f"stdout: {result.stdout}\nstderr: {result.stderr}"
    )
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
    html = make_qa_html(error_messages=errors)
    result = run_qa_gate(html, VALID_ALLOWLIST)
    assert result.returncode == 1, (
        f"Expected exit 1, got {result.returncode}\n"
        f"stdout: {result.stdout}\nstderr: {result.stderr}"
    )


# ---------------------------------------------------------------------------
# Test 5: Empty allowlist → all errors counted as internal (fail-closed)
# ---------------------------------------------------------------------------


def test_empty_allowlist_fail_closed():
    """Empty allowlist with any error → fail-closed, gate fails."""
    errors = [
        "IG URL should refer directly to the ImplementationGuide resource",
    ]
    html = make_qa_html(error_messages=errors)
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
# Test 8: Missing allowlist → exit 1 (--allowlist is required)
# ---------------------------------------------------------------------------


def test_missing_allowlist_fails():
    """--allowlist not provided → argparse error, exit non-zero."""
    html = make_qa_html(error_messages=["Some error"])
    result = run_qa_gate(html, allowlist_content=None)
    assert result.returncode != 0, (
        f"Expected non-zero exit for missing allowlist, got {result.returncode}\n"
        f"stdout: {result.stdout}\nstderr: {result.stderr}"
    )


# ---------------------------------------------------------------------------
# Test 9: Malformed YAML allowlist → exit 1 with error message
# ---------------------------------------------------------------------------


def test_malformed_allowlist_fails():
    """Malformed YAML in allowlist → exit 1.

    The malformed allowlist has no valid 'pattern' entries (broken_entry key is
    unrecognized). The simple parser silently skips unrecognized keys, resulting
    in zero entries. With zero patterns the gate is fail-closed: all errors are
    internal → gate exits 1. We verify the gate does not silently pass.
    """
    malformed_yaml = "version: \"1\"\npatterns:\n  - broken_entry: [unclosed bracket"
    html = make_qa_html(error_messages=["Some error that forces allowlist loading"])
    result = run_qa_gate(html, malformed_yaml)
    assert result.returncode != 0, (
        f"Expected non-zero exit for malformed YAML allowlist, got {result.returncode}\n"
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
    html = make_qa_html(error_messages=errors)
    result = run_qa_gate(html, VALID_ALLOWLIST)
    assert result.returncode == 0, (
        f"v0.59.0 baseline should produce zero internal errors, got exit {result.returncode}\n"
        f"stdout: {result.stdout}\nstderr: {result.stderr}"
    )
    assert "internal_errors=0" in result.stdout or "0 internal error" in result.stdout.lower()


# ---------------------------------------------------------------------------
# Test 11: HTML entities in error messages are unescaped before allowlist matching
# ---------------------------------------------------------------------------


def make_qa_html_raw(error_rows_html: str, n_errors: int) -> str:
    """Build qa.html with a pre-formatted error row block (allows raw HTML entities)."""
    return f"""<!DOCTYPE HTML>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<!-- broken links = 0, errors = {n_errors}, warn = 0, info = 0-->
<head><title>Test IG : Validation Results</title></head>
<body>
<p>Generated Tue May 12 2026 for test.ig#0.1.0</p>
<tr><td>Summary:</td><td> errors = {n_errors}, warn = 0, info = 0, broken links = 0.</td></tr>
<a name="sorted"> </a>
<p><b>Errors sorted by type</b></p>
<table class="grid">
{error_rows_html}
</table>
</body>
</html>"""


def test_html_entities_unescaped_before_allowlist_matching():
    """Error messages with HTML-escaped characters are unescaped before allowlist matching.

    IG Publisher may emit messages like:
        Error from https://tx.fhir.org/r4: Error: The filter &quot;LIST = LL2255-7&quot; is not understood
    which must match the allowlist pattern containing literal double-quotes.
    Without html.unescape(), the pattern match fails and the error is counted as internal.
    """
    escaped_row = (
        '   <tr style="background-color: #ffcccc">\n'
        '     <td><a href="test.html">test/resource.json</a></td>'
        '<td><b>error</b></td>'
        '<td><b>Error from https://tx.fhir.org/r4: Error: The filter &quot;LIST = LL2255-7&quot; is not understood</b></td>'
        '<td><a href="ctx.html">Context</a></td>\n'
        '   </tr>\n'
    )
    html = make_qa_html_raw(escaped_row, n_errors=1)
    result = run_qa_gate(html, VALID_ALLOWLIST)
    assert result.returncode == 0, (
        "HTML-entity-escaped error message should match allowlist after unescape, "
        f"got exit {result.returncode}\n"
        f"stdout: {result.stdout}\nstderr: {result.stderr}"
    )
    assert "internal_errors=0" in result.stdout or "0 internal error" in result.stdout.lower()


def test_html_amp_entity_in_error_message():
    """&amp; entities in error messages are unescaped correctly."""
    allowlist_with_amp = """
version: "1"
patterns:
  - pattern: "Error: A & B condition not met"
    reason: "Test entity unescape"
    source: "test"
"""
    escaped_row = (
        '   <tr style="background-color: #ffcccc">\n'
        '     <td>f.json</td>'
        '<td><b>error</b></td>'
        '<td><b>Error: A &amp; B condition not met</b></td>'
        '<td>ctx</td>\n'
        '   </tr>\n'
    )
    html = make_qa_html_raw(escaped_row, n_errors=1)
    result = run_qa_gate(html, allowlist_with_amp)
    assert result.returncode == 0, (
        "&amp; should be unescaped to & before allowlist matching, "
        f"got exit {result.returncode}\n"
        f"stdout: {result.stdout}\nstderr: {result.stderr}"
    )


# ---------------------------------------------------------------------------
# Test 12: YAML parser rejects unclosed brackets (fail-closed, not fail-open)
# ---------------------------------------------------------------------------


def test_malformed_yaml_unclosed_bracket_rejected():
    """Allowlist with unclosed bracket in pattern value causes exit 1.

    Ensures the YAML parser raises ValueError for '[unclosed bracket' values,
    which load_allowlist converts to sys.exit(1). The gate must never silently
    pass due to a partial parse of a corrupt config.
    """
    malformed_yaml = (
        'version: "1"\npatterns:\n'
        '  - pattern: [unclosed bracket\n'
        '    reason: "test"\n'
        '    source: "test"'
    )
    html = make_qa_html(error_messages=["Some error"])
    result = run_qa_gate(html, malformed_yaml)
    assert result.returncode != 0, (
        "Unclosed bracket in pattern value must cause exit 1, "
        f"got exit {result.returncode}\n"
        f"stdout: {result.stdout}\nstderr: {result.stderr}"
    )


def test_malformed_yaml_partial_parse_not_fail_open():
    """Corrupt YAML that would yield a partial pattern list must not allow errors through.

    Directly verifies that _parse_yaml_simple raises ValueError for an unclosed
    bracket in a pattern value, preventing any partial pattern from being used.
    """
    from qa_gate import _parse_yaml_simple  # type: ignore

    corrupt_text = (
        'version: "1"\npatterns:\n'
        '  - pattern: [unclosed\n'
        '    reason: "r"\n'
        '    source: "s"'
    )
    try:
        _parse_yaml_simple(corrupt_text)
        assert False, "_parse_yaml_simple should raise ValueError for '[unclosed' pattern value"
    except ValueError:
        pass  # Expected


def test_malformed_yaml_flow_sequence_on_patterns_key_rejected():
    """Inline flow sequence on 'patterns:' key (other than []) causes exit 1."""
    malformed_yaml = 'version: "1"\npatterns: [- pattern: "x", reason: "y"]'
    html = make_qa_html(error_messages=["Some error"])
    result = run_qa_gate(html, malformed_yaml)
    assert result.returncode != 0, (
        "Inline non-empty flow sequence on patterns key must cause exit 1, "
        f"got exit {result.returncode}\n"
        f"stdout: {result.stdout}\nstderr: {result.stderr}"
    )
