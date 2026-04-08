# DocuGenius DataValue Reference

Use this reference when building runtime payloads for preview or export APIs.

## What DataValue is for

`DataValue` is the actual data passed to:

- `POST /api/docs/:docId/create-preview-url`
- `POST /api/docs/:docId/export-jobs`
- `POST /api/docs/:docId/batch-export-jobs`

This is different from `dataSource`:

- `dataSource` defines which fields exist in the template schema
- `DataValue` provides the actual values used to render the document

## Usage rule

When the user does not know the expected payload shape:

1. Fetch enabled templates.
2. Fetch the selected template detail.
3. Read `deps.fields`.
4. Build `DataValue` to match those dependencies.

## DataValue types

DataValue is a union type that includes:

- **MapValue** — object / record
- **ListValue** — array / loop
- **StringValue** — plain string
- **NumberValue** — number with display text
- **DateTimeValue** — timestamp with display text
- **BoolValue** — boolean
- **AttachmentsValue** — file attachments

## Common shapes

The root is usually a map-style value:

```json
{
  "type": "map",
  "fields": {}
}
```

Supported render patterns mentioned in the API doc:

- `LIST` — single-level list
- `MAP` — single-level map
- `MAP -> LIST`
- `LIST -> MAP` — list where each item is a map

## Primitive examples

### StringValue

| Field   | Type       | Description |
| ------- | ---------- | ----------- |
| `type`  | `"string"` |             |
| `value` | string     |             |

```json
{
  "type": "string",
  "value": "Hello world"
}
```

### NumberValue

| Field         | Type       | Description    |
| ------------- | ---------- | -------------- |
| `type`        | `"number"` |                |
| `displayText` | string     | formatted text |
| `numberValue` | number     | raw value      |

```json
{
  "type": "number",
  "displayText": "123.00",
  "numberValue": 123
}
```

### DateTimeValue

| Field         | Type               | Description                                 |
| ------------- | ------------------ | ------------------------------------------- |
| `type`        | `"datetime"`       |                                             |
| `displayText` | string             | formatted text                              |
| `timestamp`   | number &#124; null | raw value in milliseconds, null means empty |

```json
{
  "type": "datetime",
  "displayText": "2026-04-06",
  "timestamp": 1775548800000
}
```

### BoolValue

| Field         | Type                | Description      |
| ------------- | ------------------- | ---------------- |
| `type`        | `"bool"`            |                  |
| `value`       | boolean &#124; null | null means empty |
| `displayText` | string (optional)   | display text     |

```json
{
  "type": "bool",
  "value": true,
  "displayText": "Yes"
}
```

## Composite examples

### MapValue

| Field         | Type                        | Description           |
| ------------- | --------------------------- | --------------------- |
| `type`        | `"map"`                     |                       |
| `displayText` | string (optional)           | for root node display |
| `fields`      | Record\<string, DataValue\> |                       |

```json
{
  "type": "map",
  "displayText": "",
  "fields": {
    "Name": {
      "type": "string",
      "value": "Hello world"
    }
  }
}
```

### ListValue

| Field         | Type              | Description                       |
| ------------- | ----------------- | --------------------------------- |
| `type`        | `"list"`          |                                   |
| `displayText` | string (optional) | for direct node rendering         |
| `items`       | MapValue\[\]      | list items, only Map is supported |

```json
{
  "type": "list",
  "items": [
    {
      "type": "map",
      "fields": {
        "Title": {
          "type": "string",
          "value": "Row 1"
        }
      }
    }
  ]
}
```

### AttachmentsValue

| Field         | Type            | Description |
| ------------- | --------------- | ----------- |
| `type`        | `"attachments"` | attachment  |
| `attachments` | Attachment\[\]  |             |

#### Attachment

| Field      | Type   | Required | Description       |
| ---------- | ------ | -------- | ----------------- |
| `url`      | string | yes      | file URL          |
| `mime`     | string | yes      | MIME type         |
| `fileName` | string | no       | file name         |
| `fileSize` | number | no       | file size (bytes) |

```json
{
  "type": "attachments",
  "attachments": [
    {
      "url": "https://example.com/file.pdf",
      "mime": "application/pdf",
      "fileName": "report.pdf",
      "fileSize": 102400
    }
  ]
}
```

## Example derived from template dependencies

If the enabled template exposes dependencies like:

```json
{
  "fields": [["Name"], ["Story1", "StoryName"], ["Story1", "StartAt"]]
}
```

Then a matching `DataValue` can look like:

```json
{
  "type": "map",
  "fields": {
    "Name": {
      "type": "string",
      "value": "Hello world"
    },
    "Story1": {
      "type": "map",
      "fields": {
        "StoryName": {
          "type": "string",
          "value": "Story A"
        },
        "StartAt": {
          "type": "string",
          "value": "2026-04-06T12:00:00Z"
        }
      }
    }
  }
}
```

## When to use this file

- Creating preview URL bodies
- Creating export job bodies
- Explaining how runtime data differs from template schema
