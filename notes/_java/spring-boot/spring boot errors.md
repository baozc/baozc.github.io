## ** WARNING ** : Your ApplicationContext is unlikely to start due to a @ComponentScan of the default package.
>运行run方法的类，需要建立一个包，不能在src/main/java下


## java.lang.NoClassDefFoundError: org/springframework/core/ErrorCoded
```java
RROR StatusLogger Log4j2 could not find a logging implementation. Please add log4j-core to the classpath. Using SimpleLogger to log to the console...
ERROR SpringApplication Application startup failed
 java.lang.NoClassDefFoundError: org/springframework/core/ErrorCoded
	at java.lang.ClassLoader.defineClass1(Native Method)
	at java.lang.ClassLoader.defineClass(ClassLoader.java:763)
	at java.security.SecureClassLoader.defineClass(SecureClassLoader.java:142)
	at java.net.URLClassLoader.defineClass(URLClassLoader.java:467)
	at java.net.URLClassLoader.access$100(URLClassLoader.java:73)
	at java.net.URLClassLoader$1.run(URLClassLoader.java:368)
	at java.net.URLClassLoader$1.run(URLClassLoader.java:362)
	at java.security.AccessController.doPrivileged(Native Method)
	at java.net.URLClassLoader.findClass(URLClassLoader.java:361)
	at java.lang.ClassLoader.loadClass(ClassLoader.java:424)
	at sun.misc.Launcher$AppClassLoader.loadClass(Launcher.java:335)
	at java.lang.ClassLoader.loadClass(ClassLoader.java:357)
	at java.lang.ClassLoader.defineClass1(Native Method)
	at java.lang.ClassLoader.defineClass(ClassLoader.java:763)
	at java.security.SecureClassLoader.defineClass(SecureClassLoader.java:142)
	at java.net.URLClassLoader.defineClass(URLClassLoader.java:467)
	at java.net.URLClassLoader.access$100(URLClassLoader.java:73)
	at java.net.URLClassLoader$1.run(URLClassLoader.java:368)
	at java.net.URLClassLoader$1.run(URLClassLoader.java:362)
	at java.security.AccessController.doPrivileged(Native Method)
	at java.net.URLClassLoader.findClass(URLClassLoader.java:361)
	at java.lang.ClassLoader.loadClass(ClassLoader.java:424)
	at sun.misc.Launcher$AppClassLoader.loadClass(Launcher.java:335)
	at java.lang.ClassLoader.loadClass(ClassLoader.java:357)
	at java.lang.ClassLoader.defineClass1(Native Method)
	at java.lang.ClassLoader.defineClass(ClassLoader.java:763)
	at java.security.SecureClassLoader.defineClass(SecureClassLoader.java:142)
	at java.net.URLClassLoader.defineClass(URLClassLoader.java:467)
	at java.net.URLClassLoader.access$100(URLClassLoader.java:73)
	at java.net.URLClassLoader$1.run(URLClassLoader.java:368)
	at java.net.URLClassLoader$1.run(URLClassLoader.java:362)
	at java.security.AccessController.doPrivileged(Native Method)
	at java.net.URLClassLoader.findClass(URLClassLoader.java:361)
	at java.lang.ClassLoader.loadClass(ClassLoader.java:424)
	at sun.misc.Launcher$AppClassLoader.loadClass(Launcher.java:335)
	at java.lang.ClassLoader.loadClass(ClassLoader.java:357)
	at org.springframework.boot.context.properties.bind.convert.PropertyEditorConverter.<init>(PropertyEditorConverter.java:55)
	at org.springframework.boot.context.properties.bind.convert.BinderConversionService.createAdditionalConversionService(BinderConversionService.java:109)
	at org.springframework.boot.context.properties.bind.convert.BinderConversionService.<init>(BinderConversionService.java:52)
	at org.springframework.boot.context.properties.bind.Binder.<init>(Binder.java:115)
	at org.springframework.boot.context.properties.bind.Binder.<init>(Binder.java:99)
	at org.springframework.boot.context.properties.bind.Binder.get(Binder.java:354)
	at org.springframework.boot.context.config.AnsiOutputApplicationListener.onApplicationEvent(AnsiOutputApplicationListener.java:42)
	at org.springframework.boot.context.config.AnsiOutputApplicationListener.onApplicationEvent(AnsiOutputApplicationListener.java:36)
	at org.springframework.context.event.SimpleApplicationEventMulticaster.invokeListener(SimpleApplicationEventMulticaster.java:167)
	at org.springframework.context.event.SimpleApplicationEventMulticaster.multicastEvent(SimpleApplicationEventMulticaster.java:139)
	at org.springframework.context.event.SimpleApplicationEventMulticaster.multicastEvent(SimpleApplicationEventMulticaster.java:122)
	at org.springframework.boot.context.event.EventPublishingRunListener.environmentPrepared(EventPublishingRunListener.java:73)
	at org.springframework.boot.SpringApplicationRunListeners.environmentPrepared(SpringApplicationRunListeners.java:54)
	at org.springframework.boot.SpringApplication.prepareEnvironment(SpringApplication.java:350)
	at org.springframework.boot.SpringApplication.run(SpringApplication.java:317)
	at org.springframework.boot.SpringApplication.run(SpringApplication.java:1245)
	at org.springframework.boot.SpringApplication.run(SpringApplication.java:1233)
	at bao.Example.main(Example.java:25)
Caused by: java.lang.ClassNotFoundException: org.springframework.core.ErrorCoded
	at java.net.URLClassLoader.findClass(URLClassLoader.java:381)
	at java.lang.ClassLoader.loadClass(ClassLoader.java:424)
	at sun.misc.Launcher$AppClassLoader.loadClass(Launcher.java:335)
	at java.lang.ClassLoader.loadClass(ClassLoader.java:357)
	... 54 more
  ```
  >这个错误是因为在pom.xml中使用`dependencyManagement`覆盖了tomcat的依赖，如下

```xml
<dependencyManagement>
		<dependencies>
			<dependency>
				<groupId>org.springframework.boot</groupId>
				<artifactId>spring-boot-starter-tomcat</artifactId>
				<version>1.5.2.RELEASE</version>
				<type>pom</type>
				<scope>import</scope>
			</dependency>
		</dependencies>
	</dependencyManagement>
```
