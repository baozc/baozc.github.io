
# 使用
要使用`Skaffold`最好是提前在我们本地安装一套单节点的`kubernetes`集群，比如`minikube`或者`Docker for MAC/Windows`的`Edge`版

## 安装
您将需要安装以下组件后才能开始使用Skaffold：
### 1. [Skaffold Install][eb5fc881]

- Homebrew
```
brew install skaffold
```
- Stable binary
```
curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-darwin-amd64
sudo install skaffold /usr/local/bin/
或者
curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-darwin-amd64 && chmod +x skaffold && sudo mv skaffold /usr/local/bin
```
当然如果由于某些原因你不能访问上面的链接的话，则可以前往`Skaffol`d的[github release][19aeee29]页面下载相应的安装包。

### 2. Kubernetes集群
其中[Minikube][1400508c]， [GKE][cf3bf45c]， [Docker for Mac（Edge）][c967114c]和[Docker for Windows（Edge）][29ef3034] 已经过测试，但任何`kubernetes`群集都是可以使用，为了简单起见，我这里使用的是`Docker for Mac（Edge）`

### 3. kubectl
要使用`kubernetes`那么肯定`kubectl`也是少不了的，在本地配置上你的目标群集的当前上下文进行开发

### 4. Docker
这个应该不用多说了吧?

### 5. Docker 镜像仓库
如果你有私有的镜像仓库，则要先配置上相关的登录认证之类的。我这里为了方便，就直接使用`Docker Hub`，当然要往上面推送镜像的话，你得提前去`docker hub`注册一个帐号

---

## 使用流程
### 初始化前提

#### 前提1
- 需要准备`dockerfile`或者`jib`配置，否则会报错
```
one or more valid builder configuration (Dockerfile or Jib configuration) must be present to build images with skaffold; please provide at least one build config and try again or run `skaffold init --skip-build`
```
**解决方案：**

- _使用`maven`的`jib`插件，添加命令参数：`skaffold init --XXenableJibInit`_
- _**在当前目录**编写`dockerfile`文件_

##### jib的maven配置
```xml
<plugin>
    <groupId>com.google.cloud.tools</groupId>
    <artifactId>jib-maven-plugin</artifactId>
    <version>2.4.0</version>
    <configuration>
        <from>
            <!--从本地docker守护进程拉取镜像-->
            <image>docker://openjdk:8</image>
        </from>
        <to>
            <image>baozc/jibtest</image>
            <!--<credHelper>docker-credential-*</credHelper>-->
        </to>
        <container>
            <mainClass>cn.baozcc.wx.WxApplication</mainClass>
            <!--容器创建时间-->
            <creationTime>USE_CURRENT_TIMESTAMP</creationTime>
        </container>

    </configuration>
</plugin>
```
---

#### 前提2
`Skaffold init`并不会为我们创建`k8s`的`mainfest`文件，我们需要手动创建。

- 需要准备`k8s`配置清单(`kubernetes manifests`)，即：`deployment`、`service`等清单，否则会报错，**在初始化时会指定清单文件**
```
one or more Kubernetes manifests are required to run skaffold
```
**解决方案：**
- 使用`kubectl`来创建`k8s`的部署文件，命令行参数：
  - `–dry-run` 可以确保部署并没有被执行
  - `-o yaml`参数会输出配置文件
  - `--image`指定使用的镜像，这里使用
```bash
baozc@bao-MacBook-Pro $ kubectl create deployment wx --image=baozc/jibtest --dry-run -o yaml | > deployment.yaml
baozc@bao-MacBook-Pro $ ll
total 16
-rw-r--r--   1 baozc  staff   382B  6 20 00:05 deployment.yaml
-rw-r--r--   1 baozc  staff   1.6K  6 19 17:53 pom.xml
drwxr-xr-x   4 baozc  staff   128B 10 29  2019 src
drwxr-xr-x  14 baozc  staff   448B  6 19 18:38 target
baozc@bao-MacBook-Pro $ cat deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
 creationTimestamp: null
 labels:
   app: wx
 name: wx
spec:
 replicas: 1
 selector:
   matchLabels:
     app: wx
 strategy: {}
 template:
   metadata:
     creationTimestamp: null
     labels:
       app: wx
   spec:
     containers:
     - image: baozc/jibtest
       name: jibtest
       resources: {}
status: {}
```
---

### 初始化skaffold
**执行命令：**`skaffold init`
- 可选参数：`--XXenableJibInit`，使用`maven jib pulgin`

提示是否生成`skaffold.yaml`配置，输入：`y`，生成成功。
```bash
baozc@bao-MacBook-Pro $ skaffold init --XXenableJibInit
apiVersion: skaffold/v2beta5
kind: Config
metadata:
 name: wx
build:
 artifacts:
 - image: baozc/jibtest
   jib:
     project: baozc:wx
deploy:
 kubectl:
   manifests:
   - deployment.yaml

Do you want to write this configuration to skaffold.yaml? [y/n]: y
Configuration skaffold.yaml was written
You can now run [skaffold build] to build the artifacts
or [skaffold run] to build and deploy
or [skaffold dev] to enter development mode, with auto-redeploy
```

- 查看`skaffold.yaml`

配置里有`k8s manifests`的指定文件，在`build`、`deploy`时会使用
```bash
baozc@bao-MacBook-Pro $ cat skaffold.yaml
apiVersion: skaffold/v2beta5
kind: Config
metadata:
 name: wx
build:
 artifacts:
 - image: baozc/jibtest
   jib:
     project: baozc:wx
deploy:
 kubectl:
   manifests:
   - deployment.yaml
```

