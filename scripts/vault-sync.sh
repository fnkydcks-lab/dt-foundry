#!/usr/bin/env bash
# Mirrors a lens's just-written output into the centralized dt-foundry vault
# (~/projects/dt-foundry/reports/<project>/<lens>/<date>.md), in addition to
# the project-local dt-foundry/ copy every lens already writes.
#
# Usage: vault-sync.sh <lens-name> <path-to-content-file> [date-stamp]
#   lens-name        e.g. standup, brief, dev
#   content-file      the just-written entry (not the whole accumulated file —
#                      pass a temp file containing only the new content)
#   date-stamp        optional, defaults to now as YYYY-MM-DD-HHMM
#
# Personal, optional infrastructure — this is not a core lens requirement.
# If the vault repo isn't present (e.g. a clone of dt-foundry on a machine
# that isn't this user's), skip silently. Never block the calling lens.

set -euo pipefail

VAULT_ROOT="$HOME/projects/dt-foundry"
LENS="${1:?lens name required}"
CONTENT_FILE="${2:?content file required}"
DATE_STAMP="${3:-$(date +%Y-%m-%d-%H%M)}"

if [ ! -d "$VAULT_ROOT/.git" ]; then
  exit 0
fi

if [ ! -f "$CONTENT_FILE" ]; then
  echo "vault-sync: content file not found: $CONTENT_FILE" >&2
  exit 0
fi

# "sprnova" is the catch-all bucket for lens output that isn't tied to any
# specific product: no git repo in the current context, or dogfooding the
# lens pack on itself (its own repo name is "dt-foundry", not a product).
PROJECT=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)" 2>/dev/null || echo "")
if [ -z "$PROJECT" ] || [ "$PROJECT" = "dt-foundry" ]; then
  PROJECT="sprnova"
fi

DEST_DIR="$VAULT_ROOT/reports/$PROJECT/$LENS"
mkdir -p "$DEST_DIR"
DEST_FILE="$DEST_DIR/$DATE_STAMP.md"
cp "$CONTENT_FILE" "$DEST_FILE"

cd "$VAULT_ROOT"
git add "reports/$PROJECT/$LENS/$DATE_STAMP.md"
git commit -q -m "Vault sync: $PROJECT/$LENS/$DATE_STAMP" 2>/dev/null || exit 0
git push -q 2>/dev/null || echo "vault-sync: committed locally, push failed (offline?)" >&2

echo "vault-sync: wrote reports/$PROJECT/$LENS/$DATE_STAMP.md"
