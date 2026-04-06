# DocuGenius API 文档

## 接口鉴权方式

通过 **App Token** \(暂时可以联系销售获取\) 鉴权，使用 HTTP Header 添加鉴权头：

```HTTP
Authorization: Bearer <AppToken>
```

> **生产环境**：https://open.docugenius.site

## API

### 创建模版文档 Create doc

`POST /api/docs`

| 参数        | 含义       |          |
| ----------- | ---------- | -------- |
| `name`      | 名称       |          |
| ~~`extId`~~ | ~~外部ID~~ | ~~可选~~ |

#### Body

```JSON
{
  "name": "Sprint"
}
```

#### Response

```JSON
{
  "code": 0,
  "data": {
    "id": "67629beee4b0d58547b4803f"
  },
  "msg": "",
  "page": null,
  "errcode": 0,
  "errmsg": ""
}
```

### 更新\***\*模版\*\***文档 Update doc

`PUT /api/docs/:docId`

| 参数  | 含义   |     |
| ----- | ------ | --- |
| docId | 文档id |     |

#### Body

```JSON
{
  "name": "Sprint",
  "dataSource": { groups: [] },
}
```

#### Response

```JSON
{
  "code": 0,
  "data": {
    "id": "",
    "dataSourceContent": "",
    "extId": "",
    "isResetTemplate": false,    // *是否支持重置模版*
  },
  "msg": "",
  "page": null,
  "errcode": 0,
  "errmsg": ""
}
```

### 文档详情 Get doc detail

通过获取文档详情， 可以获取文档下绑定的模版列表， 字段详情， 依赖关系

`GET /api/docs/:docId`

```JSON
{
  "data": {
    "id": "",
    "templates": [],
    "extId": ""
  }
}
```

### 删除文档 Delete a doc

`DELETE /api/docs/:docId`

### 获取临时编辑器地址 Generate doc editor URL

`POST /api/docs/:docId/create-editor-url`

临时地址， 进入后可以连续使用 24 小时， 过期token无法使用， 需要重新获取。

#### Body

