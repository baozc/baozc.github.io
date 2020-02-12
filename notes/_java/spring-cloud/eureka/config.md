### 一些常用的配置信息
```yaml
eureka:
  instance:
    hostname: localhost
  client:
    #表示是否将自己注册到Eureka Server上，默认为true，当前应用为Eureka Server所以无需注册
    register-with-eureka: false
    #表示是否从Eureka Server获取注册信息，默认为true。因为这是一个单点的Eureka Server，不需要同步其他的Eureka Server节点的数据，故而设为false。
    fetch-registry: false
    #Eureka Server的访问地址，服务注册和client获取服务注册信息均通过该URL，多个服务注册地址用,隔开
    serviceUrl:
      # eureka服务器的地址（注意：地址最后面的 /eureka/ 这个是固定值）
      defaultZone: http://${eureka.instance.hostname}:${server.port}/eureka
  server:
    enable-self-preservation: false # 关闭自我保护模式

# info自定义,读取pom文件中的内容
# 服务监控依赖于 spring-boot-starter-actuator 这个 jar
info:
  app:
    name: ${spring.application.name}
    hostname: ${eureka.instance.hostname}
    defaultZone: ${eureka.client.serviceUrl.defaultZone}

server:
  port: 8080

logging:
  config: classpath:dev.xml
spring:
  application:
    name: eureka-server
# 参考文档：http://projects.spring.io/spring-cloud/docs/1.0.3/spring-cloud.html#_standalone_mode
# 参考文档：http://my.oschina.net/buwei/blog/618756
```
