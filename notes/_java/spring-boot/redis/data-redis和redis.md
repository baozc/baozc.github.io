---
layout: post
name: data-redis和redis
position: Developer
# date: 2019-10-10 18:09:20
tag: redis
category: redis
---

# 区别与关系
- jedis
> [jedis](https://github.com/xetorthio/jedis)是redis的java客户端，通过它可以对redis进行操作。与之功能相似的还包括：[Lettuce](https://github.com/lettuce-io/lettuce-core/)等

- sprint-boot-strater-data-redis
> 它依赖jedis或Lettuce，实际上是对jedis这些客户端的封装，提供一套与客户端无关的api供应用使用，从而你在从一个redis客户端切换为另一个客户端，不需要修改业务代码。

## spring boot 整合data redis （默认依赖Lettuce）
> spring-boot-data-redis 内部实现了对Lettuce和jedis两个客户端的封装，默认使用的是Lettuce

- pom.xml

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>
```
- 查看redis-starter使用的客户端

```java
@RunWith(SpringRunner.class)
@SpringBootTest(classes = NoticeApplication.class)
public class RedisLockTest {

    private Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    StringRedisTemplate redisTemplate;

    @Test
    public void selectCon() {
        logger.info("redis template connection factory: {}", redisTemplate.getConnectionFactory());
    }
}
```
- 日志输出

```
2019-08-01 15:14:42.239  INFO --- [                                    main] com.jd.notice.RedisLockTest                                                  : redis template connection factory: org.springframework.data.redis.connection.lettuce.LettuceConnectionFactory@62417a16
```
**可以看到使用的是Lettuce**

## spring boot 整合data redis （jedis）

- 修改pom.xml

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
    <exclusions>
        <exclusion>
            <artifactId>lettuce-core</artifactId>
            <groupId>io.lettuce</groupId>
        </exclusion>
    </exclusions>
</dependency>
<dependency>
    <groupId>redis.clients</groupId>
    <artifactId>jedis</artifactId>
</dependency>
```
- 两次输出日志

```
2019-08-01 15:14:42.239  INFO --- [                                    main] com.jidian.notice.RedisLockTest                                                  : redis template connection factory: org.springframework.data.redis.connection.jedis.JedisConnectionFactory@4aeaff64
```

**从输出的工厂类为JedisConnectionFactory我们就可以看出，redis客户端已经变为jedis**
