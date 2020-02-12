# 搜索
> [官方文档](https://www.elastic.co/guide/en/elasticsearch/reference/current/search.html)

搜索分为：
    - 简单的查询字符串
    - 请求主体

#### 多索引
可以搜索多索引、类型，用逗号分隔
```
curl -X GET "localhost:9200/kimchy,elasticsearch/_search?q=tag:wow"
```
或者用`_all`参数，搜索所有索引
```
curl -X GET "localhost:9200/_all/_search?q=tag:wow"
```

## uri搜索
```
curl -X GET "localhost:9200/twitter/_search?q=user:kimchy"
```

### 支持的参数
| 名称                         | 描述                                                                                                                                                                           |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `q`                            | 查询字符串（映射到query_string查询，请参阅 查询字符串查询以获取更多详细信息）。                                                                                                |
| `df`                           | 在查询中未定义字段前缀时使用的默认字段。                                                                                                                                       |
| `analyzer`                     | 分析查询字符串时要使用的分析器名称。                                                                                                                                           |
| `analyze_wildcard`             | 是否应分析通配符和前缀查询。默认为false。                                                                                                                                      |
| `batched_reduce_size`          | 应在协调节点上一次减少的分片结果数。如果请求中潜在的分片数量很大，则应将此值用作保护机制，以减少每个搜索请求的内存开销。                                                       |
| `default_operator`             | 要使用的默认运算符可以是AND或 OR。默认为OR。                                                                                                                                   |
| `lenient`                      | 如果设置为true将导致忽略基于格式的失败（如向数字字段提供文本）。默认为false。                                                                                                  |
| `explain`                      | 对于每个命中，包含如何计算命中得分的解释。                                                                                                                                     |
| `_source`                      | 设置为false禁用_source字段检索。您还可以使用_source_includes＆检索部分文档_source_excludes（ 有关详细信息，请参阅请求正文文档）                                                |
| `stored_fields`                | 每个匹配返回的文档的选择性存储字段，逗号分隔。不指定任何值将导致不返回任何字段。                                                                                               |
| `sort`                         | 排序执行。可以是fieldName或 fieldName:asc/ 的形式fieldName:desc。fieldName可以是文档中的实际字段，也可以是_score指示基于分数排序的特殊名称。可以有几个sort参数（顺序很重要）。 |
| `track_scores`                 | 排序时，设置为true仍然跟踪分数并将其作为每个匹配的一部分返回。                                                                                                                 |
| `track_total_hits`             | 设置为false禁用跟踪与查询匹配的匹配总数。（有关详细信息，请参阅索引排序）。默认为true。                                                                                        |
| `timeout`                      | 搜索超时，将搜索请求限制在指定的时间值内执行，并使用在到期时累积的点击数进行保释。默认为无超时。                                                                               |
| `terminate_after`              | 在达到查询执行将提前终止时，为每个分片收集的最大文档数。如果设置，响应将具有一个布尔字段，terminated_early以指示查询执行是否实际上已终止。默认为no terminate_after。           |
| `from`                         | 从命中的索引开始返回。默认为0。                                                                                                                                                |
| `size`                         | 要返回的点击次数。默认为10。                                                                                                                                                  |
| `search_type`                  | 要执行的搜索操作的类型。可以是 dfs_query_then_fetch或query_then_fetch。默认为query_then_fetch。有关可以执行的不同搜索类型的更多详细信息，请参阅 搜索类型。                     |
| `allow_partial_search_results` | false如果请求将产生部分结果，则设置为返回整体故障。默认为true，这将在超时或部分失败的情况下允许部分结果。可以使用群集级别设置来控制此默认值 search.default_allow_partial_results。                                                                                                                                            |

## 请求体搜索
搜索请求可以在其主体内使用包括查询DSL的搜索DSL来执行
```
curl -X GET "localhost:9200/twitter/_search" -H 'Content-Type: application/json' -d'
{
    "query" : {
        "term" : { "user" : "kimchy" }
    }
}
'
```
响应

```
{
    "took": 1,
    "timed_out": false,
    "_shards":{
        "total" : 1,
        "successful" : 1,
        "skipped" : 0,
        "failed" : 0
    },
    "hits":{
        "total" : 1,
        "max_score": 1.3862944,
        "hits" : [
            {
                "_index" : "twitter",
                "_type" : "_doc",
                "_id" : "0",
                "_score": 1.3862944,
                "_source" : {
                    "user" : "kimchy",
                    "message": "trying out Elasticsearch",
                    "date" : "2009-11-15T14:12:12",
                    "likes" : 0
                }
            }
        ]
    }
}
```

### 分页，可以使用`from`，`size`来分页
- `from`参数定义要获取的第一个结果的偏移量，从第几条开始
- `size`参数允许您配置要返回的最大命中数，返回几条信息
```
curl -X GET "localhost:9200/_search" -H 'Content-Type: application/json' -d'
{
    "from" : 0, "size" : 10,
    "query" : {
        "term" : { "user" : "kimchy" }
    }
}
'
```
**请注意，from+ size不能超过index.max_result_window 默认为10,000 的索引设置**

### 排序
允许您在特定字段上添加一个或多个排序。每种类型也可以反转。排序是在每个字段级别定义的，具有用于`_score`按分数排序的特殊字段名称，以及`_doc`按索引顺序排序。
```
curl -X GET "localhost:9200/my_index/_search" -H 'Content-Type: application/json' -d'
{
    "sort" : [
        { "post_date" : {"order" : "asc"}},
        "user",
        { "name" : "desc" },
        { "age" : "desc" },
        "_score"
    ],
    "query" : {
        "term" : { "user" : "kimchy" }
    }
}
'
```
排序取值：`asc`、`desc`

#### 排序模式选项
Elasticsearch支持按数组或多值字段进行排序。该mode选项控制选择哪个数组值以对其所属的文档进行排序。该mode选项可以具有以下值：
| min    | 选择最低值                                                 |
| ------ | ---------------------------------------------------------- |
| max    | 选择最高价值。                                             |
| sum    | 使用所有值的总和作为排序值。仅适用于基于数字的数组字段。   |
| avg    | 使用所有值的平均值作为排序值。仅适用于基于数字的数组字段。 |
| median | 使用所有值的中位数作为排序值。仅适用于基于数字的数组字段   |

升序排序顺序的默认排序模式是min - 选择最低值。降序的默认排序模式是max - 选择最高值。

##### 用例
在下面的示例中，字段价格每个文档有多个价格。在这种情况下，结果点击将根据每个文档的平均价格按价格上升进行排序。
```
curl -X PUT "localhost:9200/my_index/_doc/1?refresh" -H 'Content-Type: application/json' -d'
{
   "product": "chocolate",
   "price": [20, 4]
}
'
curl -X POST "localhost:9200/_search" -H 'Content-Type: application/json' -d'
{
   "query" : {
      "term" : { "product" : "chocolate" }
   },
   "sort" : [
      {"price" : {"order" : "asc", "mode" : "avg"}}
   ]
}
'
```

## `_source`可以控制源过滤返回的字段
要禁用`_source`检索设置为false：
```
curl -X GET "localhost:9200/_search" -H 'Content-Type: application/json' -d'
{
    "_source": false,
    "query" : {
        "term" : { "user" : "kimchy" }
    }
}
'
```

该`_source`还接受一个或多个通配符模式来控制哪些的部分`_source`应返回：
```
curl -X GET "localhost:9200/_search" -H 'Content-Type: application/json' -d'
{
    "_source": "obj.*",
    "query" : {
        "term" : { "user" : "kimchy" }
    }
}
'
```

最后，为了完全控制，您可以指定两者`includes`和`excludes` 模式：
```
curl -X GET "localhost:9200/_search" -H 'Content-Type: application/json' -d'
{
    "_source": {
        "includes": [ "obj1.*", "obj2.*" ],
        "excludes": [ "*.description" ]
    },
    "query" : {
        "term" : { "user" : "kimchy" }
    }
}
'
```
