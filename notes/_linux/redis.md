## redis
>具体命令可以参考：[redis中文网][bd05e293]

### redis启动连接命令
- 启动redis服务 `src/redis-server`
    - 指定配置文件启动 `src/redis-server redis.conf`
- 客户端连接 `src/redis-cli`
    - 远程连接服务器 `src/redis-cli -h host -p port -a password`
    - 带密码登录，另一种方式 `redis-cli -h host -p port`
        ```
        //现在输入命令会提示有错
        127.0.0.1:7079> get name
        (error) NOAUTH Authentication required. //提示必须要完成认证

        //输入密码
        127.0.0.1:7079> auth password
        OK
        ```
  [bd05e293]: http://www.redis.net.cn/ "redis中文网"
