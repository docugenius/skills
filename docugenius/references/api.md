# DocuGenius API Reference

Source: exported from the DocuGenius Feishu wiki on 2026-04-06.

## Auth

Use the app token in the HTTP header:

```http
Authorization: Bearer <AppToken>
```

Base URLs:

- Production: `https://open.docugenius.site`

## Endpoints

## Workflow

1. Create a template document with `POST /api/docs`.
2. Add or update `dataSource` before using the document as a template.
3. Manage the template through `POST /api/docs/:docId/create-editor-url`.
4. After templates are ready, pass `DataValue` payloads to preview or export APIs.

`dataSource` defines the fields available in the editor schema.

`DataValue` defines the actual runtime values used to preview or export documents.

### Create template doc

- `POST /api/docs`
- Body:

```json
{
  "name": "Sprint"
}
```

### Update template doc

- `PUT /api/docs/:docId`
- Use this to update the document name and define or update `dataSource`
- Body:

```json
{
  "name": "Sprint",
  "dataSource": {
    "groups": []
  }
}
```

### Get doc detail

- `GET /api/docs/:docId`
- Returns doc info, templates, and `extId`

### Delete doc

- `DELETE /api/docs/:docId`

### Generate editor URL

- `POST /api/docs/:docId/create-editor-url`
- Use this to enter template management and optionally update `dataSource` at the same time
- Body:

```json
{
  "lang": "zh-CN",
  "name": "",
  "dataSource": {
    "groups": []
  },
  "meta": {
    "templateGeneratorId": "your-id"
  }
}
```

### Generate preview URL

- `POST /api/docs/:docId/create-preview-url`
- Use this after templates are ready
- `data` must follow `DataValue`. See [data-value.md](data-value.md).
- Body:

```json
{
  "lang": "zh-CN",
  "templateId": "xxxxxxx",
  "config": {
    "hideTemplateSelector": true
  },
  "data": {
    "type": "map",
    "fields": {}
  }
}
```

### Create export job

- `POST /api/docs/:docId/export-jobs`
- Use this after templates are ready
- `data` must follow `DataValue`. See [data-value.md](data-value.md).
- Body fields:
  - `templateId`
  - `data`
  - optional `env`
  - optional `fileName`
  - optional `exportType`: `default` | `pdf` | `image`
  - optional `callbackUrl`

### Get export job

- `GET /api/docs/:docId/export-jobs/:jobToken`
- `jobStatus`: `0` pending, `3` done, `4` failed

### Create batch export job

- `POST /api/docs/:docId/batch-export-jobs`
- Body fields:
  - `templateId`
  - `jobs[]`
  - optional `callbackUrl`

### Get batch export job

- `GET /api/docs/:docId/batch-export-jobs/:jobToken`

### List enabled templates

- `GET /api/docs/:docId/enabled-templates`

### Get enabled template detail

- `GET /api/docs/:docId/enabled-templates/:templateId`

## Related references

- DataSource schema: [data-source.md](data-source.md)
- DataValue payloads: [data-value.md](data-value.md)

## Other structures

### Template

- `id`
- `name`
- `type`: `0` online template, `1` docx, `2` xlsx

### Export Job

- `status`
- `message`
- `jobToken`
- `result.url`
- `result.fileName`
- `result.fileType`
