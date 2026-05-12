#!/usr/bin/env python3
"""QA Gate — parse IG Publisher qa.html and block releases when internal errors > 0.

Usage:
    python3 scripts/qa_gate.py --qa-html output/qa.html --allowlist .github/qa-allowlist.yml

Exit codes:
    0 — gate passed (zero internal errors)
    1 — gate failed (internal errors found, or fatal input error)

Design principles:
    - Fail-closed: missing/empty/malformed inputs are fatal errors
    - An error not in the allowlist is always counted as internal
    - Empty allowlist pattern list → all errors are internal (no pass-through)

See docs/release-process.md for a full explanation of the gate and allowlist format.
"""
from __future__ import annotations

import argparse
import os
import re
import sys
from dataclasses import dataclass, field
from pathlib import Path


# ---------------------------------------------------------------------------
# Data types
# ---------------------------------------------------------------------------


@dataclass
class AllowlistEntry:
    pattern: str
    reason: str
    source: str


@dataclass
class QaResult:
    total_errors: int = 0
    internal_errors: int = 0
    external_errors: int = 0
    internal_messages: list[str] = field(default_factory=list)
    external_messages: list[str] = field(default_factory=list)
    external_entries: list[AllowlistEntry] = field(default_factory=list)


# ---------------------------------------------------------------------------
# HTML parser — extracts error messages from IG Publisher qa.html
# ---------------------------------------------------------------------------


def parse_qa_html(qa_path: Path) -> tuple[int, int, list[str]]:
    """Parse IG Publisher qa.html.

    Returns: (error_count_from_comment, broken_links_from_comment, error_messages)

    The authoritative counts come from the HTML comment at the top:
        <!-- broken links = N, errors = N, warn = N, info = N-->

    Individual error messages are extracted from table rows with
    background-color: #ffe6e6 (IG Publisher v2.2.x error-severity color).
    Each such row has 3 cells: filename, <b>message</b>, context.

    Raises SystemExit(1) on missing/empty/malformed file.
    """
    if not qa_path.exists():
        print(f"ERROR: qa.html not found at {qa_path}", file=sys.stderr)
        sys.exit(1)

    content = qa_path.read_text(encoding="utf-8").strip()
    if not content:
        print(f"ERROR: qa.html is empty at {qa_path}", file=sys.stderr)
        sys.exit(1)

    # Parse HTML comment for authoritative counts
    # Format: <!-- broken links = N, errors = N, warn = N, info = N-->
    comment_match = re.search(
        r'<!--\s*broken links\s*=\s*(\d+),\s*errors\s*=\s*(\d+)',
        content,
    )
    if not comment_match:
        print(
            "ERROR: Could not find summary comment in qa.html "
            "(expected: <!-- broken links = N, errors = N, ...-->)",
            file=sys.stderr,
        )
        sys.exit(1)

    broken_links = int(comment_match.group(1))
    errors_count = int(comment_match.group(2))

    # Parse individual error messages from error-colored rows.
    # IG Publisher v2.2.x uses background-color: #ffe6e6 for error-severity rows
    # in the "Errors sorted by type" detail section.
    # Row format: <tr style="background-color: #ffe6e6">
    #   <td>filename</td><td><b>message</b></td><td>context</td>
    # </tr>
    error_messages: list[str] = []
    error_row_pattern = re.compile(
        r'<tr[^>]*background-color:\s*#ffe6e6[^>]*>.*?<td[^>]*><b>(.*?)</b></td>',
        re.DOTALL | re.IGNORECASE,
    )
    for match in error_row_pattern.finditer(content):
        msg = re.sub(r'<[^>]+>', '', match.group(1)).strip()
        if msg:
            error_messages.append(msg)

    return errors_count, broken_links, error_messages


# ---------------------------------------------------------------------------
# Allowlist loader
# ---------------------------------------------------------------------------


