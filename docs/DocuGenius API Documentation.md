# DocuGenius API 文档

## **接口鉴权方式**

通过 **App Token** \(暂时可以联系销售获取\) 鉴权，使用 HTTP Header 添加鉴权头：

```HTTP
Authorization: Bearer <AppToken>
```


    测试环境域名：https://dg\-open\-dev\.shicaizhaopin\.net
    生产环境域名：https://open\.docugenius\.site

## API

### **创建模版文档 Create doc**

`POST ``/api``/docs`

<table><tbody>
<tr>
<td>

参数

</td>
<td>

含义

</td>
<td>



</td>
</tr>
<tr>
<td>

`name`

</td>
<td>

名称

</td>
<td>



</td>
</tr>
<tr>
<td>

~~`extId`~~

</td>
<td>

~~外部ID~~

</td>
<td>

~~可选~~

</td>
</tr>
</tbody></table>

#### **Body**

```JSON
{
  "name": "Sprint"
}
```

#### **Response**

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



### **更新****模版****文档 Update doc**

`PUT ``/api``/docs/:docId`

<table><tbody>
<tr>
<td>

参数

</td>
<td>

含义

</td>
<td>



</td>
</tr>
<tr>
<td>

docId

</td>
<td>

文档id

</td>
<td>



</td>
</tr>
</tbody></table>

#### **Body**

```JSON
{
  "name": "Sprint",
  "dataSource": { groups: [] },
}
```

#### **Response**

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



### **文档详情 Get doc detail**

通过获取文档详情， 可以获取文档下绑定的模版列表， 字段详情， 依赖关系

`GET ``/api``/docs/:docId`

```JSON
{
  "data": {
    "id": "",
    "templates": [],
    "extId": ""
  }
}
```



### **删除文档 Delete a doc**

`DELETE ``/api``/docs/:docId`

### **获取临时编辑器地址 Generate doc editor URL **

`POST ``/api``/docs/:docId/create\-editor\-url`

临时地址， 进入后可以连续使用 24 小时， 过期token无法使用， 需要重新获取。 

#### **Body**

