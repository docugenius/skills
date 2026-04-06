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

## Common shapes

The root is usually a map-style value:

```json
{
  "type": "map",
  "fields": {}
}
```

Supported render patterns mentioned in the API doc:

- `LIST`
- `MAP`
- `MAP -> LIST`
- `LIST -> MAP`

## Primitive examples

### String

```json
{
  "type": "string",
  "value": "Hello world"
}
```

### Number

```json
{
  "type": "number",
  "value": 123
}
```

### Boolean

```json
{
  "type": "bool",
  "value": true
}
```

## Composite examples

### Map value

```json
{
  "type": "map",
  "fields": {
    "Name": {
      "type": "string",
      "value": "Hello world"
    }
  }
}
```

### List value

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

## Example derived from template dependencies

If the enabled template exposes dependencies like:

```json
{
  "fields": [
    ["Name"],
    ["Story1", "StoryName"],
    ["Story1", "StartAt"]
  ]
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
