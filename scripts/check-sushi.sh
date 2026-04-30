#!/usr/bin/env bash
# scripts/check-sushi.sh
#
# Pre-push validation for FHIR IG repos: verify SUSHI build is clean before pushing.
#
# Why: this catches FSH errors locally before they break CI. Sushi-build is fast
# (~3s) so it's cheap to run on every relevant push. Drift between VERSION and
# sushi-config.yaml is also caught (CI verifies this too, but local feedback is faster).
#
# Skips when: no FSH/sushi/VERSION files changed in this push.
# Runs when:
#   - any file under input/fsh/ changed
#   - sushi-config.yaml, VERSION, or the IG vendor-leak guard changed
#   - any file under input/pagecontent/ changed (rendered into IG output)
#   - any file under test/Profile/ changed (profile validation fixtures)
#
# Exit 0: sushi clean (or skipped). Exit 1: sushi failed — push blocked.
# Bypass with: SKIP_SUSHI_CHECK=1 git push
#              or: git push --no-verify

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

# Identify range of commits about to be pushed.
# pre-push hook receives <local_ref> <local_sha> <remote_ref> <remote_sha> on stdin.
# When invoked manually (no stdin), default to checking last commit.
RANGE=""
if [ -t 0 ]; then
  # Run interactively — check last commit only.
  RANGE="HEAD~1..HEAD"
else
  while read -r local_ref local_sha remote_ref remote_sha; do
    if [ "$local_sha" = "0000000000000000000000000000000000000000" ]; then
      # Branch deletion — nothing to check.
      continue
    fi
    if [ "$remote_sha" = "0000000000000000000000000000000000000000" ]; then
      # New branch — check all reachable commits not yet on remote.
      RANGE="$(git rev-parse origin/main 2>/dev/null || echo HEAD~1)..$local_sha"
    else
      RANGE="$remote_sha..$local_sha"
    fi
    break
  done
fi

if [ -z "$RANGE" ]; then
  exit 0
fi

# Fast skip: any relevant files in the range?
CHANGED="$(git diff --name-only "$RANGE" 2>/dev/null || true)"

if [ -z "$CHANGED" ]; then
  exit 0
fi

NEEDS_CHECK=0
echo "$CHANGED" | grep -qE '^input/fsh/' && NEEDS_CHECK=1
echo "$CHANGED" | grep -qE '^input/pagecontent/' && NEEDS_CHECK=1
echo "$CHANGED" | grep -qE '^test/Profile/' && NEEDS_CHECK=1
echo "$CHANGED" | grep -qE '^(sushi-config\.yaml|VERSION)$' && NEEDS_CHECK=1
echo "$CHANGED" | grep -qE '^scripts/check-ig-vendor-leaks\.sh$' && NEEDS_CHECK=1

if [ "$NEEDS_CHECK" -eq 0 ]; then
  exit 0
fi

echo ""
echo "🔍 pre-push: changes touch FSH/sushi-config — verifying sushi build is clean..."
echo ""

"$REPO_ROOT/scripts/check-ig-vendor-leaks.sh"
echo ""

# Version sync check (cheap, do first)
if [ -f VERSION ] && [ -f sushi-config.yaml ]; then
  VFILE="$(tr -d '[:space:]' < VERSION)"
  VSUSHI="$(grep -E '^version:' sushi-config.yaml | head -1 | awk '{print $2}')"
  if [ -n "$VFILE" ] && [ -n "$VSUSHI" ] && [ "$VFILE" != "$VSUSHI" ]; then
    echo "❌ pre-push: VERSION ($VFILE) does not match sushi-config.yaml version ($VSUSHI)"
    echo "   These must always be in sync (CI enforces this too — fix locally first)."
    exit 1
  fi
fi

# Verify sushi is available
if ! command -v sushi >/dev/null 2>&1; then
  echo "⚠️  pre-push: sushi not in PATH — skipping build check (install with: npm i -g fsh-sushi)"
  exit 0
fi

# Run sushi and capture output. Tee to stderr only on failure.
SUSHI_LOG="$(mktemp)"
trap 'rm -f "$SUSHI_LOG"' EXIT

if sushi . >"$SUSHI_LOG" 2>&1; then
  # Check the result line ("X Errors  Y Warnings")
  ERRORS="$(grep -oE '[0-9]+ Errors' "$SUSHI_LOG" | head -1 | awk '{print $1}')"
  WARNINGS="$(grep -oE '[0-9]+ Warnings' "$SUSHI_LOG" | head -1 | awk '{print $1}')"
  if [ -n "${ERRORS:-}" ] && [ "$ERRORS" -gt 0 ]; then
    echo "❌ pre-push: sushi reported $ERRORS errors. Push blocked."
    grep -E "^error" "$SUSHI_LOG" | head -10
    echo ""
    echo "   To bypass (e.g. for an unrelated emergency push): git push --no-verify"
    exit 1
  fi
  echo "✅ pre-push: sushi clean (${ERRORS:-0} errors, ${WARNINGS:-0} warnings)"
  exit 0
else
  echo "❌ pre-push: sushi crashed unexpectedly. Push blocked."
  echo ""
  tail -30 "$SUSHI_LOG"
  echo ""
  echo "   To bypass (e.g. for an unrelated emergency push): git push --no-verify"
  exit 1
fi
