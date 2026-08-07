#!/usr/bin/env bash
set -euo pipefail

# Source ref of fmruby-core (override with FMRUBY_CORE_REF env var if needed)
SRC_REF="${FMRUBY_CORE_REF:-main}"
SRC_BASE="https://raw.githubusercontent.com/family-mruby/fmruby-core/${SRC_REF}/tool/web"
DEST_DIR="docs/console"

mkdir -p "$DEST_DIR"

# Fetch index.html and inject favicon <link> right after <head> opening tag.
# The favicon file (docs/assets/favicon.ico) is shared with the MkDocs theme.
curl -fsSL "${SRC_BASE}/index.html" \
  | sed '/<head>/a\
<link rel="icon" type="image/x-icon" href="../assets/favicon.ico">' \
  > "${DEST_DIR}/index.html"

echo "Synced ${SRC_BASE}/index.html -> ${DEST_DIR}/index.html"

# Derive the asset list from index.html itself, so a newly added script or
# stylesheet upstream cannot silently go missing here (that failure mode is
# invisible until a button stops working in the browser).
# Only same-directory relative paths are ours to fetch; absolute URLs,
# anchors and the injected favicon (../assets/) belong to the site.
mapfile -t ASSETS < <(
  grep -oE '(src|href)="[^"]+"' "${DEST_DIR}/index.html" \
    | sed -E 's/^(src|href)="//; s/"$//' \
    | grep -vE '^([a-zA-Z]+:|//|#|/|\.\./)' \
    | sort -u
)

if [ "${#ASSETS[@]}" -eq 0 ]; then
  echo "No assets found in ${DEST_DIR}/index.html - refusing to publish a broken console." >&2
  exit 1
fi

# Fetch each asset, creating sub-directories as needed.
for rel in "${ASSETS[@]}"; do
  dest="${DEST_DIR}/${rel}"
  mkdir -p "$(dirname "$dest")"
  curl -fsSL "${SRC_BASE}/${rel}" -o "$dest"
  echo "Synced ${SRC_BASE}/${rel} -> ${dest}"
done
