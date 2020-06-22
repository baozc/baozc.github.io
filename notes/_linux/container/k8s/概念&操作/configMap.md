# [可变配置管理 configMap][9e2d5cb2]
> 应用的可变配置在 Kubernetes 中是通过一个 ConfigMap 资源对象来实现的，我们知道许多应用经常会有从配置文件、命令行参数或者环境变量中读取一些配置信息的需求，这些配置信息我们肯定不会直接写死到应用程序中去的，比如你一个应用连接一个 redis 服务，下一次想更换一个了的，还得重新去修改代码，重新制作一个镜像，这肯定是不可取的，而ConfigMap 就给我们提供了向容器中注入配置信息的能力，不仅可以用来保存单个属性，还可以用来保存整个配置文件，比如我们可以用来配置一个 redis 服务的访问地址，也可以用来保存整个 redis 的配置文件。

  [9e2d5cb2]: https://www.qikqiak.com/k8strain/config/configmap/ "configMap"
> [**kubernetes configMap在pod中的使用方式**][ed2a1df6]

# 创建
ConfigMap 资源对象使用 key-value 形式的键值对来配置数据，这些数据可以在 Pod 里面使用，如下所示的资源清单：
```yaml
kind: ConfigMap
apiVersion: v1
metadata:
  name: cm-demo
  namespace: default
data:
  data.1: hello
  data.2: world
  config: |
    property.1=value-1
    property.2=value-2
    property.3=value-3
```

  [ed2a1df6]: https://k8smeetup.github.io/docs/tasks/configure-pod-container/configure-pod-configmap/ "kubernetes configMap在pod中的使用方式"

上述创建方式，`data`下前两行为配置属性，第三行表示配置文件。

少量配置可以使用yaml方式创建，配置多的话，建议使用`kubectl create cofingmap`方式创建

当然同样的我们可以使用`kubectl create -f xx.yaml`来创建上面的 `ConfigMap` 对象，但是如果我们不知道怎么创建 `ConfigMap` 的话，不要忘记 `kubectl` 是我们最好的帮手，可以使用`kubectl create configmap -h`来查看关于创建 `ConfigMap` 的帮助信息：
```bash
Examples:
  # Create a new configmap named my-config based on folder bar
  kubectl create configmap my-config --from-file=path/to/bar

  # Create a new configmap named my-config with specified keys instead of file basenames on disk
  kubectl create configmap my-config --from-file=key1=/path/to/bar/file1.txt --from-file=key2=/path/to/bar/file2.txt

  # Create a new configmap named my-config with key1=config1 and key2=config2
  kubectl create configmap my-config --from-literal=key1=config1 --from-literal=key2=config2

  # Create a new configmap named my-config from the key=value pairs in the file
  kubectl create configmap my-config --from-file=path/to/bar

  # Create a new configmap named my-config from an env file
  kubectl create configmap my-config --from-env-file=path/to/bar.env
```
**值得注意的是 --from-file 这个参数可以使用多次**

# 使用
`ConfigMap` 创建成功了，那么我们应该怎么在 `Pod` 中来使用呢？我们说 `ConfigMap` 这些配置数据可以通过很多种方式在 `Pod` 里使用，主要有以下几种方式：
- 设置环境变量的值
- 在容器里设置命令行参数
- 在数据卷里面挂载配置文件

# 查看
`kubectl get configmap cm-demo1 -o yaml`
如果configMap配置的是文件，则`data`中文件名为`key`，内容为`value`，`key`后加`|`符号分隔，如：
```yaml
apiVersion: v1
data:
  mysql.conf: |
    host=127.0.0.1
    port=3306
  redis.conf: |
    host=127.0.0.1
    port=6379
kind: ConfigMap
metadata:
  creationTimestamp: 2018-06-14T16:24:36Z
  name: cm-demo1
  namespace: default
  resourceVersion: "3109975"
  selfLink: /api/v1/namespaces/default/configmaps/cm-demo1
  uid: 6e0f4d82-6fef-11e8-a101-525400db4df7
```

## 在数据卷里面挂载配置文件
一种是非常常见的使用 `ConfigMap` 的方式：通过数据卷使用，在数据卷里面使用 `ConfigMap`，就是将文件填入数据卷，**在这个文件中，键就是文件名，键值就是文件内容**，如下资源对象所示：
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: testcm3-pod
spec:
  volumes:
    # 卷名称
    - name: config-volume
      # 卷类型为: configMap
      configMap:
        # configMap的名称为: cm-demo2
        name: cm-demo2
  containers:
    - name: testcm3
      image: busybox
      command: [ "/bin/sh", "-c", "cat /etc/config/redis.conf" ]
      # 挂载卷，和spec.volumes对应
      volumeMounts:
        # 挂载卷名称，对应spec.volumes.name
      - name: config-volume
        # 挂载类型：mountPath，挂载路径方式，对应的容器路径为: /etc/config
        mountPath: /etc/config
```

另外需要注意的是，当 `ConfigMap` 以数据卷的形式挂载进 `Pod` 的时，这时更新 `ConfigMap`（或删掉重建`ConfigMap`），`Pod` 内挂载的配置信息会热更新。这时可以增加一些监测配置文件变更的脚本，然后重加载对应服务就可以实现应用的热更新。