### 执行构建、部署
**_执行命令：`skaffold dev`，可以加上`-vdebug`参数查看详细构建、部署过程。_**

修改服务代码，会自动重新构建、部署

可以添加`service manifest`，访问对应服务，验证是否重新部署，`kubectl expose deployment myskaffoldplanet --type=NodePort --port=8080 --dry-run -oyaml`
```bash
baozc@bao-MacBook-Pro $ skaffold dev
WARN[0000] port 50051 for gRPC server already in use: using 50052 instead
WARN[0000] port 50052 for gRPC HTTP server already in use: using 50053 instead
Listing files to watch...
- baozc/jibtest
Generating tags...
- baozc/jibtest -> baozc/jibtest:latest
Some taggers failed. Rerun with -vdebug for errors.
Checking cache...
- baozc/jibtest: Found Locally
Tags used in deployment:
- baozc/jibtest -> baozc/jibtest:61b2278ee16153726da526706e3d45010ca38ce2e5cade9100561d63b9102403
Starting deploy...
- deployment.apps/wx created
Waiting for deployments to stabilize...
- deployment/wx: waiting for rollout to finish: 0 of 1 updated replicas are available...
   - pod/wx-6fb547f985-tm2jm: creating container jibtest
- deployment/wx is ready.
Deployments stabilized in 1.138864086s
Press Ctrl+C to exit
Watching for changes...
[wx-6fb547f985-tm2jm jibtest]
[wx-6fb547f985-tm2jm jibtest]   .   ____          _            __ _ _
[wx-6fb547f985-tm2jm jibtest]  /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
[wx-6fb547f985-tm2jm jibtest] ( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
[wx-6fb547f985-tm2jm jibtest]  \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
[wx-6fb547f985-tm2jm jibtest]   '  |____| .__|_| |_|_| |_\__, | / / / /
[wx-6fb547f985-tm2jm jibtest]  =========|_|==============|___/=/_/_/_/
[wx-6fb547f985-tm2jm jibtest]  :: Spring Boot ::        (v2.1.6.RELEASE)
[wx-6fb547f985-tm2jm jibtest]
[wx-6fb547f985-tm2jm jibtest] 2020-06-19 16:32:00.397  INFO 1 --- [           main] cn.baozcc.wx.WxApplication               : Starting WxApplication on wx-6fb547f985-tm2jm with PID 1 (/app/classes started by root in /)
[wx-6fb547f985-tm2jm jibtest] 2020-06-19 16:32:00.402  INFO 1 --- [           main] cn.baozcc.wx.WxApplication               : No active profile set, falling back to default profiles: default
[wx-6fb547f985-tm2jm jibtest] 2020-06-19 16:32:02.526  INFO 1 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat initialized with port(s): 8088 (http)
[wx-6fb547f985-tm2jm jibtest] 2020-06-19 16:32:02.579  INFO 1 --- [           main] o.apache.catalina.core.StandardService   : Starting service [Tomcat]
[wx-6fb547f985-tm2jm jibtest] 2020-06-19 16:32:02.581  INFO 1 --- [           main] org.apache.catalina.core.StandardEngine  : Starting Servlet engine: [Apache Tomcat/9.0.21]
[wx-6fb547f985-tm2jm jibtest] 2020-06-19 16:32:02.778  INFO 1 --- [           main] o.a.c.c.C.[Tomcat].[localhost].[/]       : Initializing Spring embedded WebApplicationContext
[wx-6fb547f985-tm2jm jibtest] 2020-06-19 16:32:02.778  INFO 1 --- [           main] o.s.web.context.ContextLoader            : Root WebApplicationContext: initialization completed in 2298 ms
[wx-6fb547f985-tm2jm jibtest] 2020-06-19 16:32:03.641  INFO 1 --- [           main] o.s.s.concurrent.ThreadPoolTaskExecutor  : Initializing ExecutorService 'applicationTaskExecutor'
[wx-6fb547f985-tm2jm jibtest] 2020-06-19 16:32:03.813  INFO 1 --- [           main] o.s.b.a.w.s.WelcomePageHandlerMapping    : Adding welcome page: class path resource [static/index.html]
[wx-6fb547f985-tm2jm jibtest] 2020-06-19 16:32:04.087  INFO 1 --- [           main] o.s.b.a.e.web.EndpointLinksResolver      : Exposing 2 endpoint(s) beneath base path '/actuator'
[wx-6fb547f985-tm2jm jibtest] 2020-06-19 16:32:04.198  INFO 1 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port(s): 8088 (http) with context path ''
[wx-6fb547f985-tm2jm jibtest] 2020-06-19 16:32:04.204  INFO 1 --- [           main] cn.baozcc.wx.WxApplication               : Started WxApplication in 4.49 seconds (JVM running for 5.164)
```

---
> 参考文章：
> - [Skaffold-简化本地开发kubernetes应用的神器](https://tsov.net/home/view/3247/)
> - [Skaffold：让K8S开发工作变得简单](https://www.kubernetes.org.cn/7012.html)


[eb5fc881]: https://skaffold.dev/docs/install/ "Skaffold Install"
[19aeee29]: https://github.com/GoogleCloudPlatform/skaffold/releases "release"
[1400508c]: https://kubernetes.io/docs/tasks/tools/install-minikube/ "Minikube"
[cf3bf45c]: https://cloud.google.com/kubernetes-engine/docs/how-to/creating-a-container-cluster "GKE"
[c967114c]: https://docs.docker.com/docker-for-mac/install/ "Docker for Mac（Edge）"
[29ef3034]: https://docs.docker.com/docker-for-windows/install/ "Docker for Windows（Edge）"
