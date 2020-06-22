# volumes数据格式
一般`volumes`由`spec`声明，可以有不同的类型(`hostPath`、`configMap`、`emptyDir`等，具体可以通过`kubectl explain pod.spec.volumes`查看)

在容器中声明挂载卷`volumeMounts`，包含`name`和类型(同`spec.volumes`类型)，由`name`和`spec.volumes`中的卷做关联，如下所示(省略了其它配置信息)：
```yaml
spec:
  volumes:
  - name: varlog
    hostPath:
      path: /var/log/counter
  containers:
    volumeMounts:
    - name: varlog
      mountPath: /var/log
```
上述yaml中，`spec.volumes`声明了一个名为`varlog`的卷，类型为`hostPath`(宿主机路径)，然后在容器中声明了挂载卷信息，挂载卷名称和卷名称对应即：`sepc.container.volumeMounts.name` = `spec.volumes.name`

上述信息意味这个宿主机的 `/var/log/counter` 目录将被这个 `Pod` 共享，共享给谁呢？在需要用到这个数据目录的容器上声明挂载即可，也就是通过 `volumeMounts` 声明挂载的部分，这样我们这个 `Pod` 就实现了共享容器的 `/var/log` 目录，而且数据被持久化到了宿主机目录上。

**即把容器中的`/var/log`目录，共享到了宿主机的`/var/log/counter`上**

**挂载卷不能挂载到容器原有的目录，必须是新建的，挂载其实是把主机目录挂载到容器里，不是把容器里的目录挂载到主机上**

# hostPath（本地数据卷）

`hostPath`属性的`volume`使得对应的容器能够访问当前宿主机上的指定目录。例如，需要运行一个访问`Docker`系统目录的容器，那么就使用`/var/lib/docker`目录作为一个`hostPath`类型的`volume`；或者要在一个容器内部运行`CAdvisor`，那么就使用`/dev/cgroups`目录作为一个`hostPath`类型的`volume`。一旦这个`pod`离开了这个宿主机，`hostPath`中的数据虽然不会被永久删除，但数据也不会随`pod`迁移到其他宿主机上。因此，需要注意的是，由于各个宿主机上的文件系统结构和内容并不一定完全相同，所以相同`pod`的`hostPath`可能会在不同的宿主机上表现出不同的行为。yaml示例如下：
```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    name: test-hostpath
    role: master
  name: test-hostpath
spec:
  - name: ssl-certs
      hostPath:
      path: /etc/ssl/certs
  containers:
    - name: test-hostpath
      image: registry:5000/back_demon:1.0
      volumeMounts:
       - name: ssl-certs
         mountPath: /home/laizy/test/cert
         readOnly: true
      command:
      - /run.sh
  volumes:
```

# configMap
通过数据卷使用，在数据卷里面使用 `ConfigMap`，就是将文件填入数据卷，**在这个文件中，键就是文件名，键值就是文件内容**。

## 从 ConfigMap 里的数据生成一个卷
在 `Pod` 的配置文件里的 `volumes` 段添加 `ConfigMap` 的名字。 这会将 `ConfigMap` 数据添加到 `volumeMounts.mountPath` 指定的目录里面（在这个例子里是 `/etc/config`）。
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
      command: [ "/bin/sh", "-c", "ls /etc/config/" ]
      # 挂载卷，和spec.volumes对应
      volumeMounts:
        # 挂载卷名称，对应spec.volumes.name
      - name: config-volume
        # 挂载类型：mountPath，挂载路径方式，对应的容器路径为: /etc/config
        mountPath: /etc/config
```

## 添加 ConfigMap 数据到卷里指定路径
创建一个configMap
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: special-config
  namespace: default
data:
  SPECIAL_LEVEL: very
  SPECIAL_TYPE: charm
```

使用 `path` 变量定义 `ConfigMap` 数据的文件路径。 在我们这个例子里，`special.level` 将会被挂载在 `config-volume` 的文件 `/etc/config/keys` 下.
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: dapi-test-pod
spec:
  containers:
    - name: test-container
      image: gcr.io/google_containers/busybox
      command: [ "/bin/sh","-c","cat /etc/config/keys" ]
      volumeMounts:
      - name: config-volume
        mountPath: /etc/config
  volumes:
    - name: config-volume
      configMap:
        name: special-config
        items:
        # configMap中的文件名
        - key: special.level
          # 映射到容器里的文件名
          path: keys
  restartPolicy: Never
```
相当于把`special.level`文件映射到容器中的`mountPath` + `path`

Pod 运行起来后，执行命令("cat /etc/config/keys")将产生下面的结果：
```
very
```


# emptyDir（本地数据卷）

`emptyDir`类型的`volume`创建于`pod`被调度到某个宿主机上的时候，而同一个`pod`内的容器都能读写`emptyDir`中的同一个文件。一旦这个`pod`离开了这个宿主机，`emptyDirr`中的数据就会被永久删除。所以目前`emptyDir`类型的`volume`主要用作临时空间，比如Web服务器写日志或者tmp文件需要的临时目录。yaml示例如下：
```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    name: test-emptypath
    role: master
  name: test-emptypath
spec:
  volumes:
    - name: log-storage
      emptyDir: {}
  containers:
    - name: test-emptypath
      image: registry:5000/back_demon:1.0
      volumeMounts:
       - name: log-storage
         mountPath: /home/laizy/test/
      command:
      - /run.sh
```

# NFS（网络数据卷）
NFS类型的volume。允许一块现有的网络硬盘在同一个pod内的容器间共享。yaml示例如下：
```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    name: test-nfspath
    role: master
  name: test-nfspath
spec:
  containers:
    - name: test-nfspath
      image: registry:5000/back_demon:1.0
      volumeMounts:
       - name: nfs-storage
         mountPath: /home/laizy/test/
      command:
      - /run.sh
  volumes:
  - name: nfs-storage
    nfs:
     server: 192.168.20.47
     path: "/data/disk1"
 ```

 # Secret（信息数据卷）
 kubernetes提供了Secret来处理敏感数据，比如密码、Token和密钥，相比于直接将敏感数据配置在Pod的定义或者镜像中，Secret提供了更加安全的机制（Base64加密），防止数据泄露。Secret的创建是独立于Pod的，以数据卷的形式挂载到Pod中，Secret的数据将以文件的形式保存，容器通过读取文件可以获取需要的数据。yaml示例如下：
 ```yaml
 apiVersion: v1
kind: Secret
metadata:
 name: mysecret
type: Opaque
data:
 username: emhlbnl1
 password: eWFvZGlkaWFv
[root@k8s-master demon2]# cat test-secret.yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    name: test-secret
    role: master
  name: test-secret
spec:
  containers:
    - name: test-secret
      image: registry:5000/back_demon:1.0
      volumeMounts:
       - name: secret
         mountPath: /home/laizy/secret
         readOnly: true
      command:
      - /run.sh
  volumes:
  - name: secret
    secret:
     secretName: mysecret
```
