## eureka
- 自我保护，剔除
    ```
    EvictionTask
    Running the evict task with compensationTime {}ms
    ```
- `Network level connection to peer localhost; retrying after delay`
  - https://cloud.tencent.com/developer/article/1379852
- 一个实例注册时，全有两条注册日志，replication=true/false
  ```
  [2019-09-29 17:51:24.131] INFO [http-nio-8081-exec-2] AbstractInstanceRegistry.java:266 - Registered instance BASE-CONFIG/base-config-192.168.10.187:8082 with status UP (replication=false)
  [2019-09-29 17:51:25.000] INFO [http-nio-8081-exec-3] AbstractInstanceRegistry.java:266 - Registered instance BASE-CONFIG/base-config-192.168.10.187:8082 with status UP (replication=true)
  [2019-09-29 17:52:08.063] INFO [Eureka-EvictionTimer] AbstractInstanceRegistry.java:1250 - Running the evict task with compensationTime 0ms
    ```
