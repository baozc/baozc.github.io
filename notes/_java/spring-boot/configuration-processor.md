`Spring Boot Annotion processor not found in classpath`需要引用下述jar包

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-configuration-processor</artifactId>
    <optional>true</optional>
</dependency>
```

引用这个依赖，官方中对于spring-boot-configuration-processor是这么说明的：
通过使用spring-boot-configuration-processor jar， 你可以从被@ConfigurationProperties注解的节点轻松的产生自己的配置元数据文件。
说得很清楚，自定义的元数据文件使用注解方式获取，需要先引入这个依赖。
