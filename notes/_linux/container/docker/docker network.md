### docker network 网桥

```
Usage:  docker network [OPTIONS] COMMAND [OPTIONS]

Commands:
  ls                       List all networks 查看network列表
  rm                       Remove a network 删除network
  create                   Create a network 创建network
  connect                  Connect container to a  network
  disconnect               Disconnect container from a network
  inspect                  Display detailed network information 显示network配置信息

Run 'docker network COMMAND --help' for more information on a command.
```

```
[root@localhost me_tomcat]# docker network inspect test_tomcat
[
    {
        "Name": "test_tomcat",
        "Id": "cecd1fe2dcbb0e840eacb0499defb8560392ac184600f5efb38c090f4ad8a757",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "20.1.1.0/24"
                }
            ]
        },
        "Internal": false,
        "Containers": {
            "79273ec00cc02c3f8551d0517c2ced7b8f0af06173739719926871e97eb24779": {
                "Name": "baoServer",
                "EndpointID": "289d4a2fdbf32c4b5e8984ecb0f4c26f857439fdf8a873aea3403d8b2ec8c078",
                "MacAddress": "02:42:14:01:01:02",
                "IPv4Address": "20.1.1.2/24",
                "IPv6Address": ""
            }
        },
        "Options": {},
        "Labels": {}
    }
]
```

- Name是network的名字，用户可以随意定义。
- Id是network内部的uuid，全局唯一。
- Scope目前有两个值“local”、“remote”，表示是本机网络还是多机网络。
- Driver是指network driver的名字。
- IPAM是负责IP管理发放的driver名字与配置信息（我们在bridge网络中可以看到该信息）。
- Container内记录了使用这个网络的容器的信息。
- Options内记录了driver所需的各种配置信息。

#### 创建network

`docker network create -d bridge --ip-range=192.168.1.0/24 --gateway=192.168.1.1 --subnet=192.168.1.0/24  bao`
创建network,名称为bao，driver为bridge，并且指定IP

`192.168.1.0/24`，指定IP，并且分配24个连接，容器占用`192.168.1.1`，docker-compose中IP应该从2开始

具体参数，参考`docker network create --help`

##### docker-compose中的network定义

docker-compose中的network，默认名称为：**当前文件夹名称_network名**，所以network名称应该为 _docker-compose_文件夹名network名_
`subnet` 为创建network时指定的IP