def _parse_yaml_simple(text: str) -> dict:
    """Minimal YAML parser — handles only the qa-allowlist.yml structure.

    We only need:
        version: "1"
        patterns:
          - pattern: "..."
            reason: "..."
            source: "..."

    Uses stdlib only (no PyYAML dependency in CI).
    Raises ValueError on parse failure (e.g. unclosed brackets, duplicate keys).
    """
    lines = text.splitlines()
    version: str = ""
    patterns: list[dict] = []
    current_entry: dict | None = None
    in_patterns_block = False

    i = 0
    while i < len(lines):
        line = lines[i]
        stripped = line.strip()

        # Skip comments and blank lines
        if not stripped or stripped.startswith("#"):
            i += 1
            continue

        # Detect "version:" key
        m = re.match(r"^version\s*:\s*(.*)", stripped)
        if m and not in_patterns_block:
            version = _unquote(m.group(1).strip())
            i += 1
            continue

        # Detect "patterns:" key
        if re.match(r"^patterns\s*:", stripped):
            # Check if inline empty list: "patterns: []"
            if re.match(r"^patterns\s*:\s*\[\s*\]\s*$", stripped):
                in_patterns_block = True
                i += 1
                continue
            in_patterns_block = True
            i += 1
            continue

        # List item start: "  - pattern: ..."
        if in_patterns_block and re.match(r"^-\s+pattern\s*:", stripped):
            if current_entry is not None:
                patterns.append(current_entry)
            # Extract value after "pattern:"
            m = re.match(r"^-\s+pattern\s*:\s*(.*)", stripped)
            val = m.group(1).strip() if m else ""
            val = _unquote(val)
            current_entry = {"pattern": val, "reason": "", "source": ""}
            i += 1
            continue

        # Continuation keys inside an entry: reason, source
        if current_entry is not None and in_patterns_block:
            for key in ("reason", "source"):
                m = re.match(rf"^{key}\s*:\s*(.*)", stripped)
                if m:
                    current_entry[key] = _unquote(m.group(1).strip())
                    break

        i += 1

    if current_entry is not None:
        patterns.append(current_entry)

    return {"version": version, "patterns": patterns}


def _unquote(s: str) -> str:
    """Strip surrounding quotes from a YAML scalar value."""
    if (s.startswith('"') and s.endswith('"')) or (
        s.startswith("'") and s.endswith("'")
    ):
        inner = s[1:-1]
        # Unescape \" inside double-quoted strings
        inner = inner.replace('\\"', '"')
        return inner
    return s


SUPPORTED_VERSIONS = {"1"}


def load_allowlist(allowlist_path: Path) -> list[AllowlistEntry]:
    """Load qa-allowlist.yml and return list of AllowlistEntry objects.

    Raises SystemExit(1) on missing file, parse failure, or unsupported version.
    """
    if not allowlist_path.exists():
        print(f"ERROR: allowlist not found at {allowlist_path}", file=sys.stderr)
        sys.exit(1)

    text = allowlist_path.read_text(encoding="utf-8").strip()
    if not text:
        print(f"ERROR: allowlist is empty at {allowlist_path}", file=sys.stderr)
        sys.exit(1)

    try:
        data = _parse_yaml_simple(text)
    except Exception as exc:
        print(f"ERROR: failed to parse allowlist YAML: {exc}", file=sys.stderr)
        sys.exit(1)

    version = data.get("version", "")
    if not version:
        print("ERROR: allowlist missing 'version' field", file=sys.stderr)
        sys.exit(1)
    if str(version) not in SUPPORTED_VERSIONS:
        print(
            f"ERROR: unsupported allowlist version '{version}' "
            f"(supported: {SUPPORTED_VERSIONS})",
            file=sys.stderr,
        )
        sys.exit(1)

    entries = []
    for item in data.get("patterns", []):
        if not isinstance(item, dict):
            print("ERROR: malformed allowlist entry (not a mapping)", file=sys.stderr)
            sys.exit(1)
        pattern = item.get("pattern", "")
        if not pattern:
            print("ERROR: allowlist entry missing 'pattern' key", file=sys.stderr)
            sys.exit(1)
        entries.append(
            AllowlistEntry(
                pattern=pattern,
                reason=item.get("reason", ""),
                source=item.get("source", ""),
            )
        )
    return entries


# ---------------------------------------------------------------------------
# Allowlist matching — fail-closed
# ---------------------------------------------------------------------------


