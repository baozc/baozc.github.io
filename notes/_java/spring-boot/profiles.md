## spring.profiles.active
1. 可以指定多个配置文件，方便开发测试时自动切换
    1. 指定`application.yaml`、`application-local.yaml`、`application-test.yaml`
    2. 在`application.yaml`中配置`spring.profiles.active`来指定运行时使用哪个配置文件，可选值`local`/`test`
2. 关于`spring.profiles.active`加载顺序
  1. 优先查找`spring.profiles.active`指定的配置文件
  2. 如果没有找到再查找`application.yaml`
  3. 及`active`指定 > `application.yaml`
3. 如果在命令行使用`--spring.profiles.active`选项时，命令行指定的优先
  - `命令行`优先级大于`配置文件`

## 命令行指定参数，需要dependency spring boot maven插件：spring-boot-maven-plugin
1. maven运行时，命令行指定参数
    1. 对于spring boot 1.x
        - 使用`mvn spring-boot:run -Drun.arguments="--spring.profiles.active=test"`
    2. 对于spring boot 2.x
        - 使用`mvn spring-boot:run -Dspring-boot.run.arguments="--server.port=8000"`
2. 执行jar包时，命令行指定参数
    - 使用`java -jar target/xxx.jar --spring.profiles.active=test`
3. 后台运行jar包
    - `&`
        - &代表在后台运行。
        - 特定：当前ssh窗口不被锁定，但是当窗口关闭时，程序中止运行。
        - `java -jar target/xxx.jar --spring.profiles.active=test &`
    - `nohup`
        - nohup 意思是不挂断运行命令,当账户退出或终端关闭时,程序仍然运行
        - 当用 nohup 命令执行作业时，缺省情况下该作业的所有输出被重定向到nohup.out的文件中，除非另外指定了输出文件。
        - `nohup java -jar target/xxx.jar --spring.profiles.active=test &`


> 在`application.yaml`中使用的参数，都可以用`--参数`的形式来指定

nohup java -jar target/xxx.jar --spring.profiles.active=test --sip.host=freeswitchHost &

## spring boot命令行参数无效
查看spring boot 主函数中的写法，需要加上传参args
```java
SpringApplication.run(Application.class, args);
```
