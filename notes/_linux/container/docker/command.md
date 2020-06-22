## 一些命令

- `docker pull` 拉取镜像
- `docker images` 列出本地已有的镜像，在列出信息中，可以看到几个字段信息
	- repository 来自于哪个仓库，比如 ubuntu
	- tag 镜像的标记，比如 14.04
		- TAG  信息用来标记来自同一个仓库的不同镜像。例如  ubuntu  仓库中有多个镜像，通过  TAG  信息来区分发行版本，例如10.04  、 12.04  、 12.10  、 13.04  、 14.04  等。例如下面的命令指定使用镜像ubuntu:14.04  来启动一个容器。
		- `sudo docker run -t -i ubuntu:14.04 /bin/bash`
	- image id 它的  ID  号（唯一）
	- created 创建时间
	- size 镜像大小
-
