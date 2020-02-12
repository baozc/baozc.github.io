# es dsl syntax
主要是两大块语法:
1. [query DSL](https://www.elastic.co/guide/en/elasticsearch/reference/5.6/query-dsl.html)
2. [search API](https://www.elastic.co/guide/en/elasticsearch/reference/5.6/search.html)

## query DSL
Elasticsearch提供基于JSON的完整查询DSL（域特定语言）来定义查询。将Query DSL视为查询的AST（抽象语法树），由两种类型的子句组成：
- Leaf query clauses
    - 叶查询子句中寻找一个特定的值在某一特定领域，如 [`match`][1b942251]，[`term`][d337b3d6]或 [`range`][87dde041]查询。这些查询可以单独使用。
- Compound query clauses
    - 复合查询子句包装其他叶子或复合查询，用于以逻辑方式（例如[`bool`][f4b417fe]或[`dis_max`][05e86217]查询）组合多个查询 ，或者用于更改其行为（例如 [`constant_score`][ba57b201]查询）。

查询子句的行为有所不同，具体取决于它们是在 [查询上下文还是过滤器上下文中使用][acde0464]。

### [Query and filter context][bfc5733a]
query子句的行为取决于它是在查询上下文中使用还是在过滤器上下文中使用：
- Query context
    - 查询上下文中使用的查询子句回答了问题“ 此文档与此查询子句的匹配程度如何？“除了决定文档是否匹配之外，查询子句还计算_score表示文档相对于其他文档的匹配程度。
    - 查询上下文是有效每当查询子句被传递给一个query参数，如query该参数`search`的API。
- Filter context
    - 在过滤器上下文中，查询子句回答问题“ 此文档是否与此查询子句匹配？“答案是简单的是或否 - 没有计算分数。过滤器上下文主要用于过滤结构化数据，例如:
        - 这是否`timestamp`属于2015年至2016年的范围？
        - 在`status` 字段设置为"published"？
    - Elasticsearch会自动缓存经常使用的过滤器，以加快性能。
    - 只要将查询子句传递给filter 参数（例如查询中的filter或must_not参数， bool查询中的filter参数 constant_score或filter聚合）， 过滤器上下文就会生效。

  [bfc5733a]: https://www.elastic.co/guide/en/elasticsearch/reference/current/query-filter-context.html "Query and filter context"

### [Full text queries][eb352537]
高级全文查询通常用于在全文字段（如电子邮件正文）上运行全文查询。他们了解如何分析被查询的字段，并在执行之前将每个字段 `analyzer`（或`search_analyzer`）应用于查询字符串。

该组中的查询是：
- `match` query
    - 用于执行全文查询的标准查询，包括模糊匹配和短语或邻近查询。
- `match_phrase` query
    - 与m`atch`查询类似，但用于匹配精确短语或单词邻近匹配。
- `match_phrase_prefix` query
    - 穷人的搜索就像你一样。像match_phrase查询一样，但是对最后一个单词进行通配符搜索。
    - The poor man’s search-as-you-type. Like the match_phrase query, but does a wildcard search on the final word.
- `multi_match` query
    - `match`查询 的多字段版本。
- `common terms` query
    - 一个更专业的查询，它更多地优先考虑不常见的单词。
- `query_string` query
    - 支持紧凑的Lucene 查询字符串语法，允许您在单个查询字符串中指定AND | OR | NOT条件和多字段搜索。仅限专家用户。
- `simple_query_string` query
    - 一种更简单，更健壮的query_string语法版本，适合直接向用户公开。
- `intervals` query
    - 全文查询，允许对匹配术语的排序和接近度进行细粒度控制

### [Term level queries][b5e8b3bd]
虽然`全文查询`将在执行之前分析查询字符串，但是`术语级查询`对存储在倒排索引中的确切术语进行操作，并且在仅对`keyword`具有`normalizer`属性的字段执行之前将规范化术语。

这些查询通常用于结构化数据，如数字，日期和枚举，而不是全文字段。或者，它们允许您在分析过程之前制作低级查询。

该组中的查询是：
- `term` query
    - 查找包含指定字段中指定的确切术语的文档。
- `terms` query
    - 查找包含指定字段中指定的任何确切术语的文档。
- `terms_set` query
    - 查找与一个或多个指定条款匹配的文档。必须匹配的术语数取决于指定的最小值应匹配字段或脚本。
- `range` query
    - 查找指定字段包含指定范围内的值（日期，数字或字符串）的文档。
- `exists` query
    - 查找指定字段包含任何非空值的文档。
- `prefix` query
    - 查找指定字段包含以指定的确切前缀开头的术语的文档。
- `wildcard` query
    - 查找指定字段包含与指定模式匹配的术语的文档，其中模式支持单字符通配符（?）和多字符通配符（*）
- `regexp` query
    - 查找指定字段包含与指定的正则表达式匹配的术语的文档 。
- `fuzzy` query
    - 查找指定字段包含与指定术语模糊相似的术语的文档。模糊度是以Levenshtein编辑距离 1或2 来衡量的 。
- `type` query
    - 查找指定类型的文档。
- `ids` query
    - 查找具有指定类型和ID的文档。

### [Compound queries][e7412599]
复合查询包装其他复合或叶子查询，以组合其结果和分数，更改其行为，或从查询切换到筛选器上下文。

该组中的查询是：
- `constant_score` query
    - 包含另一个查询但在过滤器上下文中执行的查询。所有匹配的文档都给出相同的“常量” _score。
- `bool` query
    - 用于组合多个叶或化合物查询子句，作为默认查询 `must`，`should`，`must_not`，或`filter`条款。在`must`和`should` 条款有他们的分数相结合-更匹配的条款，更好的-而`must_not`和`filter`条款在过滤器上下文中执行。
- `dis_max` query
    - 一个接受多个查询的查询，并返回与任何查询子句匹配的任何文档。虽然bool查询组合了所有匹配查询的分数，但dis_max查询使用单个最佳匹配查询子句的分数。
- `function_score` query
    - 使用函数修改主查询返回的分数，以考虑使用脚本实现的流行度，新近度，距离或自定义算法等因素。
- `boosting` query
    - 返回与positive查询匹配的文档，但减少与negative查询匹配的文档的分数。



### match match_all

### bool

#### must
#### should
#### filter
#### must_not


[1b942251]: https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-match-query.html "match"
[d337b3d6]: https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-term-query.html "term"
[87dde041]: https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-range-query.html "range"
[f4b417fe]: https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-bool-query.html "bool"
[05e86217]: https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-dis-max-query.html "dis_max"
[ba57b201]: https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-constant-score-query.html "constant_score"
[acde0464]: https://www.elastic.co/guide/en/elasticsearch/reference/current/query-filter-context.html "查询上下文还是过滤器上下文"

[eb352537]: https://www.elastic.co/guide/en/elasticsearch/reference/current/full-text-queries.html "Full text queries"

[b5e8b3bd]: https://www.elastic.co/guide/en/elasticsearch/reference/current/term-level-queries.html "Term level queries"
[e7412599]: https://www.elastic.co/guide/en/elasticsearch/reference/current/compound-queries.html "Compound queries"
