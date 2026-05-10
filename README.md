# family-mruby-docs

Documentation site for the Family mruby project.

Published at: <https://family-mruby.github.io/>

## Layout

- `docs/` — MkDocs Material content (English `.md` + Japanese `.ja.md` via `mkdocs-static-i18n`)
- `mkdocs.yml` — site configuration (theme, navigation, i18n)
- `.github/workflows/deploy.yml` — auto-deploy to GitHub Pages on push to `main`
- `docker/` — MkDocs builder Docker image used by `build.sh` / `serve.sh`
- `scripts/sync-console.sh` — pulls the Family mruby Console web client from `fmruby-core` (see below)

## Local preview

```bash
./serve.sh           # http://localhost:8000
```

`serve.sh` builds the local Docker image and runs `mkdocs serve` with live reload.

## Local build (one-shot)

```bash
./build.sh           # output: ./site
```

`build.sh` runs the console web-client sync (see below) before invoking `mkdocs build`, so the generated site is identical to what GitHub Pages serves.

## Deployment

Pushing to `main` triggers `.github/workflows/deploy.yml`, which:

1. Installs MkDocs + Material + i18n plugin
2. Runs `scripts/sync-console.sh`
3. Runs `mkdocs gh-deploy --force` (publishes to the `gh-pages` branch → GitHub Pages)

`workflow_dispatch` is enabled, so the latest `fmruby-core` content can be re-published manually from the Actions tab without a code change.

## Console (`/console/`)

`https://family-mruby.github.io/console/` hosts the Web Bluetooth client whose source of truth lives in [`family-mruby/fmruby-core`](https://github.com/family-mruby/fmruby-core) at `tool/web/index.html`.

To avoid divergence, the file is **not** committed to this repo. Instead, `scripts/sync-console.sh` fetches it at build time:

- Source: `https://raw.githubusercontent.com/family-mruby/fmruby-core/${FMRUBY_CORE_REF:-main}/tool/web/index.html`
- A `<link rel="icon">` pointing to `docs/assets/favicon.ico` is injected into `<head>` so the page picks up the same favicon as the docs theme.
- Output: `docs/console/index.html` (gitignored)

To pin to a specific fmruby-core ref instead of `main`:

```bash
FMRUBY_CORE_REF=0.1.0 bash scripts/sync-console.sh
```

(For permanent pinning, add `env: FMRUBY_CORE_REF: <tag>` to the sync step in `deploy.yml`.)

## Adding pages

1. Create `docs/<path>.md` (English) and optionally `docs/<path>.ja.md` (Japanese)
2. Register the entry under `nav:` in `mkdocs.yml`
3. Run `./serve.sh` to verify
4. Commit and push — GitHub Actions handles the rest
