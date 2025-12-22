#!/bin/bash

# Dockerイメージのビルド
docker build -t mkdocs-builder ./docker

# MkDocsサーバーを起動
echo "Starting MkDocs server at http://localhost:8000"
echo "Press Ctrl+C to stop the server"
docker run --rm -v $(pwd):/docs -p 8000:8000 mkdocs-builder mkdocs serve --dev-addr=0.0.0.0:8000
