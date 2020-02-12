### 出错信息：KeeperException$UnimplementedException: KeeperErrorCode = Unimplemented for /services/server/def07189-5ef0-4fec-98c5-ad0f4b750f26
```
java.lang.reflect.UndeclaredThrowableException: null
	at org.springframework.util.ReflectionUtils.rethrowRuntimeException(ReflectionUtils.java:327) ~[spring-core-5.0.5.RELEASE.jar:5.0.5.RELEASE]
	at org.springframework.cloud.zookeeper.serviceregistry.ZookeeperServiceRegistry.register(ZookeeperServiceRegistry.java:69) ~[spring-cloud-zookeeper-discovery-2.0.0.RELEASE.jar:2.0.0.RELEASE]
	at org.springframework.cloud.zookeeper.serviceregistry.ZookeeperServiceRegistry.register(ZookeeperServiceRegistry.java:39) ~[spring-cloud-zookeeper-discovery-2.0.0.RELEASE.jar:2.0.0.RELEASE]
	at org.springframework.cloud.client.serviceregistry.AbstractAutoServiceRegistration.register(AbstractAutoServiceRegistration.java:209) ~[spring-cloud-commons-2.0.0.RELEASE.jar:2.0.0.RELEASE]
	at org.springframework.cloud.zookeeper.serviceregistry.ZookeeperAutoServiceRegistration.register(ZookeeperAutoServiceRegistration.java:76) ~[spring-cloud-zookeeper-discovery-2.0.0.RELEASE.jar:2.0.0.RELEASE]
	at org.springframework.cloud.client.serviceregistry.AbstractAutoServiceRegistration.start(AbstractAutoServiceRegistration.java:108) ~[spring-cloud-commons-2.0.0.RELEASE.jar:2.0.0.RELEASE]
	at org.springframework.cloud.client.serviceregistry.AbstractAutoServiceRegistration.bind(AbstractAutoServiceRegistration.java:73) ~[spring-cloud-commons-2.0.0.RELEASE.jar:2.0.0.RELEASE]
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method) ~[?:1.8.0_171]
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62) ~[?:1.8.0_171]
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43) ~[?:1.8.0_171]
	at java.lang.reflect.Method.invoke(Method.java:498) ~[?:1.8.0_171]
	at org.springframework.context.event.ApplicationListenerMethodAdapter.doInvoke(ApplicationListenerMethodAdapter.java:264) ~[spring-context-5.0.5.RELEASE.jar:5.0.5.RELEASE]
	at org.springframework.context.event.ApplicationListenerMethodAdapter.processEvent(ApplicationListenerMethodAdapter.java:182) ~[spring-context-5.0.5.RELEASE.jar:5.0.5.RELEASE]
	at org.springframework.context.event.ApplicationListenerMethodAdapter.onApplicationEvent(ApplicationListenerMethodAdapter.java:144) ~[spring-context-5.0.5.RELEASE.jar:5.0.5.RELEASE]
	at org.springframework.context.event.SimpleApplicationEventMulticaster.doInvokeListener(SimpleApplicationEventMulticaster.java:172) ~[spring-context-5.0.5.RELEASE.jar:5.0.5.RELEASE]
	at org.springframework.context.event.SimpleApplicationEventMulticaster.invokeListener(SimpleApplicationEventMulticaster.java:165) ~[spring-context-5.0.5.RELEASE.jar:5.0.5.RELEASE]
	at org.springframework.context.event.SimpleApplicationEventMulticaster.multicastEvent(SimpleApplicationEventMulticaster.java:139) ~[spring-context-5.0.5.RELEASE.jar:5.0.5.RELEASE]
	at org.springframework.context.support.AbstractApplicationContext.publishEvent(AbstractApplicationContext.java:400) ~[spring-context-5.0.5.RELEASE.jar:5.0.5.RELEASE]
	at org.springframework.context.support.AbstractApplicationContext.publishEvent(AbstractApplicationContext.java:354) ~[spring-context-5.0.5.RELEASE.jar:5.0.5.RELEASE]
	at org.springframework.boot.web.servlet.context.ServletWebServerApplicationContext.finishRefresh(ServletWebServerApplicationContext.java:164) ~[spring-boot-2.0.1.RELEASE.jar:2.0.1.RELEASE]
	at org.springframework.context.support.AbstractApplicationContext.refresh(AbstractApplicationContext.java:553) ~[spring-context-5.0.5.RELEASE.jar:5.0.5.RELEASE]
	at org.springframework.boot.web.servlet.context.ServletWebServerApplicationContext.refresh(ServletWebServerApplicationContext.java:140) ~[spring-boot-2.0.1.RELEASE.jar:2.0.1.RELEASE]
	at org.springframework.boot.SpringApplication.refresh(SpringApplication.java:759) [spring-boot-2.0.1.RELEASE.jar:2.0.1.RELEASE]
	at org.springframework.boot.SpringApplication.refreshContext(SpringApplication.java:395) [spring-boot-2.0.1.RELEASE.jar:2.0.1.RELEASE]
	at org.springframework.boot.SpringApplication.run(SpringApplication.java:327) [spring-boot-2.0.1.RELEASE.jar:2.0.1.RELEASE]
	at org.springframework.boot.SpringApplication.run(SpringApplication.java:1255) [spring-boot-2.0.1.RELEASE.jar:2.0.1.RELEASE]
	at org.springframework.boot.SpringApplication.run(SpringApplication.java:1243) [spring-boot-2.0.1.RELEASE.jar:2.0.1.RELEASE]
	at com.server.ZkServerApplication.main(ZkServerApplication.java:16) [classes/:?]
Caused by: org.apache.zookeeper.KeeperException$UnimplementedException: KeeperErrorCode = Unimplemented for /services/server/def07189-5ef0-4fec-98c5-ad0f4b750f26
	at org.apache.zookeeper.KeeperException.create(KeeperException.java:103) ~[zookeeper-3.5.3-beta.jar:3.5.3-beta-8ce24f9e675cbefffb8f21a47e06b42864475a60]
	at org.apache.zookeeper.KeeperException.create(KeeperException.java:51) ~[zookeeper-3.5.3-beta.jar:3.5.3-beta-8ce24f9e675cbefffb8f21a47e06b42864475a60]
	at org.apache.zookeeper.ZooKeeper.create(ZooKeeper.java:1525) ~[zookeeper-3.5.3-beta.jar:3.5.3-beta-8ce24f9e675cbefffb8f21a47e06b42864475a60]
	at org.apache.curator.framework.imps.CreateBuilderImpl$17.call(CreateBuilderImpl.java:1181) ~[curator-framework-4.0.1.jar:4.0.1]
	at org.apache.curator.framework.imps.CreateBuilderImpl$17.call(CreateBuilderImpl.java:1158) ~[curator-framework-4.0.1.jar:4.0.1]
	at org.apache.curator.connection.StandardConnectionHandlingPolicy.callWithRetry(StandardConnectionHandlingPolicy.java:64) ~[curator-client-4.0.1.jar:?]
	at org.apache.curator.RetryLoop.callWithRetry(RetryLoop.java:100) ~[curator-client-4.0.1.jar:?]
	at org.apache.curator.framework.imps.CreateBuilderImpl.pathInForeground(CreateBuilderImpl.java:1155) ~[curator-framework-4.0.1.jar:4.0.1]
	at org.apache.curator.framework.imps.CreateBuilderImpl.protectedPathInForeground(CreateBuilderImpl.java:605) ~[curator-framework-4.0.1.jar:4.0.1]
	at org.apache.curator.framework.imps.CreateBuilderImpl.forPath(CreateBuilderImpl.java:595) ~[curator-framework-4.0.1.jar:4.0.1]
	at org.apache.curator.framework.imps.CreateBuilderImpl.forPath(CreateBuilderImpl.java:49) ~[curator-framework-4.0.1.jar:4.0.1]
	at org.apache.curator.x.discovery.details.ServiceDiscoveryImpl.internalRegisterService(ServiceDiscoveryImpl.java:236) ~[curator-x-discovery-4.0.0.jar:?]
	at org.apache.curator.x.discovery.details.ServiceDiscoveryImpl.registerService(ServiceDiscoveryImpl.java:191) ~[curator-x-discovery-4.0.0.jar:?]
	at org.springframework.cloud.zookeeper.serviceregistry.ZookeeperServiceRegistry.register(ZookeeperServiceRegistry.java:67) ~[spring-cloud-zookeeper-discovery-2.0.0.RELEASE.jar:2.0.0.RELEASE]
	... 26 more
```

