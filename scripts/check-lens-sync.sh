#!/usr/bin/env bash
# Fails if a lens directory exists on disk (has a SKILL.md) but isn't listed
# in CLAUDE.md's "## Available lenses" line. Run manually with:
#   ./scripts/check-lens-sync.sh
# Wired as a pre-commit hook via hooks/pre-commit.

set -euo pipefail
cd "$(dirname "$0")/.."

CLAUDE_MD="CLAUDE.md"

on_disk=$(find . -maxdepth 2 -name "SKILL.md" -not -path "./.git/*" \
  | sed -E 's#^\./([^/]+)/SKILL\.md$#\1#' | sort -u)

documented_line=$(awk '/^## Available lenses/{getline; getline; print; exit}' "$CLAUDE_MD")

missing=()
for lens in $on_disk; do
  if ! grep -q "/${lens}\b" <<< "$documented_line"; then
    missing+=("$lens")
  fi
done

if [ ${#missing[@]} -gt 0 ]; then
  echo "check-lens-sync: these lens directories exist but aren't in CLAUDE.md's Available lenses line:" >&2
  for m in "${missing[@]}"; do echo "  - /$m" >&2; done
  echo "Add them to CLAUDE.md (Available lenses line + Skill routing) before committing." >&2
  exit 1
fi

echo "check-lens-sync: all $(wc -w <<< "$on_disk" | tr -d ' ') lens directories are documented in CLAUDE.md."
