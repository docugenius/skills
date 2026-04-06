# DocuGenius DataSource Reference

Use this reference when defining the fields that template authors can use in the editor schema.

## What DataSource is for

`dataSource` defines the fields available to a template document.

You can provide or update it through:

- `PUT /api/docs/:docId`
- `POST /api/docs/:docId/create-editor-url`

Without a valid `dataSource`, the template document cannot expose usable schema fields in the editor.

## Top-level shape

```json
{
  "dataSpecs": [
    {
      "id": "group1",
      "variables": [
        {
          "fieldType": "string",
          "fieldName": "variable1"
        }
      ]
    }
  ],
  "groups": [
    {
      "name": "group1",
      "description": "group1",
      "specId": "group1"
    }
  ]
}
```

## Main objects

### DataGroup

- `name`: group name
- `description`: optional group description
- `specId`: the referenced data spec ID for this group

### DataVariable

- `fieldName`: field key
- `fieldType`: `string` | `number` | `datetime` | `attachment` | `map` | `list` | `bool`
- `label`: optional display label
- `specId`: required when `fieldType` is `map` or `list`
- `stringContentFormat`: optional `html` or `markdown`

### TDataSpec

- `id`: spec identifier
- `variables`: array of `DataVariable`

## Design notes

- Put user-facing editor fields into `groups`.
- Put reusable nested object or list schemas into `dataSpecs`.
- For `map` and `list` fields, always point to a valid `specId`.
- Use stable field names because templates will bind to them.

## Minimal example

```json
{
  "dataSpecs": [
    {
      "id": "employee_spec",
      "variables": [
        {
          "fieldName": "name",
          "fieldType": "string"
        },
        {
          "fieldName": "startDate",
          "fieldType": "datetime"
        }
      ]
    }
  ],
  "groups": [
    {
      "name": "Employee",
      "description": "Fields available to the template",
      "specId": "employee_spec"
    }
  ]
}
```

## When to use this file

- Building the initial template schema
- Updating available fields before editing templates
- Explaining why template fields do not appear in the editor
