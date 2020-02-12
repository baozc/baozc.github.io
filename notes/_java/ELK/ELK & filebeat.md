# ELK + filebeat

Elasticsearch + Logstash + Kibana（ELK）是一套开源的日志管理方案

- Elasticsearch：负责日志检索和分析
    - ElasticSearch是一个基于Lucene的搜索服务器。它提供了一个分布式多用户能力的全文搜索引擎，基于RESTful web接口。Elasticsearch是用Java开发的，并作为Apache许可条款下的开放源码发布，是当前流行的企业级搜索引擎。设计用于云计算中，能够达到实时搜索，稳定，可靠，快速，安装使用方便。
- Logstash：负责日志的收集，处理和储存
- Kibana：负责日志的可视化
    - Kibana是一个优秀的前端日志展示框架，它可以非常详细的将日志转化为各种图表，为用户提供强大的数据可视化支持。

## ELK优势

1. 强大的搜索功能，elasticsearch可以以分布式搜索的方式快速检索，而且支持DSL的语法来进行搜索，简单的说，就是通过类似配置的语言，快速筛选数据。
2. 完美的展示功能，可以展示非常详细的图表信息，而且可以定制展示内容，将数据可视化发挥的淋漓尽致。
3. 分布式功能，能够解决大型集群运维工作很多问题，包括监控、预警、日志收集解析等。

## ELK能做什么

ELK组件在海量日志系统的运维中，可用于解决：
- 分布式日志数据集中式查询和管理
- 系统监控，包含系统硬件和应用各个组件的监控
- 故障排查
- 安全信息和事件管理
- 报表功能

ELK组件在大数据运维系统中，主要可解决的问题如下：
- 日志查询，问题排查，上线检查
- 服务器监控，应用监控，错误报警，Bug管理
- 性能分析，用户行为分析，安全漏洞分析，时间管理

[ELK 官网](https://www.elastic.co/cn/)

## beats

> Beats 是数据采集的得力工具。将 Beats 和您的容器一起置于服务器上，或者将 Beats 作为函数加以部署，然后便可在 Elastisearch 中集中处理数据。如果需要更加强大的处理性能，Beats 还能将数据输送到 Logstash 进行转换和解析。

**filebeat相当于beats的一种实现方式，用于采集文件中的日志。**

### filebeat 轻量型日志采集器

> 输送至 Elasticsearch 或 Logstash。在 Kibana 中实现可视化。
> Filebeat 是 Elastic Stack 的一部分，因此能够与 Logstash、Elasticsearch 和 Kibana 无缝协作。无论您要使用 Logstash 转换或充实日志和文件，还是在 Elasticsearch 中随意处理一些数据分析，亦或在 Kibana 中构建和分享仪表板，Filebeat 都能轻松地将您的数据发送至最关键的地方。

[相关参考][1203adc8]

  [1203adc8]: https://www.elastic.co/cn/products/beats/filebeat "filebeat"
