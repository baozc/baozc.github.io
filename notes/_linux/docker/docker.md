## 使用docker流程

...省略安装、下载步骤

### 单独启动容器

1. `docker images` 查看已有的镜像
2. `docker run` 启动容器
3. `docker exec -ti id bash` 进入容器部署项目
4. 正常访问

### 使用docker-compose启动容器

1. 使用 `docker network`创建网桥
		`docker network create --subnet=30.1.1.0/24  bao_tomcat`
2. 在docker目录下创建新compose目录bao
3. 在目录bao下创建docker-compose.yml文件
		`docker-compose`默认执行名称为docker-compose.yml的配置文件，如果名称不对需要手指定`-f 文件名`参数，具体参数看`docker-compose --help`
4. 配置docker-compose.yml
	```yml
	version: '2'
	services:
		baotestServer:
			image: tomcat:7.0.70-jre8
			hostname: baotestServer
			container_name: baotestServer
			networks:
				tomcat:
				ipv4_address: 30.1.1.2
			expose:
				- "31101"
				- "6777"
			ports:
				- "6777:8080"
			volumes:
				- /me_log/baotest:/usr/local/tomcat/logs
				- /usr/share/zoneinfo/Asia/Shanghai:/etc/localtime:rw
	networks:
		tomcat:
			driver: bridge
			ipam:
				driver: default
				config:
					- subnet: 30.1.1.0/24
	```
5. 启动容器，`docker-compose up -d`



```
[root@localhost test]# docker network create --subnet=30.1.1.0/24  bao_tomcat
e3a97cd3702499dc153fa597818ccf29cb58fd5db2f742eed0983c3149384ae2
[root@localhost test]# docker network ls
NETWORK ID          NAME                DRIVER
e3a97cd37024        bao_tomcat          bridge
3efbb7b75086        bridge              bridge
fa2f23a520f8        host                host
aea1cc79b2d2        metomcat_tomcat     bridge
5a4fd1f6edf5        none                null
cecd1fe2dcbb        test_tomcat         bridge

```
