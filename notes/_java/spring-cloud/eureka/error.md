### 当eureka server 的application.name=server时，会报如下异常
```
Error starting ApplicationContext. To display the conditions report re-run your application with 'debug' enabled.
2019-03-14 09:33:50.658 ERROR 1 --- [.15t] o.s.b.SpringApplication                  [ortFailure:842 ] : Application run failed

org.springframework.beans.factory.BeanDefinitionStoreException: Failed to process import candidates for configuration class [com.server.EurekaServerApplication]; nested exception is java.lang.IllegalStateException: Error processing condition on org.springframework.boot.actuate.autoconfigure.web.server.ManagementContextAutoConfiguration$DifferentManagementContextConfiguration
at org.springframework.context.annotation.ConfigurationClassParser.processImports(ConfigurationClassParser.java:645) ~[spring-context-5.0.5.RELEASE.jar!/:5.0.5.RELEASE]
at org.springframework.context.annotation.ConfigurationClassParser.lambda$processDeferredImportSelectors$2(ConfigurationClassParser.java:564) ~[spring-context-5.0.5.RELEASE.jar!/:5.0.5.RELEASE]
Caused by: org.springframework.core.convert.ConversionFailedException: Failed to convert from type [java.lang.String] to type [java.lang.Integer] for value 'tcp://10.254.228.61:8080'; nested exception is java.lang.NumberFormatException: For input string: "tcp://10.254.228.61:8080"
at org.springframework.core.convert.support.ConversionUtils.invokeConverter(ConversionUtils.java:46) ~[spring-core-5.0.5.RELEASE.jar!/:5.0.5.RELEASE]
at org.springframework.core.convert.support.GenericConversionService.convert(GenericConversionService.java:191) ~[spring-core-5.0.5.RELEASE.jar!/:5.0.5.RELEASE]
at org.springframework.core.convert.support.GenericConversionService.convert(GenericConversionService.java:174) ~[spring-core-5.0.5.RELEASE.jar!/:5.0.5.RELEASE]
at org.springframework.core.env.Abst
```

可能的原因：`spring boot`获取`${server.port}`时，会获取到`tcp://10.254.228.61:8080`，所以导致该异常
解决方案：`server.port` 通过外部环境变量传递过来，或者不使用`server.port`
