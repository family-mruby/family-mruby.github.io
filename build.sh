#!/bin/bash
set -e

# Sync external HTML asset (console web client) from fmruby-core (single source of truth)
bash scripts/sync-console.sh

# Docker
docker build -t mkdocs-builder ./docker

# MkDocs
docker run --rm -v $(pwd):/docs mkdocs-builder mkdocs build

echo "Build completed! Site generated in ./site directory"

echo "Run preview server:"
echo "docker run --rm -v $(pwd):/docs -p 8000:8000 mkdocs-builder mkdocs serve --dev-addr=0.0.0.0:8000"
echo "Access http://localhost:8000/"
