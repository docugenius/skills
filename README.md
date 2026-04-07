# DocuGenius Skills

This repository contains a `docugenius` agent skill for working with the DocuGenius publishing API.

It is designed for workflows such as:

- creating template documents
- defining or updating `dataSource`
- generating editor URLs for template management
- generating preview URLs
- exporting rendered documents

## Repository layout

```text
docugenius/
  SKILL.md
  references/
    api.md
    data-source.md
    data-value.md
  scripts/
    docugenius_api.sh
    docugenius_publish.sh

docs/
  DocuGenius API Documentation.md
```

## Core concept

The publishing workflow is:

1. Create a template document.
2. Define `dataSource` before the template is used.
3. Open an editor URL to manage templates based on the `dataSource` fields.
4. Use `DataValue` payloads to generate preview URLs or export documents.

`dataSource` defines the fields available to the template schema.

`DataValue` provides the runtime values used to render the document.

## Required environment

```bash
export DOCUGENIUS_BASE_URL="https://open.docugenius.site"
export DOCUGENIUS_APP_TOKEN="your-app-token"
```

Use the test environment when needed:

```bash
export DOCUGENIUS_BASE_URL="https://dg-open-dev.shicaizhaopin.net"
```

## Recommended entrypoint

Use the higher-level wrapper:

```bash
bash ./docugenius/scripts/docugenius_publish.sh <command> ...
```

Common commands:

```bash
bash ./docugenius/scripts/docugenius_publish.sh template-create "Sprint"
bash ./docugenius/scripts/docugenius_publish.sh template-update DOC_ID @body.json
bash ./docugenius/scripts/docugenius_publish.sh template-get DOC_ID
bash ./docugenius/scripts/docugenius_publish.sh editor-url DOC_ID @editor-body.json
bash ./docugenius/scripts/docugenius_publish.sh preview-url DOC_ID @preview-body.json
bash ./docugenius/scripts/docugenius_publish.sh doc-generate DOC_ID @export-body.json
bash ./docugenius/scripts/docugenius_publish.sh doc-job DOC_ID JOB_TOKEN
bash ./docugenius/scripts/docugenius_publish.sh templates DOC_ID
bash ./docugenius/scripts/docugenius_publish.sh template-detail DOC_ID TEMPLATE_ID
```

## Low-level API entrypoint

If needed, call the raw API wrapper directly:

```bash
bash ./docugenius/scripts/docugenius_api.sh create-doc '{"name":"Sprint"}'
```

## References

- [docugenius/SKILL.md](/Users/zhengbiao/workspace/docugenius-skills/docugenius/SKILL.md)
- [docugenius/references/api.md](/Users/zhengbiao/workspace/docugenius-skills/docugenius/references/api.md)
- [docugenius/references/data-source.md](/Users/zhengbiao/workspace/docugenius-skills/docugenius/references/data-source.md)
- [docugenius/references/data-value.md](/Users/zhengbiao/workspace/docugenius-skills/docugenius/references/data-value.md)

## Notes

- Prefer storing larger request bodies in JSON files and passing them as `@file.json`.
- Fetch enabled template details first when you need to derive a valid `DataValue` shape from `deps.fields`.
- Do not print or commit the app token.
