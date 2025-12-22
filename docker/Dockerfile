FROM python:3.11-slim

WORKDIR /docs

RUN pip install --no-cache-dir \
    mkdocs \
    mkdocs-material \
    mkdocs-static-i18n

CMD ["mkdocs", "build"]