- dataSource 查看 [DataSource](https://docugenius.feishu.cn/wiki/WOnvwvtjXibY7nkWL1qc7u9bnKb#share-XOy2duGnKoF7c6xVhjEcn9m5nLd) 定义

- lang：切换界面语言，[多语言字段](https://docugenius.feishu.cn/wiki/WOnvwvtjXibY7nkWL1qc7u9bnKb#share-MdfUdXYWioaRfsxoc6qc8jSpnHd)

- name: 更新文档名称  NEW

- meta: 元信息 可选

    - templateGeneratorId: `string` 可选 your\-default\-template\-id 默认模版生成器 ID

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

#### **Response**

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

### **获取文档预览临时地址 Get doc preview URL**

`POST ``/api``/docs/:docId/create\-preview\-url`

#### 请求体

1. `data`: InstanceData

2. `lang`: 界面语言，查看支持的[语言列表 ](https://docugenius.feishu.cn/wiki/WOnvwvtjXibY7nkWL1qc7u9bnKb#share-A5mSdQSm9oEF2Rxgz3McHksSnEe)

3. `templateId`： string, 可选, 如传入模版ID， 在预览界面将不显示模版选择器

4. `env`:  可选， 选择  snapshot

5. `timeZone`: 可选, 文档时区，**还未实现**

6. `config`: Record\&lt;string, any\&gt;, 可选

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

### **生成导出任务 Create a exporting job**

`POST ``/api``/docs/:docId/export\-jobs`

#### **Body**

callbackUrl 可选， 任务状态变更时的回调

#### 参数

- `env`： string，可选，选择 snapshot

- `data`:  DataValue 类型， 必填， 文档数据

- `fileName`: string， 可选， 导出文件名

- `templateId`： string, 必填， 模版ID

- `exportType`: string,  可选， 导出文件转格式， 值可选 \&\#34;default\&\#34;, \&\#34;pdf\&\#34;, \&\#34;image\&\#34;

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

#### **Response**

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

### 轮训获取任务信息 **Get export job info **

`GET ``/api``/docs/:docId/export\-jobs/:jobToken`

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

### **批量导出 Create a  batch export job**

`POST ``/api``/docs/:docId/batch\-export\-jobs`

#### Body

- `jobs`: 任务列表

- `jobs\.fileName`: 文件名 \(可选\)

- `jobs\.data`: 模版数据 [InstanceData](https://docugenius.feishu.cn/wiki/WOnvwvtjXibY7nkWL1qc7u9bnKb#share-LnU8dXrwmoiSZDxjvn0c120jnHI)

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

### **查询生成导出任务 **Get**  batch doc export Job**

`GET ``/api``/docs/:docId/batch\-export\-jobs/:jobToken `

#### **Response**

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

`GET ``/api``/docs/:docId/enabled\-templates`

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

`GET ``/api``/docs/:docId/enabled\-templates/:templateId`

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

## **类型定义**

### **DataSource 数据源**

数据源定义了编辑器里面可用的数据字段， 如下图，数据源里面， 不同类型的数据可以通过分组（Group）组织。 如图中的表单对应用户当前审批的自定义表单字段。 “系统”分组内包含通用的字段如申请人，申请时间等。 



<table><tbody>
<tr>
<td>

字段名

</td>
<td>

类型

</td>
<td>

描述

</td>
</tr>
<tr>
<td>

groups

</td>
<td>

[DataGroup](https://docugenius.feishu.cn/wiki/WOnvwvtjXibY7nkWL1qc7u9bnKb#share-S2ejd6rQfol9iOxsVB8ce0KVnVb)\[\]

</td>
<td>

数据分组

</td>
</tr>
<tr>
<td>

dataSpecs

</td>
<td>

TDataSpec\[\]

</td>
<td>

数据描述， 用来描述Map 或 List的数据格式

</td>
</tr>
</tbody></table>

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

<table><tbody>
<tr>
<td>

字段名

</td>
<td>

类型

</td>
<td>

描述

</td>
</tr>
<tr>
<td>

`name`

</td>
<td>

string

</td>
<td>

组名

</td>
</tr>
<tr>
<td>

`description`

</td>
<td>

string?

</td>
<td>

组描述

</td>
</tr>
<tr>
<td>

`specId`

</td>
<td>

string

</td>
<td>

索引数据描述

</td>
</tr>
</tbody></table>

### DataVariable 数据变量

<table><tbody>
<tr>
<td>

name

</td>
<td>

type

</td>
<td>



</td>
</tr>
<tr>
<td>

fieldName

</td>
<td>

string

</td>
<td>

字段标识

</td>
</tr>
<tr>
<td>

fieldType



</td>
<td>

\&\#39;string\&\#39;\|\&\#39;number\&\#39;\|\&\#39;datetime\&\#39;\|\&\#39;attachment\&\#39;\|\&\#39;map\&\#39;\|\&\#39;list\&\#39;\|\&\#39;bool\&\#39;

</td>
<td>

字段类型

</td>
</tr>
<tr>
<td>

label

</td>
<td>

string?

</td>
<td>

字段名称， 可选

</td>
</tr>
<tr>
<td>

specId



</td>
<td>

string?



</td>
<td>

fieldType 是 \&\#39;map\&\#39; 或 \&\#39;list\&\#39; 时必填, 通过引用 TDataSpec 来描述数据

</td>
</tr>
<tr>
<td>

stringContentFormat



</td>
<td>

\&\#39;html\&\#39; \| \&\#39;markdown\&\#39;



</td>
<td>

可选，字符串内容格式， 会通过该信息推荐用户使用合适的控件渲染（实现中）



</td>
</tr>
</tbody></table>

### TDataSpec  数据描述

<table><tbody>
<tr>
<td>

name

</td>
<td>

type

</td>
</tr>
<tr>
<td>

id

</td>
<td>

string

</td>
</tr>
<tr>
<td>

variables

</td>
<td>

DataVariable\[\]

</td>
</tr>
</tbody></table>

### Template 文档的子模版

<table><tbody>
<tr>
<td>

name

</td>
<td>

type

</td>
<td>

描述

</td>
</tr>
<tr>
<td>

id

</td>
<td>

string

</td>
<td>

模版ID

</td>
</tr>
<tr>
<td>

name

</td>
<td>

string

</td>
<td>

模版名称

</td>
</tr>
<tr>
<td>

type

</td>
<td>

number

</td>
<td>

模版类型

0\. 在线模版

1. Docx

2. xlsx

</td>
</tr>
</tbody></table>

### Export Job 导出任务

<table><tbody>
<tr>
<td>

name

</td>
<td>

type

</td>
<td>

描述

</td>
</tr>
<tr>
<td>

status

</td>
<td>

0，1，2， 3

</td>
<td>

0\. 队列中

1. 运行中

2. 失败

3. 成功

</td>
</tr>
<tr>
<td>

message

</td>
<td>

string



</td>
<td>

错误信息

</td>
</tr>
<tr>
<td>

jobToken

</td>
<td>

string

</td>
<td>

任务标识

</td>
</tr>
<tr>
<td>

result

</td>
<td>

object

</td>
<td>

任务结果

</td>
</tr>
<tr>
<td>

result\.url

</td>
<td>

string

</td>
<td>

临时下载地址

</td>
</tr>
<tr>
<td>

result\.fileName

</td>
<td>

string

</td>
<td>

文件名

</td>
</tr>
<tr>
<td>

result\.fileType

</td>
<td>

string

</td>
<td>

文件类型

</td>
</tr>
</tbody></table>

### InstanceData 实例数据 

InstanceData 为导出或预览需要的文档实例数据， 类型同 [MapValue](https://docugenius.feishu.cn/wiki/WOnvwvtjXibY7nkWL1qc7u9bnKb#share-Fee0dbP0Go0tGBxTCnIcr0ornEe)

在排版打印在线排版中支持的数据格式如下（不包括根节点的MAP）

1. LIST  单层 LIST

2. MAP 单层 MAP

3. MAP \-\&gt; LIST  

4. LIST \-\&gt; MAP  List 下有一层 MAP 格式

### DataValue 

DataValue 包含以下类型

- [MapValue](https://docugenius.feishu.cn/wiki/WOnvwvtjXibY7nkWL1qc7u9bnKb#share-Fee0dbP0Go0tGBxTCnIcr0ornEe) 对象

- ListValue 数组

- StringValue 字符串

- NumberValue 数字

- AttachmentsValue 附件类型

- BoolValue 布尔类型

### MapValue 实例数据

<table><tbody>
<tr>
<td>

字段名

</td>
<td>

类型

</td>
<td>

含义

</td>
</tr>
<tr>
<td>

type

</td>
<td>

\&\#34;map\&\#34;

</td>
<td>



</td>
</tr>
<tr>
<td>

displayText

</td>
<td>

string?

</td>
<td>

用于直接根节点， 可选

</td>
</tr>
<tr>
<td>

fields

</td>
<td>

Record\&lt;\&\#34;string\&\#34;, DataValue\&gt;

</td>
<td>



</td>
</tr>
</tbody></table>

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

<table><tbody>
<tr>
<td>

字段名

</td>
<td>

类型

</td>
<td>

含义

</td>
</tr>
<tr>
<td>

type

</td>
<td>

\&\#34;list\&\#34;

</td>
<td>



</td>
</tr>
<tr>
<td>

displayText

</td>
<td>

string?



</td>
<td>

直接渲染节点用，可选

原先为`fomarted`

</td>
</tr>
<tr>
<td>

items

</td>
<td>

MapValue\[\]

</td>
<td>

List 下仅支持Map

</td>
</tr>
</tbody></table>

### StringValue 实例数据

<table><tbody>
<tr>
<td>

字段名

</td>
<td>

类型

</td>
<td>

含义

</td>
</tr>
<tr>
<td>

type

</td>
<td>

\&\#34;string\&\#34;

</td>
<td>



</td>
</tr>
<tr>
<td>

value

</td>
<td>

string

</td>
<td>



</td>
</tr>
</tbody></table>

### NumberValue 实例数据

<table><tbody>
<tr>
<td>

字段名

</td>
<td>

类型

</td>
<td>

含义

</td>
</tr>
<tr>
<td>

type

</td>
<td>

\&\#34;number\&\#34;

</td>
<td>



</td>
</tr>
<tr>
<td>

displayText

</td>
<td>

string

</td>
<td>

格式化值

</td>
</tr>
<tr>
<td>

numberValue

</td>
<td>

number

</td>
<td>

原始值

</td>
</tr>
</tbody></table>

### DateTimeValue 实例数据

<table><tbody>
<tr>
<td>

字段名

</td>
<td>

类型

</td>
<td>

含义

</td>
</tr>
<tr>
<td>

type

</td>
<td>

\&\#34;datetime\&\#34;

</td>
<td>



</td>
</tr>
<tr>
<td>

displayText

</td>
<td>

string

</td>
<td>

格式化值

</td>
</tr>
<tr>
<td>

timestamp



</td>
<td>

number\|null

</td>
<td>

原始值，时间戳， 使用毫秒, null 表示值为空

</td>
</tr>
</tbody></table>

### BoolValue 实例数据（new）

<table><tbody>
<tr>
<td>

字段名

</td>
<td>

类型

</td>
<td>

含义

</td>
</tr>
<tr>
<td>

`type`

</td>
<td>

\&\#34;bool\&\#34;

</td>
<td>



</td>
</tr>
<tr>
<td>

`value`



</td>
<td>

boolean \| null

</td>
<td>

null 表示值为空

</td>
</tr>
<tr>
<td>

`displayText`

可选



</td>
<td>

string

</td>
<td>

显示值



</td>
</tr>
</tbody></table>

### AttachmentsValue 实例数据

<table><tbody>
<tr>
<td>

字段名

</td>
<td>

类型

</td>
<td>

含义

</td>
</tr>
<tr>
<td>

type

</td>
<td>

\&\#34;attachments\&\#34;

</td>
<td>

附件

</td>
</tr>
<tr>
<td>

attachments

</td>
<td>

[Attachment](https://docugenius.feishu.cn/wiki/WOnvwvtjXibY7nkWL1qc7u9bnKb#share-Khigd32oRoh2CvxefEMc7arznrf)\[\]

</td>
<td>



</td>
</tr>
</tbody></table>

### Attachment 实例数据

<table><tbody>
<tr>
<td>

字段名

</td>
<td>

类型

</td>
<td>

可选

</td>
<td>

含义

</td>
</tr>
<tr>
<td>

url

</td>
<td>

string

</td>
<td>

否

</td>
<td>

文件地址

</td>
</tr>
<tr>
<td>

mime

</td>
<td>

string

</td>
<td>

否

</td>
<td>

mime

</td>
</tr>
<tr>
<td>

fileName

</td>
<td>

string

</td>
<td>

是

</td>
<td>

文件名

</td>
</tr>
<tr>
<td>

fileSize



</td>
<td>

number

</td>
<td>

是



</td>
<td>

文件大小，字节数

</td>
</tr>
</tbody></table>

### JobStatus

<table><tbody>
<tr>
<td>

字段名

</td>
<td>

类型

</td>
<td>

可选

</td>
<td>

含义

</td>
</tr>
<tr>
<td>

success

</td>
<td>

boolean

</td>
<td>

否

</td>
<td>

文件地址

</td>
</tr>
<tr>
<td>

message

</td>
<td>

string

</td>
<td>

否

</td>
<td>

mime

</td>
</tr>
<tr>
<td>

errorCode

</td>
<td>

string

</td>
<td>

是

</td>
<td>

文件名

</td>
</tr>
<tr>
<td>

data



</td>
<td>

ExportJobInfo

</td>
<td>

是



</td>
<td>

成功时， 会包含任务结果

</td>
</tr>
</tbody></table>

## 错误码

<table><tbody>
<tr>
<td>

code

</td>
<td>

Http 状态码

</td>
<td>

含义

</td>
</tr>
<tr>
<td>

404

</td>
<td>

404

</td>
<td>

资源不存在

</td>
</tr>
<tr>
<td>

400

</td>
<td>

400

</td>
<td>

参数错误

</td>
</tr>
<tr>
<td>

401

</td>
<td>

401

</td>
<td>

认证失败

</td>
</tr>
<tr>
<td>

403

</td>
<td>

403

</td>
<td>

无权限访问资源

</td>
</tr>
<tr>
<td>

10001

</td>
<td>

403

</td>
<td>

付费到期

</td>
</tr>
<tr>
<td>

418

</td>
<td>

418

</td>
<td>

访问频率超过限制

</td>
</tr>
</tbody></table>



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





