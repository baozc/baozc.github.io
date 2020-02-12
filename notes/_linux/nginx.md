## nginx

>  linux下安装nginx，参考博客： [linux下安装nginx][f280571c]

>   如果需要配置nginx的tcp代理，在nginx1.9版本后已经新增支持TCP代理和负载均衡的stream模块，具体参考：[nginx配置tcp代理和负载均衡stream模块][10f03060]

>nginx配置文件示例：![nginx配置](http://img0.ph.126.net/lotcBHYu4UMgTLCjFujPPA==/6631999052048190651.png)

>> 在server配置中，可以设置自定义变量。如：
```java
proxy_set_header Host $host:38092;
proxy_set_header   X-Real-IP   $remote_addr;
set $a hello;
```
在java中，通过` request.getHeader("X-Real-IP")`就可以获取到`$remote_addr`的值。_具体设置可谷歌_

***

### nginx配置
- 配置文件在nginx\conf\nginx.conf中
- 在nginx.conf中可以使用includ引用配置文件，方便多服务代理管理，如：`include/my/nginx-1.9.12/vhosts/public/*;`
- 在server中`location /mp`表示匹配/meopn路径时代理
    - 在location中，proxy_pass可以另外指定路径，如：proxy_pass : htpp://www.baidu.com
- upstream可以配置服务器地址

    ```
    //upstream中的server元素必须要注意，不能加http://，但proxy_pass中必须加。
    upstream mpServer{
    	//一个服务器挂了的情况下连到另外一个,需要配置多个server
    	server localhost:8080 weight=3; //有时我们就不想它挂的时候访问另外一个，而只是希望一个服务器访问的机会比另外一个大，这个可以在weight=数字 来指定，数字越大，表明请求到的机会越大。
    	server localhost:8080 weight=1;
        server localhost:9999 weight=5;
    }
    ```
    - 在location中这么引用upstream

        ```
        location /mp{
            proxy_pass http://mpServer;
        }
        ```

### nginx命令

- 启动nginx `nginx`,windows `nginx.exe`
- 停止nginx `nginx -s stop`
- 重新载入nginx `nginx -s reload`
- 检查nginx配置文件是否正确 `nginx -t`
- 查看nginx版本 `nginx -v`
- 重新打开日志文件 `nginx -s reopen`

---

#### nginx相关资料

>   反向代理（Reverse Proxy）方式是指以代理服务器来接受internet上的连接请求，然后将请求转发给内部网络上的服务器，并将从服务器上得到的结果返回给internet上请求连接的客户端，此时代理服务器对外就表现为一个服务器。
这里讲得很直白。反向代理方式实际上就是一台负责转发的代理服务器，貌似充当了真正服务器的功能，但实际上并不是，代理服务器只是充当了转发的作用，并且从真正的服务器那里取得返回的数据。这样说，其实nginx完成的就是这样的工作。我们让nginx监听一个端口，譬如80端口，但实际上我们转发给在8080端口的tomcat，由它来处理真正的请求，当请求完成后，tomcat返回，但数据此时没直接返回，而是直接给nginx，由nginx进行返回，这里，我们会以为是nginx进行了处理，但实际上进行处理的是tomcat。
说到上面的方式，也许很多人又会想起来，这样可以把静态文件交由nginx来进行处理。对，很多用到nginx的地方都是作为静态伺服器，这样可以方便缓存那些静态文件，比如CSS，JS，html，htm等文件。


  [f280571c]: http://blog.csdn.net/bao19901210/article/details/52064369 "linux安装配置nginx"
  [10f03060]: http://blog.csdn.net/bao19901210/article/details/52354521 "Nginx发布1.9.0版本，新增支持TCP代理和负载均衡的stream模块"
