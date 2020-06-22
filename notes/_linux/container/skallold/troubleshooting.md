# Troubleshooting
之前执行skaffold dev和skaffold run命令遇到的报错如下：
```bash
rpc error: code = Unknown desc = Error response from daemon: pull access denied for mydeveloperplanet/myskaffoldplanet, repository does not exist or may require 'docker login': denied: requested access to the resource is denied
```

解决方案：把下面的内容加入到skaffold.yaml文件。
```yaml
build:
local:
# 是否推送到远程服务，没有验证在本地有K8s服务时，是否可以推送到远程服务器
push: false
artifacts:
- image: docker.io/mydeveloperplanet/myskaffoldplanet
jib: {}
```
