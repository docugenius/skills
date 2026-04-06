---
name: docugenius
description: Use when working with the DocuGenius publishing API to create template documents, define or update DataSource fields, manage templates through editor URLs, and generate preview or exported documents from DataValue payloads. Load the bundled API, DataSource, and DataValue references before making requests, then use the helper script with DOCUGENIUS_BASE_URL and DOCUGENIUS_APP_TOKEN.
---

# DocuGenius Publish Skill

Use this skill when the user wants to publish through DocuGenius, manage template documents, or generate temporary editor/preview/export URLs.

## What to load

Read [references/api.md](references/api.md) before making API calls.

Read [references/data-source.md](references/data-source.md) when defining fields available to template authors.

Read [references/data-value.md](references/data-value.md) when building preview or export payloads.

Use [scripts/docugenius_publish.sh](scripts/docugenius_publish.sh) for business-oriented commands.

Use [scripts/docugenius_api.sh](scripts/docugenius_api.sh) only when the higher-level publish wrapper does not already match the task.

## Required environment

Set these environment variables before running the script:

```bash
export DOCUGENIUS_BASE_URL="https://open.docugenius.site"
export DOCUGENIUS_APP_TOKEN="your-app-token"
```

## Publish workflow

1. Create a template document.
2. Define the document DataSource before the document is used. DataSource defines the fields available in the template schema and editor.
3. Update the DataSource through `update-doc` or `create-editor-url`. Both can carry `dataSource`.
4. Generate an editor URL and manage the template contents there. The template uses fields defined in `dataSource`.
5. Once templates are ready, generate either:
   - a preview URL with `DataValue`
   - an export job with `DataValue`
6. Inspect the returned IDs, URLs, or job tokens and report them clearly.

## Default workflow

1. Read the relevant endpoint definition from [references/api.md](references/api.md).
2. Read [references/data-source.md](references/data-source.md) when the task is about available fields or schema design.
3. Read [references/data-value.md](references/data-value.md) when the task is about preview or document generation data.
4. Confirm `DOCUGENIUS_BASE_URL` and `DOCUGENIUS_APP_TOKEN` are set.
5. Build the JSON body in a local file when it is more than a few fields.
6. Prefer [scripts/docugenius_publish.sh](scripts/docugenius_publish.sh) for common publishing actions.
7. Fall back to [scripts/docugenius_api.sh](scripts/docugenius_api.sh) for direct endpoint access.
8. Inspect the JSON response and surface the returned IDs or URLs clearly.

## Common publish commands

### Create a template doc

```bash
./docugenius/scripts/docugenius_publish.sh template-create "Sprint"
```

### Update a template doc

```bash
./docugenius/scripts/docugenius_publish.sh template-update DOC_ID @body.json
```

### Load doc detail

```bash
./docugenius/scripts/docugenius_publish.sh template-get DOC_ID
```

### Generate editor URL

```bash
./docugenius/scripts/docugenius_publish.sh editor-url DOC_ID @editor-body.json
```

### Generate preview URL

```bash
./docugenius/scripts/docugenius_publish.sh preview-url DOC_ID @preview-body.json
```

### Generate a doc export job

```bash
./docugenius/scripts/docugenius_publish.sh doc-generate DOC_ID @export-body.json
```

### Poll generated doc status

```bash
./docugenius/scripts/docugenius_publish.sh doc-job DOC_ID JOB_TOKEN
```

### Load enabled templates

```bash
./docugenius/scripts/docugenius_publish.sh templates DOC_ID
./docugenius/scripts/docugenius_publish.sh template-detail DOC_ID TEMPLATE_ID
```

## Direct API operations

### Create a template doc

```bash
./docugenius/scripts/docugenius_api.sh create-doc '{"name":"Sprint"}'
```

### Update a template doc

```bash
./docugenius/scripts/docugenius_api.sh update-doc DOC_ID @body.json
```

### Get doc detail

```bash
./docugenius/scripts/docugenius_api.sh get-doc DOC_ID
```

### Generate editor URL

```bash
./docugenius/scripts/docugenius_api.sh create-editor-url DOC_ID @editor-body.json
```

### Generate preview URL

```bash
./docugenius/scripts/docugenius_api.sh create-preview-url DOC_ID @preview-body.json
```

### Create an export job

```bash
./docugenius/scripts/docugenius_api.sh create-export-job DOC_ID @export-body.json
```

### Poll export job status

```bash
./docugenius/scripts/docugenius_api.sh get-export-job DOC_ID JOB_TOKEN
```

### List enabled templates

```bash
./docugenius/scripts/docugenius_api.sh list-enabled-templates DOC_ID
./docugenius/scripts/docugenius_api.sh get-enabled-template DOC_ID TEMPLATE_ID
```

## Body conventions

- `create-doc` creates the template document container and expects `{"name":"..."}`
- `update-doc` is a valid place to define or update `dataSource`
- `create-editor-url` can also update `dataSource` and is the entry point for template editing
- `create-preview-url` expects `data` in `DataValue` form
- `create-export-job` expects `data` in `DataValue` form plus `templateId`

## Safety notes

- Never print the raw app token in the response.
- Prefer storing large request bodies in `*.json` files and pass them as `@file.json`.
- When the user asks to "generate a doc", decide whether they need:
  - a preview link: `preview-url`
  - an exported file job: `doc-generate`
  - a batch exported file job: direct API `create-batch-export-job`
- If the task is about available schema fields, use [references/data-source.md](references/data-source.md).
- If the task is about render input payloads, use [references/data-value.md](references/data-value.md).
- If a workflow depends on template IDs or dependency fields, fetch enabled templates first and shape the input data from the returned `deps.fields`.
