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
import re
import sys
from dataclasses import dataclass, field
from html.parser import HTMLParser
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


# ---------------------------------------------------------------------------
# HTML parser — extracts error messages from IG Publisher qa.html
# ---------------------------------------------------------------------------


class QaHtmlParser(HTMLParser):
    """Parse IG Publisher qa.html and extract rows where severity is 'Error'.

    The IG Publisher generates Bootstrap tables where each row contains:
        <td ...>Error</td><td>message text</td>
    We collect message text from cells that follow an 'Error' severity cell.
    """

    def __init__(self) -> None:
        super().__init__()
        self._in_td = False
        self._current_cell_text = ""
        self._row_cells: list[str] = []
        self._in_tr = False
        self.errors: list[str] = []

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        if tag == "tr":
            self._in_tr = True
            self._row_cells = []
        elif tag == "td" and self._in_tr:
            self._in_td = True
            self._current_cell_text = ""

    def handle_endtag(self, tag: str) -> None:
        if tag == "td" and self._in_td:
            self._in_td = False
            self._row_cells.append(self._current_cell_text.strip())
        elif tag == "tr" and self._in_tr:
            self._in_tr = False
            self._process_row(self._row_cells)
            self._row_cells = []

    def handle_data(self, data: str) -> None:
        if self._in_td:
            self._current_cell_text += data

    def _process_row(self, cells: list[str]) -> None:
        """Process a completed table row; collect message if severity is 'Error'."""
        if len(cells) < 2:
            return
        severity = cells[0].strip()
        # Match "Error" exactly (case-insensitive for robustness)
        if severity.lower() == "error":
            message = cells[1].strip()
            if message:
                self.errors.append(message)


def parse_qa_html(qa_path: Path) -> list[str]:
    """Parse qa.html and return list of error message strings.

    Raises SystemExit(1) on missing or empty file.
    """
    if not qa_path.exists():
        print(f"ERROR: qa.html not found at {qa_path}", file=sys.stderr)
        sys.exit(1)

    content = qa_path.read_text(encoding="utf-8").strip()
    if not content:
        print(f"ERROR: qa.html is empty at {qa_path}", file=sys.stderr)
        sys.exit(1)

    parser = QaHtmlParser()
    parser.feed(content)
    return parser.errors


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
    # Quick structural sanity check: reject unclosed brackets/braces
    # YAML flow sequences like "patterns: [unclosed" are invalid
    opened = 0
    for ch in text:
        if ch in ("[", "{"):
            opened += 1
        elif ch in ("]", "}"):
            opened -= 1
        if opened < 0:
            raise ValueError("Unbalanced brackets/braces in YAML")
    if opened != 0:
        raise ValueError("Unclosed brackets/braces in YAML")

    lines = text.splitlines()
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

    return {"patterns": patterns}


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


def load_allowlist(allowlist_path: Path) -> list[AllowlistEntry]:
    """Load qa-allowlist.yml and return list of AllowlistEntry objects.

    Raises SystemExit(1) on missing file or parse failure.
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
        required=False,
        metavar="PATH",
        help="Path to .github/qa-allowlist.yml (fail-closed if omitted and errors exist)",
    )
    args = parser.parse_args()

    qa_path = Path(args.qa_html)
    errors = parse_qa_html(qa_path)

    # Load allowlist — fail-closed if not provided
    if args.allowlist:
        allowlist = load_allowlist(Path(args.allowlist))
    else:
        # No allowlist provided: all errors count as internal
        allowlist = []

    result = run_gate(errors, allowlist)

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
        for msg in result.external_messages:
            print(f"  - {msg}")

    if result.internal_errors > 0:
        print("\nQA GATE FAILED — fix internal errors before releasing.")
        sys.exit(1)
    else:
        print("\nQA gate passed.")
        sys.exit(0)


if __name__ == "__main__":
    main()
