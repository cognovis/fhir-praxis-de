#!/usr/bin/env bash
# Preload private FHIR npm packages into the local FHIR package cache.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REGISTRY="${FHIR_PRIVATE_NPM_REGISTRY:-https://npm.cognovis.de}"
NPM_CONFIG_FILE=""

cleanup() {
  if [ -n "${NPM_CONFIG_FILE:-}" ] && [ -f "$NPM_CONFIG_FILE" ]; then
    rm -f "$NPM_CONFIG_FILE"
  fi
}
trap cleanup EXIT

make_npm_config() {
  local token="${VERDACCIO_TOKEN:-${BOX_FHIR_NPM_PACKAGE_REGISTRY_TOKEN:-${POLARIS_STACK_NPM_TOKEN:-${NPM_TOKEN:-}}}}"

  if [ -z "$token" ]; then
    return 0
  fi

  NPM_CONFIG_FILE="$(mktemp /tmp/fpde-npmrc.XXXXXX)"
  if [ -n "${VERDACCIO_TOKEN:-}" ]; then
    {
      printf "//npm.cognovis.de/:_auth=%s\n" "$(printf "cognovis:%s" "$VERDACCIO_TOKEN" | base64)"
      printf "//npm.cognovis.de/:always-auth=true\n"
    } > "$NPM_CONFIG_FILE"
  else
    {
      printf "//npm.cognovis.de/:_authToken=%s\n" "$token"
      printf "//npm.cognovis.de/:always-auth=true\n"
    } > "$NPM_CONFIG_FILE"
  fi
}

npm_args() {
  if [ -n "${NPM_CONFIG_FILE:-}" ]; then
    printf "%s\n" "--userconfig"
    printf "%s\n" "$NPM_CONFIG_FILE"
  fi
}

dependency_version() {
  local pkg="$1"

  awk -v pkg="$pkg" '
    /^dependencies:[[:space:]]*$/ { in_deps = 1; next }
    in_deps && /^[^[:space:]#][^:]*:/ { in_deps = 0 }
    in_deps {
      line = $0
      sub(/[[:space:]]*#.*/, "", line)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", line)
      prefix = pkg ":"
      if (index(line, prefix) == 1) {
        version = substr(line, length(prefix) + 1)
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", version)
        gsub(/"/, "", version)
        print version
        exit
      }
    }
  ' "$ROOT/sushi-config.yaml"
}

fetch_to_fhir_cache() {
  local pkg="$1"
  local version="$2"
  local cache_dir="${HOME}/.fhir/packages/${pkg}#${version}"

  if [ -d "$cache_dir/package" ] && [ -f "$cache_dir/package/package.json" ]; then
    echo "$pkg#$version already cached; skipping"
    return 0
  fi

  echo "Fetching $pkg@$version from $REGISTRY"
  local pack_dir
  pack_dir="$(mktemp -d)"
  local npm_extra=()
  while IFS= read -r arg; do
    npm_extra+=("$arg")
  done < <(npm_args)

  (
    cd "$pack_dir"
    npm pack "${pkg}@${version}" --registry "$REGISTRY" --silent "${npm_extra[@]}" >/dev/null
  )

  local tgz
  tgz="$(find "$pack_dir" -maxdepth 1 -name '*.tgz' | head -1)"
  if [ -z "$tgz" ]; then
    echo "ERROR: npm pack did not produce a tarball for $pkg@$version" >&2
    exit 1
  fi

  mkdir -p "$cache_dir"
  tar xzf "$tgz" -C "$cache_dir"
  echo "Installed $(find "$cache_dir/package" -maxdepth 1 -type f | wc -l | tr -d ' ') files into $cache_dir"
}

fetch_private_dependency() {
  local pkg="$1"
  local version

  version="$(dependency_version "$pkg")"
  if [ -z "$version" ]; then
    echo "ERROR: Could not find $pkg in sushi-config.yaml dependencies" >&2
    exit 1
  fi

  fetch_to_fhir_cache "$pkg" "$version"
}

previous_praxis_version() {
  local current
  current="$(tr -d '[:space:]' < "$ROOT/VERSION")"
  local npm_extra=()
  while IFS= read -r arg; do
    npm_extra+=("$arg")
  done < <(npm_args)

  npm view de.cognovis.fhir.praxis versions --registry "$REGISTRY" --json "${npm_extra[@]}" \
    | CURRENT_VERSION="$current" python3 -c '
import json
import os
import sys

current = tuple(int(part) for part in os.environ["CURRENT_VERSION"].split("."))
try:
    versions = json.load(sys.stdin)
except json.JSONDecodeError:
    versions = []
older = []
for version in versions:
    try:
        parsed = tuple(int(part) for part in version.split("."))
    except ValueError:
        continue
    if parsed < current:
        older.append((parsed, version))
older.sort()
print(older[-1][1] if older else "")
'
}

make_npm_config

private_fhir_packages=(
  "de.cognovis.terminology.imaging"
  "de.cognovis.terminology.kbv"
  "kbv.mio.impfpass.vocab"
)

for pkg in "${private_fhir_packages[@]}"; do
  fetch_private_dependency "$pkg"
done

prev_version="$(previous_praxis_version)"
if [ -n "$prev_version" ]; then
  fetch_to_fhir_cache "de.cognovis.fhir.praxis" "$prev_version"
else
  echo "No previous de.cognovis.fhir.praxis version found; skipping previous-version preload"
fi
