用skaffold反复进行部署时会产生一些无用的docker实例及镜像，这里用一个脚本将它们删除
```bash
# 删除停止或一直处于已创建状态的实例
docker ps --filter "status=exited"|sed -n -e '2,$p'|awk '{print $1}'|xargs docker rm
docker ps --filter "status=created"|sed -n -e '2,$p'|awk '{print $1}'|xargs docker rm
# 删除虚悬镜像
docker image prune --force
# 删除REPOSITORY是长长uuid的镜像
docker images | sed -n -e '2,$p'|awk '{if($1 ~ /[0-9a-f]{32}/) print $1":"$2}'|xargs docker rmi
# 删除TAG是长长uuid的镜像
docker images | sed -n -e '2,$p'|awk '{if($2 ~ /[0-9a-f]{64}/) print $1":"$2}'|xargs docker rmi
```
