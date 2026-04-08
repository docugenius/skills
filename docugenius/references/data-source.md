# DocuGenius DataSource Reference

Use this reference when defining the fields that template authors can use in the editor schema.

## What DataSource is for

`dataSource` defines the fields available to a template document.

You can provide or update it through:

- `PUT /api/docs/:docId`
- `POST /api/docs/:docId/create-editor-url`

Without a valid `dataSource`, the template document cannot expose usable schema fields in the editor.

## Top-level shape

| Field       | Type          | Description                                         |
| ----------- | ------------- | --------------------------------------------------- |
| `groups`    | DataGroup\[\] | data groups                                         |
| `dataSpecs` | TDataSpec\[\] | data specs, describes the shape of Map or List data |

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

| Field         | Type    | Description                                |
| ------------- | ------- | ------------------------------------------ |
| `name`        | string  | group name                                 |
| `description` | string? | optional group description                 |
| `specId`      | string  | the referenced data spec ID for this group |

### DataVariable

| Field                 | Type                                                                                          | Description                                                          |
| --------------------- | --------------------------------------------------------------------------------------------- | -------------------------------------------------------------------- |
| `fieldName`           | string                                                                                        | field key                                                            |
| `fieldType`           | `"string"` \| `"number"` \| `"datetime"` \| `"attachment"` \| `"map"` \| `"list"` \| `"bool"` | field type                                                           |
| `label`               | string?                                                                                       | optional display label                                               |
| `specId`              | string?                                                                                       | required when `fieldType` is `map` or `list`                         |
| `stringContentFormat` | `"html"` \| `"markdown"`                                                                      | optional, recommends a suitable rendering control for string content |

### TDataSpec

| Field       | Type             | Description     |
| ----------- | ---------------- | --------------- |
| `id`        | string           | spec identifier |
| `variables` | DataVariable\[\] | field list      |

## Design notes

- Put user-facing editor fields into `groups`.
- Put reusable nested object or list schemas into `dataSpecs`.
- For `map` and `list` fields, always point to a valid `specId`.
- Use stable field names because templates will bind to them.

## Full example

```json
{
  "dataSpecs": [
    {
      "id": "group1",
      "variables": [
        {
          "fieldType": "string",
          "fieldName": "variable1"
        },
        {
          "fieldType": "map",
          "fieldName": "variable2",
          "specId": "spec1"
        },
        {
          "fieldType": "list",
          "fieldName": "variable3",
          "specId": "spec2"
        }
      ]
    },
    {
      "id": "spec1",
      "variables": [
        {
          "fieldType": "string",
          "fieldName": "foo1"
        },
        {
          "fieldType": "string",
          "fieldName": "foo2"
        }
      ]
    },
    {
      "id": "spec2",
      "variables": [
        {
          "fieldType": "string",
          "fieldName": "bar1"
        },
        {
          "fieldType": "string",
          "fieldName": "bar2"
        },
        {
          "fieldType": "map",
          "fieldName": "bar3",
          "specId": "spec3"
        }
      ]
    },
    {
      "id": "spec3",
      "variables": [
        {
          "fieldType": "string",
          "fieldName": "z1"
        },
        {
          "fieldType": "list",
          "fieldName": "z2",
          "label": "列表字段z2"
        },
        {
          "fieldType": "map",
          "fieldName": "z3",
          "specId": "spec1"
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

## Legacy format (deprecated)

The older format embeds `variables` and `dataSpecs` directly inside each group. This is still supported for backward compatibility but should not be used for new integrations.

```json
{
  "groups": [
    {
      "name": "group1",
      "description": "group1",
      "variables": [
        {
          "fieldType": "string",
          "fieldName": "variable1"
        },
        {
          "fieldType": "map",
          "fieldName": "variable2",
          "specId": "spec1"
        },
        {
          "fieldType": "list",
          "fieldName": "variable3",
          "specId": "spec2"
        }
      ],
      "dataSpecs": [
        {
          "id": "spec1",
          "variables": [
            { "fieldType": "string", "fieldName": "foo1" },
            { "fieldType": "string", "fieldName": "foo2" }
          ]
        },
        {
          "id": "spec2",
          "variables": [
            { "fieldType": "string", "fieldName": "bar1" },
            { "fieldType": "string", "fieldName": "bar2" },
            { "fieldType": "map", "fieldName": "bar3", "specId": "spec3" }
          ]
        },
        {
          "id": "spec3",
          "variables": [
            { "fieldType": "string", "fieldName": "z1" },
            { "fieldType": "string", "fieldName": "z2" },
            { "fieldType": "map", "fieldName": "z3", "specId": "spec1" }
          ]
        }
      ]
    }
  ]
}
```

## Multi-level nesting example

Define a multi-level structure with nested lists:

```yaml
groups:
  - name: 默认
    specId: IGroup
dataSpecs:
  - id: IGroup
    variables:
      - name: "story"
        type: "list"
        specId: "IStory"
  - id: IStory
    variables:
      - task:
          type: "list"
          specId: "ITask"
  - id: ITask
    variables:
      - name: name
        type: string
```

Corresponding data instance:

```json
{
  "type": "map",
  "fields": {
    "storys": {
      "type": "list",
      "items": [
        {
          "type": "map",
          "fields": {
            "tasks": {
              "type": "list",
              "items": [
                {
                  "type": "map",
                  "fields": {
                    "name": {
                      "type": "string",
                      "value": "任务1"
                    }
                  }
                }
              ]
            }
          }
        }
      ]
    }
  }
}
```

## When to use this file

- Building the initial template schema
- Updating available fields before editing templates
- Explaining why template fields do not appear in the editor
