#!/usr/bin/env bash
set -euo pipefail

# Source ref of fmruby-core (override with FMRUBY_CORE_REF env var if needed)
SRC_REF="${FMRUBY_CORE_REF:-main}"
SRC_BASE="https://raw.githubusercontent.com/family-mruby/fmruby-core/${SRC_REF}/tool/web"
DEST_DIR="docs/console"

# Asset files referenced from index.html (relative paths under tool/web/).
ASSETS=(
  "css/app.css"
  "js/app.js"
  "js/bmp332.js"
  "js/sprite-editor.js"
  "js/map-editor.js"
  "vendor/prism.js"
)

mkdir -p "$DEST_DIR"

# Fetch index.html and inject favicon <link> right after <head> opening tag.
# The favicon file (docs/assets/favicon.ico) is shared with the MkDocs theme.
curl -fsSL "${SRC_BASE}/index.html" \
  | sed '/<head>/a\
<link rel="icon" type="image/x-icon" href="../assets/favicon.ico">' \
  > "${DEST_DIR}/index.html"

echo "Synced ${SRC_BASE}/index.html -> ${DEST_DIR}/index.html"

# Fetch each asset, creating sub-directories as needed.
for rel in "${ASSETS[@]}"; do
  dest="${DEST_DIR}/${rel}"
  mkdir -p "$(dirname "$dest")"
  curl -fsSL "${SRC_BASE}/${rel}" -o "$dest"
  echo "Synced ${SRC_BASE}/${rel} -> ${dest}"
done
