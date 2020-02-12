---
layout: post
categories: spring springcloud
name: eureka
tags: spring spring-cloud
# date: 2019-10-12 18:09:20 +0800
---
# eureka 几个概念需要了解的
- eureka 用于服务注册和发现
- 服务注册
    - “服务提供者” 在启动的时候会通过发送REST请求的方式将自己注册到`Eureka Server`上， 同时带上了自身服务的一些`元数据信息`。
    - `Eureka Server`接收到这个REST请求之后，将元数据信息存储在一个双层结构Map中， 其中第一层的key是服务名， 第二层的key是具体服务的实例名。
    - 元数据，访问 `http://eureka-server:port/eureka/apps` 可以查看
- 使用了 `Jersey` 框架实现自身的 RESTful HTTP接口
    ```
    By default, EurekaClient uses Jersey for HTTP communication. If you wish to avoid dependencies from Jersey, you can exclude it from your dependencies. Spring Cloud auto-configures a transport client based on Spring RestTemplate. The following example shows Jersey being excluded
    默认情况下，EurekaClient使用Jersey进行HTTP通信。如果您希望避免来自Jersey的依赖项，则可以将其从依赖项中排除。Spring Cloud基于Spring自动配置传输客户端RestTemplate。以下示例显示Jersey被排除在外：
    ```
- 内存缓存使用Google的guava包实现
- `restTemplate`加上`@LoadBalanced`注解，可以通过`http://服务名/接口名`的方式访问rest接口
- `Eureka Server` : 提供服务发现的能力,各服务启动时,会向Eureka Server注册自己的信息(IP,端口,服务信息等),Eureka Server会存储这些信息.
- `Eureka Client` : 服务提供者,简化与`Eureka Server`的交互.
- 微服务启动后,会周期性(默认30秒)的向`Eureka Server`发送心跳以续约自己的”租期”.
- 如果`Eureka Server`在一定时间内没有收到某个微服务实例(Eureka Client)的心跳,Eureka Server将会注销该实例(默认90秒).
- 默认请求下,`Eureka Server`同时也是Eureka Client.多个Eureka Server实例,互相之间通过复制的方式,来实现服务注册表中的数据.(实现集群,高可用)
- `Eureka Client`会缓存注册表中的信息.这种方式有一定的优势
    - `Eureka Client`会缓存注册表中的信息.这种方式有一定的优势
    - 其次,即使`Eureka Server`所有节点都宕掉,服务消费者依然可以使用缓存中的信息找到服务提供者并完成调用.
    - 这样,Eureka通过心跳检测,客户端缓存等机制,提高了系统的灵活性,可伸缩性和可用性.

## Eureka的元数据有两种
1. 标准元数据
    1. 指的是主机名,IP地址,端口号,状态页和健康检查等信息,这些信息都会被发布在注册表中,用于服务之间的调用
2. 自定义元数据
    1. 可以使用`eureka.instance.metadata-map`进行配置,这些元数据可以在远程客户端中访问,但不会改变客户端行为.

## 自定义元数据示例
在原来Eureka Client上进行测试
application.yml新增如下配置
```yaml
eureka:
  # ... ...
  instance:
    metadata-map:
      # 自定义元数据,key/value自行定义
      order-id: 自定义元数据
```

## 打印元数据
```java
@Autowired
private DiscoveryClient discoveryClient;
@Autowired
private Registration    registration;

// LogUtils是我自己封装的日志类,其实就是LogManager.getLogger(),另外我用的是log4j2
@GetMapping( "metadata" )
public void testMetadata () {
    final List< ServiceInstance > instances = discoveryClient.getInstances( registration.getServiceId() );
    instances.forEach( service -> LogUtils.getLogger().info(
                                                  "host:{}, service_id:{},metadata:{}",
                                                  service.getHost(),
                                                  service.getServiceId(),
                                                  service.getMetadata()
                                          ) );
    return;
}
```

## eureka client

### Using the EurekaClient
Once you have an application that is a discovery client, you can use it to discover service instances from the `Eureka Server`. One way to do so is to use the native `com.netflix.discovery.EurekaClient` (as opposed to the Spring Cloud `DiscoveryClient`), as shown in the following example:
```java
@Autowired
private EurekaClient discoveryClient;

public String serviceUrl() {
    InstanceInfo instance = discoveryClient.getNextServerFromEureka("STORES", false);
    return instance.getHomePageUrl();
}
```

### Alternatives to the Native Netflix EurekaClient
You need not use the raw Netflix `EurekaClient`. Also, it is usually more convenient to use it behind a wrapper of some sort. Spring Cloud has support for `Feign` (a REST client builder) and `Spring RestTemplate` through the logical Eureka service identifiers (VIPs) instead of physical URLs. To configure Ribbon with a fixed list of physical servers, you can set `<client>.ribbon.listOfServers` to a comma-separated list of physical addresses (or hostnames), where <client> is the ID of the client.

You can also use the `org.springframework.cloud.client.discovery.DiscoveryClient`, which provides a simple API (not specific to Netflix) for discovery clients, as shown in the following example:
```java
@Autowired
private DiscoveryClient discoveryClient;

public String serviceUrl() {
    List<ServiceInstance> list = discoveryClient.getInstances("STORES");
    if (list != null && list.size() > 0 ) {
        return list.get(0).getUri();
    }
    return null;
}
```