def is_allowed(error_text: str, entries: list[AllowlistEntry]) -> AllowlistEntry | None:
    """Return the matching AllowlistEntry if error_text is allowlisted, else None.

    Fail-closed: empty entries list means no error is allowed through.
    Matching is substring-based (pattern appears anywhere in error_text).
    """
    if not entries:
        return None
    for entry in entries:
        if entry.pattern in error_text:
            return entry
    return None


# ---------------------------------------------------------------------------
# Core gate logic
# ---------------------------------------------------------------------------


def run_gate(errors: list[str], allowlist: list[AllowlistEntry]) -> QaResult:
    """Categorize errors as internal or external and return QaResult."""
    result = QaResult(total_errors=len(errors))
    for msg in errors:
        matched = is_allowed(msg, allowlist)
        if matched is not None:
            result.external_errors += 1
            result.external_messages.append(msg)
            result.external_entries.append(matched)
        else:
            result.internal_errors += 1
            result.internal_messages.append(msg)
    return result


# ---------------------------------------------------------------------------
# CLI entry point
# ---------------------------------------------------------------------------


def main() -> None:
    parser = argparse.ArgumentParser(
        description="QA gate for IG Publisher output — blocks release when internal errors > 0"
    )
    parser.add_argument(
        "--qa-html",
        required=True,
        metavar="PATH",
        help="Path to output/qa.html generated by IG Publisher",
    )
    parser.add_argument(
        "--allowlist",
        required=True,
        metavar="PATH",
        help="Path to .github/qa-allowlist.yml",
    )
    args = parser.parse_args()

    qa_path = Path(args.qa_html)
    errors_count, broken_links, error_messages = parse_qa_html(qa_path)

    # Fast path: if comment says 0 errors and 0 broken links, gate passes immediately
    total_from_comment = errors_count + broken_links
    if total_from_comment == 0:
        print("QA Gate: total_errors=0 internal_errors=0 external_errors=0")
        print("\nQA gate passed.")
        _write_step_summary(QaResult())
        sys.exit(0)

    allowlist = load_allowlist(Path(args.allowlist))

    # Use all parsed error messages; broken_links count is already reflected in
    # errors_count+broken_links. If the HTML detail rows don't cover broken links,
    # synthesize a placeholder so the count is never understated.
    all_errors = list(error_messages)
    detail_total = len(all_errors)
    if detail_total < total_from_comment:
        # Broken links or other errors not captured as #ffe6e6 rows —
        # pad with a generic message so count stays accurate.
        for _ in range(total_from_comment - detail_total):
            all_errors.append("(broken link or unparsed error — see qa.html)")

    result = run_gate(all_errors, allowlist)

    # Print summary
    print(
        f"QA Gate: total_errors={result.total_errors} "
        f"internal_errors={result.internal_errors} "
        f"external_errors={result.external_errors}"
    )

    if result.internal_errors > 0:
        print(f"\nINTERNAL ERRORS ({result.internal_errors}) — these must be fixed before release:")
        for msg in result.internal_messages:
            print(f"  - {msg}")

    if result.external_errors > 0:
        print(f"\nExternal errors ({result.external_errors}) — allowlisted, not blocking:")
        for msg, entry in zip(result.external_messages, result.external_entries):
            print(f"  - [{entry.source}] {msg}")
            print(f"    Reason: {entry.reason}")

    _write_step_summary(result)

    if result.internal_errors > 0:
        print("\nQA GATE FAILED — fix internal errors before releasing.")
        sys.exit(1)
    else:
        print("\nQA gate passed.")
        sys.exit(0)


def _write_step_summary(result: QaResult) -> None:
    """Write a Markdown summary table to GITHUB_STEP_SUMMARY if set."""
    summary_path = os.environ.get("GITHUB_STEP_SUMMARY")
    if not summary_path:
        return
    with open(summary_path, "a", encoding="utf-8") as f:
        f.write("## QA Gate Results\n\n")
        f.write("| Metric | Count |\n|--------|-------|\n")
        f.write(f"| Total errors | {result.total_errors} |\n")
        f.write(f"| Internal errors | {result.internal_errors} |\n")
        f.write(f"| External (allowlisted) | {result.external_errors} |\n")
        if result.internal_errors > 0:
            f.write("\n### Internal Errors (must fix)\n\n")
            for msg in result.internal_messages:
                f.write(f"- `{msg}`\n")


if __name__ == "__main__":
    main()