- dataSource 查看 [DataSource](https://docugenius.feishu.cn/wiki/WOnvwvtjXibY7nkWL1qc7u9bnKb#share-XOy2duGnKoF7c6xVhjEcn9m5nLd) 定义

- lang：切换界面语言，[多语言字段](https://docugenius.feishu.cn/wiki/WOnvwvtjXibY7nkWL1qc7u9bnKb#share-MdfUdXYWioaRfsxoc6qc8jSpnHd)

- name: 更新文档名称 NEW

- meta: 元信息 可选
  - templateGeneratorId: `string` 可选 your-default-template-id 默认模版生成器 ID

```JSON
{
  "lang": "zh-CN",
  "name": "", // you can update doc name here
  "dataSource": { groups: [] },
  "meta": {
    "templateGeneratorId": "your-id"
  }
}
```

#### Response

```JSON
{
   "code": 0,
   "msg": "",
   "data": {
     "url": "https://xxxxxxx"
   }
  }
```

```Shell
Case 1:

curl -i -XPOST -H'Content-Type:application/json' -H'authorization:Bearer ${token}' -d'{"dataSource":{"groups":[{"name":"group1","description":"group1","variables":[{"fieldType":"string","fieldName":"variable1"},{"fieldType":"map","fieldName":"variable2","specId":"spec1"},{"fieldType":"list","fieldName":"variable3","specId":"spec2"}],"dataSpecs":[{"id":"spec1","variables":[{"fieldType":"string","fieldName":"foo1"},{"fieldType":"string","fieldName":"foo2"},{"fieldType":"string","fieldName":"foo2"}]},{"id":"spec2","variables":[{"fieldType":"string","fieldName":"bar1"},{"fieldType":"string","fieldName":"bar2"},{"fieldType":"map","fieldName":"bar3","specId":"spec3"}]},{"id":"spec3","variables":[{"fieldType":"string","fieldName":"z1"},{"fieldType":"string","fieldName":"z2"},{"fieldType":"map","fieldName":"z3","specId":"spec1"}]}]}]}}' 'https://dg-open-dev.shicaizhaopin.net/api/docs/${docId}/create-editor-url'
```

### 获取文档预览临时地址 Get doc preview URL

`POST /api/docs/:docId/create-preview-url`

#### 请求体

1. `data`: InstanceData

2. `lang`: 界面语言，查看支持的[语言列表 ](https://docugenius.feishu.cn/wiki/WOnvwvtjXibY7nkWL1qc7u9bnKb#share-A5mSdQSm9oEF2Rxgz3McHksSnEe)

3. `templateId`： string, 可选, 如传入模版ID， 在预览界面将不显示模版选择器

4. `env`: 可选， 选择 snapshot

5. `timeZone`: 可选, 文档时区，**还未实现**

6. `config`: Record<string, any>, 可选
   1. `hideTemplateSelector`: boolean, 可选， 可以关闭模版选择器的显示

```JSON
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

Response

```JSON
{
    "code": 0,
    "data": {
        "url": "https://..."
    },
    "msg": ""
}
```

### 生成导出任务 Create a exporting job

`POST /api/docs/:docId/export-jobs`

#### Body

callbackUrl 可选， 任务状态变更时的回调

#### 参数

- `env`： string，可选，选择 snapshot

- `data`: DataValue 类型， 必填， 文档数据

- `fileName`: string， 可选， 导出文件名

- `templateId`： string, 必填， 模版ID

- `exportType`: string, 可选， 导出文件转格式， 值可选 \&\#34;default\&\#34;, \&\#34;pdf\&\#34;, \&\#34;image\&\#34;

- `callbackUrl`： string, 可选， 回调地址

```JSON
{
  "env": "release1",
  "data": {
    // 实例结构 json
  },
  "fileName": "文件名.pdf",    // 可选
  "templateId": "",
  "exportType": "default",
  "callbackUrl": "https://your_callback_url"
}
```

#### Response

```JSON
{
  "code": 0,
  "data": {
    "jobToken": "your-job-id"
  }
}
```

#### CallbackUrl 发起的POST Body内容

```JSON
{
    jobStatus: 3,
    url: '',
    type: 'pdf',
    fileName: 'xxx.pdf'
}
```

### 轮训获取任务信息 \*\*Get export job info

`GET /api/docs/:docId/export-jobs/:jobToken`

jobStatus：0 \(未处理\)，3 \(完成\)，4 \(失败\)

任务完成时

```JSON
{
  code: 0,
  data: {
    jobStatus: 3,
    url: '',
    type: 'pdf',
    fileName: 'xxx.pdf'
  }
}
```

### 批量导出 Create a batch export job

`POST /api/docs/:docId/batch-export-jobs`

#### Body

- `jobs`: 任务列表

- `jobs.fileName`: 文件名 \(可选\)

- `jobs.data`: 模版数据 [InstanceData](https://docugenius.feishu.cn/wiki/WOnvwvtjXibY7nkWL1qc7u9bnKb#share-LnU8dXrwmoiSZDxjvn0c120jnHI)

- `templateId`： 模版ID 模版必须已经发布并启用

- callbackUrl: 回调地址 可选

- fileName: 文件名（可选）

```JSON
{
  "code": 0,
  "data": {
      "templateId": "aaa123",
      "jobs": [
        {
          "fileName": fileName,
          "data": {
              // 实例数据 json
          }
        }
      ],
      "callbackUrl": ""
    }
}
```

#### Response

```JSON
{
  "code": 0,
  "data": {
    "jobToken": "your-job-id"
  }
}
```

### 查询生成导出任务 **Get** batch doc export Job

`GET /api/docs/:docId/batch-export-jobs/:jobToken `

#### Response

```JSON
{
  "code": 0,
  "data": {
    "taskStatus": 0,
    "processed": 1,
    "total": 2,
    "errorMessage": "",
    "url": "" //zip url
  }
}
```

### 获取已启用的模版列表 Get Enabled Templates

`GET /api/docs/:docId/enabled-templates`

#### Response

```JSON
{
  "code": 0,
  "data": [
      {
          "id": "模版1",
          "name": "模版名字",
          "type": 1,
          "deps": {
             version: "deps/1.0",
             fields: [
                   ["Name"],
                   ["Story1"， "StoryName"],
                   ["Story1"， "StartAt"],
                   ["Story1"， "Project", "Name"],
                   ["Comments"， "*"],
              ]
          }
      }
  ]
}
```

如果要渲染`模版1`按依赖关系组装数据如下。

```JSON
{
  "type": "map",
  "fields": {
    Name: {
      type: "string",
      value: "Hello world"
    },
    Story1: {
      type: "map",
      fields: {
        StoryName: {
          type: "string",
          value: "Hello world"
        }
        StartAt: {
          type: "string",
          value: "Hello world"
        },
        Project: {
          type: "type"
        }
      }
    }
  }
}
```

### 获取已启用的模版详情 Get Enabled Templates Detail

`GET /api/docs/:docId/enabled-templates/:templateId`

#### Response

```JSON
{
  "code": 0,
  "data": {
      "id": "模版1",
      "name": "模版名字",
      "type": 1,
      "deps": {
         version: "deps/1.0",
         fields: [
               ["Name"],
               ["Story1"， "StoryName"],
               ["Story1"， "StartAt"],
               ["Story1"， "Project", "Name"],
               ["Comments"， "*"],
          ]
      }
  }
}
```

## 类型定义

### DataSource 数据源

数据源定义了编辑器里面可用的数据字段， 如下图，数据源里面， 不同类型的数据可以通过分组（Group）组织。 如图中的表单对应用户当前审批的自定义表单字段。 “系统”分组内包含通用的字段如申请人，申请时间等。

| 字段名    | 类型                                                                                                             | 描述                                     |
| --------- | ---------------------------------------------------------------------------------------------------------------- | ---------------------------------------- |
| groups    | [DataGroup](https://docugenius.feishu.cn/wiki/WOnvwvtjXibY7nkWL1qc7u9bnKb#share-S2ejd6rQfol9iOxsVB8ce0KVnVb)\[\] | 数据分组                                 |
| dataSpecs | TDataSpec\[\]                                                                                                    | 数据描述， 用来描述Map 或 List的数据格式 |

##### 示例：

```JSON
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
          "fieldName": "z2"
          "fieldType": "string",
          "fieldType": "list",
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

##### 示例2 \(兼容版本 废弃\)：

```JSON
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
            {
              "fieldType": "string",
              "fieldName": "foo1"
            },
            {
              "fieldType": "string",
              "fieldName": "foo2"
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
              "fieldType": "string",
              "fieldName": "z2"
            },
            {
              "fieldType": "map",
              "fieldName": "z3",
              "specId": "spec1"
            }
          ]
        }
      ]
    }
  ]
}
```

### DataGroup 数据分组

| 字段名        | 类型    | 描述         |
| ------------- | ------- | ------------ |
| `name`        | string  | 组名         |
| `description` | string? | 组描述       |
| `specId`      | string  | 索引数据描述 |

### DataVariable 数据变量

| name                | type                 |                                                                                            |
| ------------------- | -------------------- | ------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------- | ------------------------ | ----------------- | ------------------ | ------------------ | -------- |
| fieldName           | string               | 字段标识                                                                                   |
| fieldType           | \&\#39;string\&\#39; | \&\#39;number\&\#39;                                                                       | \&\#39;datetime\&\#39;                                                  | \&\#39;attachment\&\#39; | \&\#39;map\&\#39; | \&\#39;list\&\#39; | \&\#39;bool\&\#39; | 字段类型 |
| label               | string?              | 字段名称， 可选                                                                            |
| specId              | string?              | fieldType 是 \&\#39;map\&\#39; 或 \&\#39;list\&\#39; 时必填, 通过引用 TDataSpec 来描述数据 |
| stringContentFormat | \&\#39;html\&\#39;   | \&\#39;markdown\&\#39;                                                                     | 可选，字符串内容格式， 会通过该信息推荐用户使用合适的控件渲染（实现中） |

### TDataSpec 数据描述

| name      | type             |
| --------- | ---------------- |
| id        | string           |
| variables | DataVariable\[\] |

### Template 文档的子模版

| name | type   | 描述                                 |
| ---- | ------ | ------------------------------------ |
| id   | string | 模版ID                               |
| name | string | 模版名称                             |
| type | number | 模版类型 0. 在线模版 1. Docx 2. xlsx |

### Export Job 导出任务

| name            | type        | 描述                                |
| --------------- | ----------- | ----------------------------------- |
| status          | 0，1，2， 3 | 0. 队列中 1. 运行中 2. 失败 3. 成功 |
| message         | string      | 错误信息                            |
| jobToken        | string      | 任务标识                            |
| result          | object      | 任务结果                            |
| result.url      | string      | 临时下载地址                        |
| result.fileName | string      | 文件名                              |
| result.fileType | string      | 文件类型                            |

### InstanceData 实例数据

InstanceData 为导出或预览需要的文档实例数据， 类型同 [MapValue](https://docugenius.feishu.cn/wiki/WOnvwvtjXibY7nkWL1qc7u9bnKb#share-Fee0dbP0Go0tGBxTCnIcr0ornEe)

在排版打印在线排版中支持的数据格式如下（不包括根节点的MAP）

1. LIST 单层 LIST

2. MAP 单层 MAP

3. MAP -> LIST

4. LIST -> MAP List 下有一层 MAP 格式

### DataValue

DataValue 包含以下类型

- [MapValue](https://docugenius.feishu.cn/wiki/WOnvwvtjXibY7nkWL1qc7u9bnKb#share-Fee0dbP0Go0tGBxTCnIcr0ornEe) 对象

- ListValue 数组

- StringValue 字符串

- NumberValue 数字

- AttachmentsValue 附件类型

- BoolValue 布尔类型

### MapValue 实例数据

| 字段名      | 类型                                    | 含义                  |
| ----------- | --------------------------------------- | --------------------- |
| type        | \&\#34;map\&\#34;                       |                       |
| displayText | string?                                 | 用于直接根节点， 可选 |
| fields      | Record<\&\#34;string\&\#34;, DataValue> |                       |

```JSON
{
  "type": "map",
  "displayText": "",
  "fields": {
*    "var1": {*
*      "type": "string",*
*      "value": "Hello world"*
*    }*
  }
}
```

支持

### ListValue 实例数据 「循环字段」

| 字段名      | 类型               | 含义                                  |
| ----------- | ------------------ | ------------------------------------- |
| type        | \&\#34;list\&\#34; |                                       |
| displayText | string?            | 直接渲染节点用，可选 原先为`fomarted` |
| items       | MapValue\[\]       | List 下仅支持Map                      |

### StringValue 实例数据

| 字段名 | 类型                 | 含义 |
| ------ | -------------------- | ---- |
| type   | \&\#34;string\&\#34; |      |
| value  | string               |      |

### NumberValue 实例数据

| 字段名      | 类型                 | 含义     |
| ----------- | -------------------- | -------- |
| type        | \&\#34;number\&\#34; |          |
| displayText | string               | 格式化值 |
| numberValue | number               | 原始值   |

### DateTimeValue 实例数据

| 字段名      | 类型                   | 含义     |
| ----------- | ---------------------- | -------- | ------------------------------------------ |
| type        | \&\#34;datetime\&\#34; |          |
| displayText | string                 | 格式化值 |
| timestamp   | number                 | null     | 原始值，时间戳， 使用毫秒, null 表示值为空 |

### BoolValue 实例数据（new）

| 字段名             | 类型               | 含义   |
| ------------------ | ------------------ | ------ | --------------- |
| `type`             | \&\#34;bool\&\#34; |        |
| `value`            | boolean            | null   | null 表示值为空 |
| `displayText` 可选 | string             | 显示值 |

### AttachmentsValue 实例数据

| 字段名      | 类型                                                                                                              | 含义 |
| ----------- | ----------------------------------------------------------------------------------------------------------------- | ---- |
| type        | \&\#34;attachments\&\#34;                                                                                         | 附件 |
| attachments | [Attachment](https://docugenius.feishu.cn/wiki/WOnvwvtjXibY7nkWL1qc7u9bnKb#share-Khigd32oRoh2CvxefEMc7arznrf)\[\] |      |

### Attachment 实例数据

| 字段名   | 类型   | 可选 | 含义             |
| -------- | ------ | ---- | ---------------- |
| url      | string | 否   | 文件地址         |
| mime     | string | 否   | mime             |
| fileName | string | 是   | 文件名           |
| fileSize | number | 是   | 文件大小，字节数 |

### JobStatus

| 字段名    | 类型          | 可选 | 含义                    |
| --------- | ------------- | ---- | ----------------------- |
| success   | boolean       | 否   | 文件地址                |
| message   | string        | 否   | mime                    |
| errorCode | string        | 是   | 文件名                  |
| data      | ExportJobInfo | 是   | 成功时， 会包含任务结果 |

## 错误码

| code  | Http 状态码 | 含义             |
| ----- | ----------- | ---------------- |
| 404   | 404         | 资源不存在       |
| 400   | 400         | 参数错误         |
| 401   | 401         | 认证失败         |
| 403   | 403         | 无权限访问资源   |
| 10001 | 403         | 付费到期         |
| 418   | 418         | 访问频率超过限制 |

## 多语言

支持的多语言：

```JSON
{
      "de-DE": "Deutsch",
      "en-US": "English",
      "es-ES": "Español",
      "fr-FR": "Français",
      "id-ID": "Bahasa Indonesia",
      "it-IT": "Italiano",
      "ja-JP": "日本語",
      "ko-KR": "한국어",
      "pt-BR": "Português",
      "ru-RU": "Русский",
      "th-TH": "ไทย",
      "vi-VN": "Tiếng Việt",
      "zh-CN": "简体中文",
      "zh-HK": "繁體中文 (香港)",
      "zh-TW": "繁體中文 (台灣)"
}
```

## 示例

### 实现多层结构

定义

```YAML
groups:
- name:  默认
  specId: IGroup
dataSpecs:
  - id: IGroup
    variables:
        - name: 'story'
          type: 'list'
          specId: 'IStory'
  - id: IStory
    variables:
        - task:
           type: 'list'
           specId: 'ITask'
  - id: ITask
    variables:
    - name: name
      type: string
```

数据实例

```Bash

{
  "type": "map",
  "fields": {
      "storys": {
          "type": "list",
          "items": [
              {
                  type: "map",
                  fields: {
                      tasks: {
                        type: "list"
                        items: [
                            {
                                "type: 'map",
                                "fields": {
                                  name: {
                                      type: "string",
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
