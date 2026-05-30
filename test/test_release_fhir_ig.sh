#!/usr/bin/env bash
# Tests for scripts/release-fhir-ig.sh (fpde-q6l)
#
# AC-2: QA-gate failure (internal errors > 0) aborts BEFORE any rsync.
# AC-3: --dry-run builds and QA-gates but performs no rsync.
# AC-4: The script contains no git commit, git tag, or git push calls.
# AC-5: Target-unreachable exits non-zero with a clear error message.
#
# These tests use mock infrastructure (fake output/, fake qa.html, fake
# build-local-ig.sh stub) so they can run without IG Publisher or a live
# deploy target.
#
# Usage:
#   bash test/test_release_fhir_ig.sh
#
# Exit: 0 on all pass, 1 on any failure.

set -uo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SCRIPT="${REPO_ROOT}/scripts/release-fhir-ig.sh"
PASS=0
FAIL=0

# ────────────────────────────────────────────────
# Helpers
# ────────────────────────────────────────────────

pass() {
  echo "  PASS: $1"
  (( PASS++ )) || true
}

fail() {
  echo "  FAIL: $1"
  (( FAIL++ )) || true
}

run_test() {
  local name="$1"
  echo ""
  echo ">>> $name"
}

make_passing_qa_html() {
  local dir="$1"
  cat > "$dir/qa.html" << 'HTML'
<!DOCTYPE html>
<html>
<head><title>QA Report</title></head>
<body>
<!-- broken links = 0, errors = 0, warn = 0, info = 0-->
<p>No errors.</p>
</body>
</html>
HTML
}

make_failing_qa_html() {
  local dir="$1"
  cat > "$dir/qa.html" << 'HTML'
<!DOCTYPE html>
<html>
<head><title>QA Report</title></head>
<body>
<!-- broken links = 0, errors = 1, warn = 0, info = 0-->
<table>
<tr style="background-color: #ffcccc">
  <td>test.json</td>
  <td><b>error</b></td>
  <td><b>Test internal error message</b></td>
  <td>context</td>
</tr>
</table>
</body>
</html>
HTML
}

make_package_json() {
  local dir="$1"
  local version="${2:-0.74.0}"
  cat > "$dir/package.json" << JSON
{
  "name": "de.cognovis.fhir.praxis",
  "version": "$version"
}
JSON
}

# ────────────────────────────────────────────────
# AC-4: Script source contains no git operations
# ────────────────────────────────────────────────
run_test "AC-4: no git commit, git tag, or git push in script source"
if grep -qE '(git commit|git tag|git push)' "$SCRIPT"; then
  fail "Script source contains forbidden git operation"
  grep -E '(git commit|git tag|git push)' "$SCRIPT" || true
else
  pass "No git commit/tag/push found in script source"
fi

# ────────────────────────────────────────────────
# AC-2: QA-gate failure aborts before rsync
# ────────────────────────────────────────────────
run_test "AC-2: QA-gate failure aborts before any rsync"

TMPDIR_AC2="$(mktemp -d)"
trap 'rm -rf "$TMPDIR_AC2"' EXIT

# Fake output/ with a failing qa.html
mkdir -p "$TMPDIR_AC2/output"
make_failing_qa_html "$TMPDIR_AC2/output"
make_package_json "$TMPDIR_AC2/output"

# Fake deploy root that EXISTS (so target-unreachable is not triggered first)
mkdir -p "$TMPDIR_AC2/html"

# Fake build script that just copies our pre-baked output/ into REPO_ROOT/output
BUILD_STUB="$TMPDIR_AC2/build-local-ig.sh"
cat > "$BUILD_STUB" << STUB
#!/usr/bin/env bash
cp -r "$TMPDIR_AC2/output" "\$(cd "\$(dirname "\$0")/.." && pwd)/output"
STUB
chmod +x "$BUILD_STUB"

# Track whether rsync was attempted
RSYNC_SENTINEL="$TMPDIR_AC2/rsync_was_called"

