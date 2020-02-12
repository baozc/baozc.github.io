# logstash 配置文件
Logstash有两种类型的配置文件：管道配置文件，用于定义Logstash处理管道;以及设置文件，用于指定控制Logstash启动和执行的选项。

## pipeline configuration files
在定义Logstash处理管道的各个阶段时，可以创建管道配置文件。在deb和rpm上，将管道配置文件放在/etc/logstash/conf.d目录中。Logstash尝试仅加载具有.conf扩展名的文件，/etc/logstash/conf.d directory并忽略所有其他文件。

## settins files
设置文件已在Logstash安装中定义。Logstash包括以下设置文件：
- `logstash.yml`
    - 包含Logstash配置标志。您可以在此文件中设置标志，而不是在命令行传递标志。您在命令行中设置的任何标志都会覆盖logstash.yml文件中的相应设置。有关详细信息，请参阅logstash.yml。
    - 管道、队列（持久、memory）等配置信息
- `pipelines.yml`
    - 包含在单个Logstash实例中运行多个管道的框架和说明。有关详细信息，请参阅多个管道。
- `jvm.options`
    - 包含JVM配置标志。使用此文件设置总堆空间的初始值和最大值。您还可以使用此文件为Logstash设置区域设置。在单独的行上指定每个标志。此文件中的所有其他设置均被视为专家设置。
- `log4j2.properties`
    - 包含log4j 2库的默认设置。有关详细信息，请参阅Log4j2配置。
- `startup.options ` （Linux）的
    - 包含使用的选项system-install在脚本中/usr/share/logstash/bin建立相应的启动脚本为您的系统。安装Logstash软件包时，system-install脚本将在安装过程结束时执行，并使用指定的设置startup.options来设置用户，组，服务名称和服务描述等选项。默认情况下，Logstash服务安装在用户下logstash。该startup.options文件使您可以更轻松地安装Logstash服务的多个实例。您可以复制文件并更改特定设置的值。请注意，startup.options启动时不会读取该文件。如果要更改Logstash启动脚本（例如，更改Logstash用户或从其他配置路径读取），则必须重新运行system-install 脚本（以root身份）传递新设置。

[参考文档](https://segmentfault.com/a/1190000016591476)
