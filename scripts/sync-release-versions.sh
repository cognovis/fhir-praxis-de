#!/usr/bin/env bash
# DEPRECATED (fmgt-5ff): This script managed release/publish/version-sync operations
# that are now owned by fhir-management. Use fhir-management commands instead:
#   uv run fhir-release publish
#   uv run fhir-release update-package-list
#   uv run fhir-graph lock
# See fhir-management docs/release-migration.md for the migration map.
# This script is kept for reference during the transition period.

# Step 0 (ADR-006): sync FHIR version pins to the current IG checkouts so the tree
# is ready to build + publish. This is the deliberate "step 0" pin-bump+commit,
# automated. Script 1 (release-fhir-packages.sh) stays commit-free and publishes
# exactly what this script commits.
#
# What it does:
#   1. Discover the current version of each FHIR IG repo (sushi-config.yaml).
#   2. Update the lock anchor (igs.<id>.version) to the discovered version.
#   3. Propagate that version to EVERY dependent pin (key-based, value-agnostic):
#      lock cross_pins + adapter_sets deps, consumer sushi-config deps, and
#      terminology package.json cross-pins.
#   4. Gate on scripts/check-fhir-version-drift.sh (the terminology drift guard).
#   5. (--commit) commit each changed repo, surgically (only version-pin files).
#
# Scope: the FHIR repos only (praxis, dental, deid, terminology). The downstream
# SDK/codegen cascade is owned by that repo's Script 2 — NOT here.
#
# Transition note: while the lock's canonical home (the hub) and the legacy
# fhir-terminology-de copy coexist (fpde-x8r), this script updates BOTH so the
# drift guard + terminology ETL stay consistent until the downstream cleanup
# cleanup bead repoints them to the hub.
#
# Usage:
#   scripts/sync-release-versions.sh [--dry-run] [--commit] [--push]
#     --dry-run  show planned pin changes, edit nothing
#     --commit   commit each changed repo after the drift guard passes
#     --push     push each committed repo (implies --commit)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HUB_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CODE_ROOT="$(dirname "$HUB_ROOT")"

DRY_RUN=false; DO_COMMIT=false; DO_PUSH=false
for a in "$@"; do
  case "$a" in
    --dry-run) DRY_RUN=true ;;
    --commit)  DO_COMMIT=true ;;
    --push)    DO_PUSH=true; DO_COMMIT=true ;;
    *) echo "Unknown arg: $a" >&2; exit 2 ;;
  esac
done

log() { echo "[sync-release-versions] $*"; }

# IG repos: id -> repo dir. Only repos present on disk are processed.
declare -A IG_REPO=(
  [de.cognovis.fhir.praxis]="$HUB_ROOT"
  [de.cognovis.fhir.dental]="$CODE_ROOT/fhir-dental-de"
  [io.cognovis.de-identification.de]="$CODE_ROOT/fhir-deidentification-de"
)

# Lock copies kept in sync during the transition window (hub canonical + legacy).
LOCKS=()
[ -f "$HUB_ROOT/fhir-versions.lock.yaml" ] && LOCKS+=("$HUB_ROOT/fhir-versions.lock.yaml")
[ -f "$CODE_ROOT/fhir-terminology-de/fhir-versions.lock.yaml" ] && LOCKS+=("$CODE_ROOT/fhir-terminology-de/fhir-versions.lock.yaml")

# Consumer sushi-configs that may pin an IG as a dependency.
CONSUMER_SUSHI=(
  "$CODE_ROOT/fhir-dental-de/sushi-config.yaml"
  "$CODE_ROOT/fhir-deidentification-de/sushi-config.yaml"
)
TERM_REPO="$CODE_ROOT/fhir-terminology-de"

# ── Step 1: discover current IG versions ──
log "=== Step 1: discover current IG versions ==="
declare -A IG_VERSION
for id in "${!IG_REPO[@]}"; do
  repo="${IG_REPO[$id]}"
  cfg="$repo/sushi-config.yaml"
  if [ ! -f "$cfg" ]; then
    log "skip $id — no sushi-config.yaml at $repo"
    continue
  fi
  ver="$(grep '^version:' "$cfg" | awk '{print $2}' | tr -d '[:space:]')"
  IG_VERSION[$id]="$ver"
  log "  $id = $ver  ($(basename "$repo"))"
done

