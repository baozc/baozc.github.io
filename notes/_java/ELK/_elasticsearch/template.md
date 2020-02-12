- 每个索引都有对应的模板
- 可以在创建索引时指定模板
- 模板分为动态和静态模板
- `dynamic_template` 是一个示例

### 模板
> 索引模板允许您定义在创建新索引时自动应用的模板。模板包括 设置和映射 以及控制是否应将模板应用于新索引的简单模式模板。
> 模板仅在索引创建时应用。更改模板不会对现有索引产生影响。使用create index API时，作为create index调用的一部分定义的设置/映射将优先于模板中定义的任何匹配的设置/映射。



[索引模板官方文档](https://www.elastic.co/guide/en/elasticsearch/reference/6.6/indices-templates.html)
[template网上参考文档1](https://elasticsearch.cn/article/335)
[template网上参考文档2](https://www.jianshu.com/p/1f67e4436c37)