# Run the script with: fake build, fake deploy base, fake public URL
# We inject a fake rsync via PATH prepend to detect AC-2 violation.
FAKE_BIN="$TMPDIR_AC2/bin"
mkdir -p "$FAKE_BIN"
cat > "$FAKE_BIN/rsync" << FAKEBIN
#!/usr/bin/env bash
touch "$RSYNC_SENTINEL"
exit 0
FAKEBIN
chmod +x "$FAKE_BIN/rsync"

# Run script: swap out build-local-ig.sh reference by pointing REPO_ROOT at tmp
# Use a wrapper approach: patch BUILD_SCRIPT env via a symlink tree
TMP_REPO="$TMPDIR_AC2/repo"
mkdir -p "$TMP_REPO/scripts" "$TMP_REPO/.github"
cp "$SCRIPT" "$TMP_REPO/scripts/release-fhir-ig.sh"
cp "$REPO_ROOT/scripts/qa_gate.py" "$TMP_REPO/scripts/qa_gate.py"
cp "$REPO_ROOT/.github/qa-allowlist.yml" "$TMP_REPO/.github/qa-allowlist.yml"
# Build stub in place
cp "$BUILD_STUB" "$TMP_REPO/scripts/build-local-ig.sh"

FHIR_IG_DEPLOY_BASE="$TMPDIR_AC2/html" \
FHIR_IG_PUBLIC_BASE="http://localhost:0" \
PATH="$FAKE_BIN:$PATH" \
  bash "$TMP_REPO/scripts/release-fhir-ig.sh" --ig praxis 2>/dev/null
EXIT_CODE=$?

if [[ "$EXIT_CODE" -ne 0 ]]; then
  pass "Script exited non-zero ($EXIT_CODE) when QA gate fails"
else
  fail "Script should have exited non-zero but exited 0"
fi

if [[ ! -f "$RSYNC_SENTINEL" ]]; then
  pass "rsync was NOT called before QA-gate failure (AC-2 verified)"
else
  fail "rsync was called despite QA-gate failure (AC-2 VIOLATED)"
fi

# ────────────────────────────────────────────────
# AC-3: --dry-run performs no rsync
# ────────────────────────────────────────────────
run_test "AC-3: --dry-run produces no rsync calls"

TMPDIR_AC3="$(mktemp -d)"
trap 'rm -rf "$TMPDIR_AC3"' EXIT

mkdir -p "$TMPDIR_AC3/output" "$TMPDIR_AC3/html"
make_passing_qa_html "$TMPDIR_AC3/output"
make_package_json "$TMPDIR_AC3/output"

TMP_REPO3="$TMPDIR_AC3/repo"
mkdir -p "$TMP_REPO3/scripts" "$TMP_REPO3/.github"
cp "$SCRIPT" "$TMP_REPO3/scripts/release-fhir-ig.sh"
cp "$REPO_ROOT/scripts/qa_gate.py" "$TMP_REPO3/scripts/qa_gate.py"
cp "$REPO_ROOT/.github/qa-allowlist.yml" "$TMP_REPO3/.github/qa-allowlist.yml"

cat > "$TMP_REPO3/scripts/build-local-ig.sh" << STUB
#!/usr/bin/env bash
cp -r "$TMPDIR_AC3/output" "\$(cd "\$(dirname "\$0")/.." && pwd)/output"
STUB
chmod +x "$TMP_REPO3/scripts/build-local-ig.sh"

RSYNC_SENTINEL3="$TMPDIR_AC3/rsync_was_called"
FAKE_BIN3="$TMPDIR_AC3/bin"
mkdir -p "$FAKE_BIN3"
cat > "$FAKE_BIN3/rsync" << FAKEBIN
#!/usr/bin/env bash
touch "$RSYNC_SENTINEL3"
exit 0
FAKEBIN
chmod +x "$FAKE_BIN3/rsync"

FHIR_IG_DEPLOY_BASE="$TMPDIR_AC3/html" \
FHIR_IG_PUBLIC_BASE="http://localhost:0" \
PATH="$FAKE_BIN3:$PATH" \
  bash "$TMP_REPO3/scripts/release-fhir-ig.sh" --ig praxis --dry-run 2>/dev/null
