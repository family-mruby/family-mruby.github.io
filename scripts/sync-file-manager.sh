#!/usr/bin/env bash
set -euo pipefail

# Source ref of fmruby-core (override with FMRUBY_CORE_REF env var if needed)
SRC_REF="${FMRUBY_CORE_REF:-main}"
SRC_URL="https://raw.githubusercontent.com/family-mruby/fmruby-core/${SRC_REF}/tool/web/index.html"
DEST="docs/file-manager/index.html"

mkdir -p "$(dirname "$DEST")"

# Fetch index.html and inject favicon <link> right after <head> opening tag.
# The favicon file (docs/assets/favicon.ico) is shared with the MkDocs theme.
curl -fsSL "$SRC_URL" \
  | sed '/<head>/a\
<link rel="icon" type="image/x-icon" href="../assets/favicon.ico">' \
  > "$DEST"

echo "Synced ${SRC_URL} -> ${DEST}"
