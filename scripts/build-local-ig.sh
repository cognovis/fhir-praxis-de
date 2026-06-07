#!/usr/bin/env bash
# Local developer wrapper for a full IG Publisher build.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if command -v brew >/dev/null 2>&1 && brew --prefix ruby >/dev/null 2>&1; then
  ruby_prefix="$(brew --prefix ruby)"
  gem_bindir="$("$ruby_prefix/bin/ruby" -rrubygems -e 'print Gem.bindir')"
  export PATH="$ruby_prefix/bin:$gem_bindir:$PATH"
fi

if ! command -v jekyll >/dev/null 2>&1; then
  cat >&2 <<'EOF'
ERROR: jekyll is not available on PATH.

Install the local build toolchain with:
  HOMEBREW_NO_AUTO_UPDATE=1 brew install ruby
  export PATH="$(brew --prefix ruby)/bin:$("$(brew --prefix ruby)/bin/ruby" -rrubygems -e 'print Gem.bindir'):$PATH"
  gem install jekyll

Then rerun:
  scripts/build-local-ig.sh
EOF
  exit 1
fi

"$ROOT/scripts/check-ig-pagecontent-no-adr-links.sh"
"$ROOT/scripts/preload-private-fhir-packages.sh"
"$ROOT/_genonce.sh" "$@"