EXIT_CODE=$?

if [[ "$EXIT_CODE" -eq 0 ]]; then
  pass "Script exited 0 with --dry-run and passing QA gate"
else
  fail "Script should exit 0 on --dry-run with passing gate, got $EXIT_CODE"
fi

if [[ ! -f "$RSYNC_SENTINEL3" ]]; then
  pass "rsync was NOT called during --dry-run (AC-3 verified)"
else
  fail "rsync was called during --dry-run (AC-3 VIOLATED)"
fi

# ────────────────────────────────────────────────
# AC-5: Unreachable deploy target exits non-zero with clear error
# ────────────────────────────────────────────────
run_test "AC-5: unreachable deploy target exits non-zero with clear error"

TMPDIR_AC5="$(mktemp -d)"
trap 'rm -rf "$TMPDIR_AC5"' EXIT

mkdir -p "$TMPDIR_AC5/output"
make_passing_qa_html "$TMPDIR_AC5/output"
make_package_json "$TMPDIR_AC5/output"

TMP_REPO5="$TMPDIR_AC5/repo"
mkdir -p "$TMP_REPO5/scripts" "$TMP_REPO5/.github"
cp "$SCRIPT" "$TMP_REPO5/scripts/release-fhir-ig.sh"
cp "$REPO_ROOT/scripts/qa_gate.py" "$TMP_REPO5/scripts/qa_gate.py"
cp "$REPO_ROOT/.github/qa-allowlist.yml" "$TMP_REPO5/.github/qa-allowlist.yml"

cat > "$TMP_REPO5/scripts/build-local-ig.sh" << STUB
#!/usr/bin/env bash
cp -r "$TMPDIR_AC5/output" "\$(cd "\$(dirname "\$0")/.." && pwd)/output"
STUB
chmod +x "$TMP_REPO5/scripts/build-local-ig.sh"

# Deploy to a nonexistent path (no /nonexistent-fhir-proxy on this machine)
set +e
ERR_OUTPUT=$(FHIR_IG_DEPLOY_BASE="/nonexistent-fhir-proxy/html" \
  FHIR_IG_PUBLIC_BASE="http://localhost:0" \
  bash "$TMP_REPO5/scripts/release-fhir-ig.sh" --ig praxis 2>&1)
EXIT_CODE=$?
set -e

if [[ "$EXIT_CODE" -ne 0 ]]; then
  pass "Script exited non-zero ($EXIT_CODE) when deploy target is unreachable"
else
  fail "Script should exit non-zero when deploy root missing, got 0"
fi

if echo "$ERR_OUTPUT" | grep -qi "error"; then
  pass "Clear error message emitted for unreachable target"
else
  fail "No error message found in output: $ERR_OUTPUT"
fi


# ────────────────────────────────────────────────
# AC-1 (IG guard): --ig mismatch vs sushi-config.yaml exits non-zero
# ────────────────────────────────────────────────
run_test "AC-1 (IG guard): --ig mismatch with sushi-config.yaml id"

set +e
IG_MISMATCH_OUTPUT=$(bash "$SCRIPT" --ig dental 2>&1)
IG_MISMATCH_EXIT=$?
set -e

if [[ "$IG_MISMATCH_EXIT" -ne 0 ]]; then
  pass "Script exits non-zero when --ig dental doesn't match repo IG id"
else
  fail "Script should fail when --ig doesn't match sushi-config.yaml id, got exit 0"
fi

if echo "$IG_MISMATCH_OUTPUT" | grep -qi "does not match"; then
  pass "Clear mismatch error message emitted"
else
  fail "No mismatch error message in: $IG_MISMATCH_OUTPUT"
fi

# ────────────────────────────────────────────────
# Summary
# ────────────────────────────────────────────────
echo ""
echo "═══════════════════════════════════════════"
echo "Results: $PASS passed, $FAIL failed"
echo "═══════════════════════════════════════════"

if [[ "$FAIL" -gt 0 ]]; then
  exit 1
fi
exit 0