### 问题分析
`UnimplementedException` 的描述是 `Operation is unimplemented`，`即该操作未实现异常`。

Google 查询得知，是因为jar包兼容版本的问题
当前使用版本，
- spring cloud : Finchley.RELEASE
- spring-cloud-starter-zookeeper-discovery: 2.0.0
- curator-x-discovery : 4.0.1
- zookeeper服务器版本: 3.4.13

#### Apache Curator对ZooKeeper版本兼容性

```
使用curator的版本必须匹配服务器上安装zookeeper的版本，本人使用的是zookeeper的最新稳定版3.4.9（最新不稳定版是3.5.X），
所以curator不能使用最新版本，否则创建节点时就会报
org.apache.zookeeper.KeeperException$UnimplementedException: KeeperErrorCode = Unimplemented for /curator/test01 错误。
官方上有这段话：

Versions
The are currently two released versions of Curator, 2.x.x and 3.x.x:

Curator 2.x.x - compatible with both ZooKeeper 3.4.x and ZooKeeper 3.5.x
Curator 3.x.x - compatible only with ZooKeeper 3.5.x and includes support for new features such as dynamic reconfiguration, etc.
```

可以确定，问题根源是`Curator的3.3.0版本和ZooKeeper的3.5.1-alpha版本不匹配ZooKeeper服务器的3.4.9版本`。

### 解决方案
- 将 ZooKeeper 服务器升到 zookeeper-3.5.x
- 或者将 Curator 版本升级者降到2.x.x
