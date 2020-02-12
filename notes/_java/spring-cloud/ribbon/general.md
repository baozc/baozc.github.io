## 客户端负载均衡 ribbon
> 对于大型应用系统负载均衡(LB:Load Balancing)是首要被解决一个问题。在微服务之前LB方案主要是集中式负载均衡方案，在服务消费者和服务提供者之间又一个独立的LB，LB通常是专门的硬件，如F5，或者是基于软件的，如VS、HAproxy等。LB上有所有服务的地址映射表，当服务消费者调用某个目标服务时，它先向LB发起请求，由LB以某种策略（比如：Round-Robin）做负载均衡后将请求转发到目标服务。
>
> 而微服务的出现，则为LB的实现提供了另外一种思路：把LB的功能以库的方式集成到服务消费方的进程内，而不是由一个集中的设备或服务器提供。这种方案称为软负载均衡（Soft Load Balancing）或者客户端负载均衡。在Spring Cloud中配合Eureka的服务注册功能，Ribbon子项目则为REST客户端实现了负载均衡。

### 使用
- `eureka` `zookeeper-client` `feign`都默认依赖了`ribbon`

#### restTemplate
添加`@loadBalance`注解，该注解就是能够让`RestTemplate`启用客户端负载均衡。
```java
@Bean
@LoadBalanced
RestTemplate restTemplate() {
    return new RestTemplate();
}

@Autowired
RestTemplate restTemplate;

@GetMapping("getHello")
public String getHello(){
    return restTemplate.getForEntity("http://server/hello", String.class).getBody();
}
```

#### 直接使用Ribbon的API
另外，除了使用`@LoadBalanced`注解外，我们还可以直接使用`Ribbon`所提供的`LoadBalancerClient`来实现负载均衡：
```java
@Autowired
LoadBalancerClient loadBalancerClient;

@GetMapping("getHelloEx")
public String getHelloEx(){
   ServiceInstance instance = this.loadBalancerClient.choose("server");
   logger.info("instance host: {}, port:{}", instance.getHost(), instance.getPort());
   URI helloUri = URI.create(String.format("http://%s:%s/hello", instance.getHost(), instance.getPort()));
   logger.info("Target service uri = {}. ", helloUri.toString());
   return new RestTemplate().getForEntity(helloUri, String.class).getBody();
}
```

**注意：在`helloEx`方法中不能够使用之前自动织入的`restTemplate`，否则会报以下错误:**
```
java.lang.IllegalStateException: No instances available for cd826dembp.lan
```
这个是因为自动织入的`restTemplate`会把服务器的逻辑名称当作服务名称来使用，造成找不到相应的服务实例，从而报错。

### Ribbon负载均衡策略
- `RoundRobinRule`: 轮询策略，`Ribbon`以轮询的方式选择服务器，这个是**默认值**。所以示例中所启动的两个服务会被循环访问;
- `RandomRule`: 随机选择，也就是说`Ribbon`会随机从服务器列表中选择一个进行访问;
- `BestAvailableRule`: 最大可用策略，即先过滤出故障服务器后，选择一个当前并发请求数最小的;
- `WeightedResponseTimeRule`: 带有加权的轮询策略，对各个服务器响应时间进行加权处理，然后在采用轮询的方式来获取相应的服务器;
- `AvailabilityFilteringRule`: 可用过滤策略，先过滤出故障的或并发请求大于阈值一部分服务实例，然后再以线性轮询的方式从过滤后的实例清单中选出一个;
- `ZoneAvoidanceRule`: 区域感知策略，先使用主过滤条件（区域负载器，选择最优区域）对所有实例过滤并返回过滤后的实例清单，依次使用次过滤条件列表中的过滤条件对主过滤条件的结果进行过滤，判断最小过滤数（默认1）和最小过滤百分比（默认0），最后对满足条件的服务器则使用RoundRobinRule(轮询方式)选择一个服务器实例。