# Key-based pin setter: set every pin of <id> to <ver> in a file, preserving
# formatting. Handles three shapes:
#   lock anchor:     igs.<id>.version: X      (only under igs:)
#   inline dep:      <id>: X
#   block dep:       <id>:\n    version: X    (sushi-config dependency form)
#   package.json:    "<id>": "X"
set_pin_in_file() {
  local file="$1" id="$2" ver="$3"
  [ -f "$file" ] || return 0
  ID="$id" VER="$ver" DRY="$DRY_RUN" FILE="$file" python3 - <<'PY'
import os, re, sys
path=os.environ["FILE"]; ident=os.environ["ID"]; ver=os.environ["VER"]; dry=os.environ["DRY"]=="true"
src=open(path).read(); lines=src.split("\n"); out=[]; changes=[]
i=0
in_igs=False
while i < len(lines):
    ln=lines[i]
    # track igs: section (column-0 top-level key)
    if re.match(r'^igs:\s*$', ln): in_igs=True
    elif re.match(r'^[A-Za-z_]', ln) and not ln.startswith('igs:'): in_igs=False
    OP=re.compile(r'^([\^~]|>=|<=|>|<)?(.*)$')
    def bump(cur):
        # preserve a leading range operator; only swap the version part
        mm=OP.match(cur); op=mm.group(1) or ''; return op+ver, (op+ver)!=cur
    # JSON form "<id>": "x"
    m=re.match(r'^(\s*")'+re.escape(ident)+r'("\s*:\s*")([^"]*)(".*)$', ln)
    if m:
        nv,ch=bump(m.group(3))
        if ch: changes.append((ln, f'{m.group(1)}{ident}{m.group(2)}{nv}{m.group(4)}'))
        out.append(f'{m.group(1)}{ident}{m.group(2)}{nv}{m.group(4)}'); i+=1; continue
    # inline yaml "<id>: x   # comment"
    m=re.match(r'^(\s*)'+re.escape(ident)+r'(:\s*)([^\s#]+)(\s*(#.*)?)$', ln)
    if m:
        nv,ch=bump(m.group(3))
        if ch: changes.append((ln, f'{m.group(1)}{ident}{m.group(2)}{nv}{m.group(4)}'))
        out.append(f'{m.group(1)}{ident}{m.group(2)}{nv}{m.group(4)}'); i+=1; continue
    # block form "<id>:" then indented "version: x"
    m=re.match(r'^(\s*)'+re.escape(ident)+r':\s*$', ln)
    if m and i+1 < len(lines):
        nxt=lines[i+1]
        mv=re.match(r'^(\s*version:\s*)([^\s#]+)(\s*(#.*)?)$', nxt)
        if mv:
            out.append(ln)
            nv,ch=bump(mv.group(2))
            if ch: changes.append((nxt, f'{mv.group(1)}{nv}{mv.group(3)}'))
            out.append(f'{mv.group(1)}{nv}{mv.group(3)}'); i+=2; continue
    out.append(ln); i+=1
if changes:
    for old,new in changes:
        print(f'    {os.path.basename(path)}: {old.strip()}  ->  {new.strip()}', file=sys.stderr)
    if not dry:
        open(path,"w").write("\n".join(out))
PY
}

# ── Steps 2+3: bump anchors + propagate to all dependents ──
log "=== Steps 2+3: update lock anchors + propagate dependents (key-based) ==="
for id in "${!IG_VERSION[@]}"; do
  ver="${IG_VERSION[$id]}"
  log "propagating $id -> $ver"
  for lock in "${LOCKS[@]}"; do set_pin_in_file "$lock" "$id" "$ver"; done
  for sushi in "${CONSUMER_SUSHI[@]}"; do set_pin_in_file "$sushi" "$id" "$ver"; done
  # terminology package.json cross-pins
  if [ -d "$TERM_REPO/packages" ]; then
    while IFS= read -r pj; do set_pin_in_file "$pj" "$id" "$ver"; done \
      < <(grep -rl "\"$id\"" "$TERM_REPO/packages"/*/package.json 2>/dev/null || true)
  fi
done

if [ "$DRY_RUN" = true ]; then
  log "DRY RUN — no files written. (changes listed above)"
  exit 0
fi

# ── Step 4: drift-guard gate ──
log "=== Step 4: drift-guard gate ==="
DRIFT="$TERM_REPO/scripts/check-fhir-version-drift.sh"
if [ -x "$DRIFT" ]; then
  if (cd "$TERM_REPO" && bash scripts/check-fhir-version-drift.sh); then
    log "drift guard: OK"
  else
    log "drift guard FAILED — fix before committing. Changes left in place for inspection." >&2
    exit 1
  fi
else
  log "WARNING: drift guard not found at $DRIFT; skipping gate" >&2
fi

# ── Step 5: commit (+push) each changed repo, surgically ──
if [ "$DO_COMMIT" = true ]; then
  log "=== Step 5: commit changed repos ==="
  commit_repo() {
    local repo="$1"; shift
    local files=("$@")
    ( cd "$repo"
      local staged=false
      for f in "${files[@]}"; do
        [ -f "$f" ] && ! git diff --quiet -- "$f" 2>/dev/null && { git add "$f"; staged=true; }
      done
      if [ "$staged" = true ]; then
        git commit -m "chore(release-sync): align FHIR pins to current IG versions" >/dev/null
        log "committed $(basename "$repo")"
        if [ "$DO_PUSH" = true ]; then
          git pull --no-rebase --quiet 2>/dev/null || true
          git push --quiet && log "pushed $(basename "$repo")" || log "push failed for $(basename "$repo") (push manually)"
        fi
      else
        log "$(basename "$repo"): nothing to commit"
      fi
    )
  }
  commit_repo "$HUB_ROOT" "fhir-versions.lock.yaml"
  commit_repo "$CODE_ROOT/fhir-dental-de" "sushi-config.yaml"
  commit_repo "$CODE_ROOT/fhir-deidentification-de" "sushi-config.yaml"
  # terminology: lock + any changed package.json under packages/
  ( cd "$TERM_REPO"
    git add fhir-versions.lock.yaml 2>/dev/null || true
    git add packages/*/package.json 2>/dev/null || true
    if ! git diff --cached --quiet 2>/dev/null; then
      git commit -m "chore(release-sync): align FHIR pins to current IG versions" >/dev/null
      log "committed fhir-terminology-de"
      [ "$DO_PUSH" = true ] && { git pull --no-rebase --quiet 2>/dev/null || true; git push --quiet && log "pushed fhir-terminology-de" || log "push failed for fhir-terminology-de"; }
    else
      log "fhir-terminology-de: nothing to commit"
    fi
  )
fi

log "=== done. Tree is pin-synced; run scripts/release-fhir-packages.sh to build+publish. ==="