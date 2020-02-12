### spring-cloud-bus(Finchley 2.0.0)

> Spring Cloud Bus使用轻量级消息代理链接分布式系统的节点。然后，此代理可用于广播状态更改（例如配置更改）或其他管理指令。一个关键的想法是总线就像是一个扩展的Spring Boot应用程序的分布式执行器。但是，它也可以用作应用程序之间的通信通道。该项目为AMQP经纪人或Kafka提供启动作为运输。

#### 开始
> Spring Cloud Bus的工作原理是，如果它在类路径上检测到自身，则添加Spring Boot自动配置。

spring启用总线maven依赖有两种方式:
1. `spring-cloud-starter-bus-amqp`
2. `spring-cloud-starter-bus-kafka`

Spring Cloud负责其余部分。**确保代理（RabbitMQ或Kafka）可用且已配置。**

在localhost上运行时，无需执行任何操作，spring-cloud默认配置就可以。

如果服务器在远程运行，请使用Spring Cloud Connectors或Spring Boot约定来定义代理凭据，如以下Rabbit示例所示：
**application.yml.**
```yaml
spring:
  rabbitmq:
    host: mybroker.com
    port: 5672
    username: user
    password: secret
```

#### 刷新端点配置

- `/bus/refresh`

    网上很多都说使用`/bus/refresh`刷新配置，spring 官方文档有也提到这段:

    > The bus currently supports sending messages to all nodes listening or all nodes for a particular service (as defined by Eureka). The /bus/* actuator namespace has some HTTP endpoints. Currently, two are implemented. The first, /bus/env, sends key/value pairs to update each node’s Spring Environment. The second, /bus/refresh, reloads each application’s configuration, as though they had all been pinged on their /refresh endpoint.

    但是我自己配置的config server端启动时没有看到相应的就射。

    看意思像是使用到Eureka，我的项目暂时没有用到Eureka。

- `/actuator/bus-refresh`
    > Spring Cloud Bus provides two endpoints, /actuator/bus-refresh and /actuator/bus-env that correspond to individual actuator endpoints in Spring Cloud Commons, /actuator/refresh and /actuator/env respectively.

    该/actuator/bus-refresh端点清除RefreshScope缓存和重新绑定 @ConfigurationProperties。有关更多信息，请参见刷新范围文档。

    要公开/actuator/bus-refresh端点，您需要将以下配置添加到您的应用程序：
    ```properties
    management.endpoints.web.exposure.include = bus-refresh
    ```

#### 使用

- config-server端
    1. 添加maven依赖
        ```maven
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-bus-amqp</artifactId>
        </dependency>
        ```
    2. 配置rabbitMQ信息
        - **需要注意的地方**，spring官方文档是这么说的，如果rabbitMQ服务在本地则不需要配置相关信息，如果在远程服务器则需要配置
        ```yaml
        spring:
         rabbitmq:
          host: localhost
          port: 5672
          username: guest
          password: guest
        ```
- config-client端
    1. 添加maven依赖
        ```
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-bus-amqp</artifactId>
        </dependency>
        ```
    2. 在使用配置信息的类上加上`@RefreshScope`注解
- 修改相对应配置文件信息
- 访问`http://localhost:8090/actuator/bus-refresh`
- config-server输出:
    ```
    2018-12-18 14:23:15.508  INFO 5934 --- [nio-8090-exec-8] o.s.c.c.s.e.NativeEnvironmentRepository  : Adding property source: file:/Users/baozc/config-repo/hello.yml
    2018-12-18 14:23:15.509  INFO 5934 --- [nio-8090-exec-8] s.c.a.AnnotationConfigApplicationContext : Closing org.springframework.context.annotation.AnnotationConfigApplicationContext@3c5f61ff: startup date [Tue Dec 18 14:23:15 CST 2018]; root of context hierarchy
    2018-12-18 14:23:17.843  INFO 5934 --- [io-8090-exec-10] .c.s.e.MultipleJGitEnvironmentRepository : Cannot pull from remote null, the working tree is not clean.
    2018-12-18 14:23:17.993  INFO 5934 --- [io-8090-exec-10] s.c.a.AnnotationConfigApplicationContext : Refreshing org.springframework.context.annotation.AnnotationConfigApplicationContext@f458ea6: startup date [Tue Dec 18 14:23:17 CST 2018]; root of context hierarchy
    2018-12-18 14:23:18.025  INFO 5934 --- [io-8090-exec-10] s.c.a.AnnotationConfigApplicationContext : Closing org.springframework.context.annotation.AnnotationConfigApplicationContext@f458ea6: startup date [Tue Dec 18 14:23:17 CST 2018]; root of context hierarchy
    ```
- config-client输出:
    ```
    2018-12-18 14:23:14.836  INFO 6115 --- [LeZkA7rVnhvRg-1] s.c.a.AnnotationConfigApplicationContext : Refreshing org.springframework.context.annotation.AnnotationConfigApplicationContext@5ca35cdd: startup date [Tue Dec 18 14:23:14 CST 2018]; root of context hierarchy
    2018-12-18 14:23:15.113  INFO 6115 --- [LeZkA7rVnhvRg-1] trationDelegate$BeanPostProcessorChecker : Bean 'org.springframework.retry.annotation.RetryConfiguration' of type [org.springframework.retry.annotation.RetryConfiguration$$EnhancerBySpringCGLIB$$cdf36607] is not eligible for getting processed by all BeanPostProcessors (for example: not eligible for auto-proxying)
    2018-12-18 14:23:15.128  INFO 6115 --- [LeZkA7rVnhvRg-1] trationDelegate$BeanPostProcessorChecker : Bean 'configurationPropertiesRebinderAutoConfiguration' of type [org.springframework.cloud.autoconfigure.ConfigurationPropertiesRebinderAutoConfiguration$$EnhancerBySpringCGLIB$$f449d0df] is not eligible for getting processed by all BeanPostProcessors (for example: not eligible for auto-proxying)
    2018-12-18 14:23:15.406  INFO 6115 --- [LeZkA7rVnhvRg-1] c.c.c.ConfigServicePropertySourceLocator : Fetching config from server at : http://localhost:8090
    2018-12-18 14:23:15.516  INFO 6115 --- [LeZkA7rVnhvRg-1] c.c.c.ConfigServicePropertySourceLocator : Located environment: name=hello, profiles=[default], label=null, version=c2f22c61b86c3e81b26c9d52fcaaf0e6b40861aa, state=null
    2018-12-18 14:23:15.516  INFO 6115 --- [LeZkA7rVnhvRg-1] b.c.PropertySourceBootstrapConfiguration : Located property source: CompositePropertySource {name='configService', propertySources=[MapPropertySource {name='configClient'}, MapPropertySource {name='file:///Users/baozc/config-repo/hello.yml'}]}
    2018-12-18 14:23:15.520  INFO 6115 --- [LeZkA7rVnhvRg-1] o.s.b.SpringApplication                  : The following profiles are active: default
    2018-12-18 14:23:15.534  INFO 6115 --- [LeZkA7rVnhvRg-1] s.c.a.AnnotationConfigApplicationContext : Refreshing org.springframework.context.annotation.AnnotationConfigApplicationContext@212a15b5: startup date [Tue Dec 18 14:23:15 CST 2018]; parent: org.springframework.context.annotation.AnnotationConfigApplicationContext@5ca35cdd
    2018-12-18 14:23:15.601  INFO 6115 --- [LeZkA7rVnhvRg-1] o.s.b.SpringApplication                  : Started application in 1.02 seconds (JVM running for 34.11)
    2018-12-18 14:23:15.602  INFO 6115 --- [LeZkA7rVnhvRg-1] s.c.a.AnnotationConfigApplicationContext : Closing org.springframework.context.annotation.AnnotationConfigApplicationContext@212a15b5: startup date [Tue Dec 18 14:23:15 CST 2018]; parent: org.springframework.context.annotation.AnnotationConfigApplicationContext@5ca35cdd
    2018-12-18 14:23:15.605  INFO 6115 --- [LeZkA7rVnhvRg-1] s.c.a.AnnotationConfigApplicationContext : Closing org.springframework.context.annotation.AnnotationConfigApplicationContext@5ca35cdd: startup date [Tue Dec 18 14:23:14 CST 2018]; root of context hierarchy
    2018-12-18 14:23:16.967  INFO 6115 --- [LeZkA7rVnhvRg-1] o.s.c.b.e.RefreshListener                : Received remote refresh request. Keys refreshed []
    2018-12-18 14:23:17.137  INFO 6115 --- [LeZkA7rVnhvRg-1] o.s.a.r.c.CachingConnectionFactory       : Attempting to connect to: [localhost:5672]
    2018-12-18 14:23:17.625  INFO 6115 --- [LeZkA7rVnhvRg-1] o.s.a.r.c.CachingConnectionFactory       : Created new connection: rabbitConnectionFactory.publisher#7614366a:0/SimpleConnection@6b933bbe [delegate=amqp://guest@127.0.0.1:5672/, localPort= 51444]
    2018-12-18 14:23:17.642  INFO 6115 --- [LeZkA7rVnhvRg-1] o.s.a.r.c.RabbitAdmin                    : Auto-declaring a non-durable, auto-delete, or exclusive Queue (springCloudBus.anonymous.3XMXoaDrSLeZkA7rVnhvRg) durable:false, auto-delete:true, exclusive:true. It will be redeclared if the broker stops and is restarted while the connection factory is alive, but all messages will be lost.
    ```
- 访问config-client对应controller，会发现配置信息已经改变
