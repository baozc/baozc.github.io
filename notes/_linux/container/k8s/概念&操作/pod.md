# 理解pod
Pod 是 Kubernetes 应用程序的基本执行单元，即它是 Kubernetes 对象模型中创建或部署的最小和最简单的单元。Pod 表示在 集群 上运行的进程。

Pod 封装了应用程序容器（或者在某些情况下封装多个容器）、存储资源、唯一网络 IP 以及控制容器应该如何运行的选项。

Pod 表示部署单元：Kubernetes 中应用程序的单个实例，它可能由单个 容器 或少量紧密耦合并共享资源的容器组成。

Docker 是 Kubernetes Pod 中最常用的容器运行时，但 Pod 也能支持其他的容器运行时。

Kubernetes 集群中的 Pod 可被用于以下两个主要用途：
- **运行单个容器的 Pod**。“每个 Pod 一个容器"模型是最常见的 Kubernetes 用例；在这种情况下，可以将 Pod 看作单个容器的包装器，并且 Kubernetes 直接管理 Pod，而不是容器。
- **运行多个协同工作的容器的 Pod**。 Pod 可能封装由多个紧密耦合且需要共享资源的共处容器组成的应用程序。 这些位于同一位置的容器可能形成单个内聚的服务单元 —— 一个容器将文件从共享卷提供给公众，而另一个单独的“挂斗”（sidecar）容器则刷新或更新这些文件。 Pod 将这些容器和存储资源打包为一个可管理的实体。 Kubernetes 博客 上有一些其他的 Pod 用例信息。更多信息请参考：
  - [分布式系统工具包：容器组合的模式][12fe0c9a]
  - [容器设计模式][b7cce641]


# 创建pod
Kubernetes 最基本的调度单元，Pod 是由容器组成的

## 为什么需要pod
我们需要一个更高级别的结构来将这些容器绑定在一起，并将他们作为一个基本的调度单元进行管理，这样就可以保证这些容器始终在同一个节点上面，这也就是 Pod 设计的初衷。

## 如何划分pod
当我们判断是否需要在 Pod 中使用多个容器的时候，我们可以按照如下的几个方式来判断：
- 这些容器是否一定需要一起运行，是否可以运行在不同的节点上
- 这些容器是一个整体还是独立的组件
- 这些容器一起进行扩缩容会影响应用吗

## kubectl explain pod.spec.volumes
- hostPath
挂载宿主机路径

- emptyDir
kubectl临时文件夹

- downwardAPI
让 Pod 里的容器能够直接获取到这个 Pod 对象本身的一些信息。

目前 Downward API 提供了两种方式用于将 Pod 的信息注入到容器内部：

    - 环境变量：用于单个变量，可以将 Pod 信息和容器信息直接注入容器内部
    - Volume 挂载：将 Pod 信息生成为文件，直接挂载到容器内部中去

- kubectl apply -f
- kubectl delete -f
- kubectl replace
- kubectl get
  - -n
  - -o wide
  - -o yaml
- kubectl logs podName

# 如何编写资源清单
同样的，比如我们要获取 Deployment 的字段信息，我们可以通过 kubectl explain 命令来了解：

- kubectl explain 查看资源的文档
  - kubectl explain deployment
  - kubectl explain deployment.spec

--watch 参数来查看 Pod 的更新过程：
![watch](assets/markdown-img-paste-20200611160932536.png)
简单介绍
```yaml
apiVersion: v1 # 声明K8s的API版本
kind: pod # 声明API对象的类型，这里是Pod(pod deployment rc rs等)
metadata: # 设置Pod的元数据
  name: hello-world # 指定Pod的名称Pod名称必粗在Namespace内唯一
spec: # 配置Pod的具体规格
  restartPolicy: 重启策略
  containers: 容器规格，数组形式，每一项定义一个容器
  - name: nginx # 指定容器的名称，在Pod的定义中唯一
    image: nginx # 设置容器镜像
    # command: 设置容器的启动命令
```
