# Exec Maven插件
该插件提供了2个目标来帮助执行系统和Java程序。

## 目标概览
有关目标的一般信息。
- exec：exec在单独的进程中执行程序和Java程序。
- exec：java在同一个VM中执行Java程序。

### 使用exec目标运行Java程序
某些命令行参数和配置参数的特殊处理有助于在外部进程中运行Java程序。

注意：通过`执行`目标，参数和`commandlineArgs`配置参数之间几乎重复的功能会导致一些混淆。

- 如果指定了`commandlineArgs`，那么它将按原样使用，除了使用依赖性替换％classpath和％modulepath及其匹配路径
- 否则，如果指定了属性`exec.args`，它将被使用
- 否则，参数，类路径和模块路径的列表将被解析和使用

#### 命令行
如果作为`exec.args`参数的一部分指定，特殊字符串`％classpath`将由Maven计算的项目类路径替换。`％modulepath`的相同元素

```maven
mvn exec:java -Dexec.mainClass="main方法类路径" -Dexec.args="main方法参数"
```

### pom.xml
```xml
<plugin>
	<groupId>org.codehaus.mojo</groupId>
  <artifactId>exec-maven-plugin</artifactId>
  <executions>
      <execution>
          <goals>
              <goal>java</goal>
          </goals>
      </execution>
  </executions>
  <configuration>
      <mainClass>com.u.rcs.netty.action.echo.server.EchoServer</mainClass>
  </configuration>
</plugin>
```

### spring-boot使用maven exec:java
因为spring-boot在`spring-boot-dependencies`中定义了`exec-maven-plugin`的`mainClass`，所以如果在spring-boot中使用有两种方法
1. 不覆盖配置，直接使用spring-boot配置，在`pom.xml`中配置变量`start-class`，或者在命令行执行命令时，把maven参数`mainClass`替换成`start-class`,如下：
    1. `mvn exec:java -Dexec.start-class="main方法类路径" -Dexec.args="main方法参数"`
2. 覆盖`pom.xml`中的`exec-maven-plugin`，照常使用

```xml
<plugin>
    <groupId>org.codehaus.mojo</groupId>
	<artifactId>exec-maven-plugin</artifactId>
	<configuration>
		<mainClass>${start-class}</mainClass>
	</configuration>
</plugin>
```

### 配置Profile，执行多个main方法
**当定义多个profile时，需要指定profile的id来区分不同的profile**   
profiles定义规则
- 包含多个profile

profile定义规则
- 使用`activation`定义执行名称
    ```xml
    <activation>
        <property>
            <name>echoServer</name>
        </property>
    </activation>
    ```
- 使用`build`定义`exec-maven-plugin`，exec定义对应的main方法和参数
- 命令行执行时命令，把maven参数替换成`activation`的`name`，如下
    ```
    mvn exec:java -DechoServer
    ```
```xml
<profiles>
    <profile>
        <activation>
            <property>
                <name>echoServer</name>
            </property>
        </activation>
    <build>
    	<plugins>
    		<plugin>
                <groupId>org.codehaus.mojo</groupId>
                <artifactId>exec-maven-plugin</artifactId>
                <executions>
                    <execution>
                        <goals>
                            <goal>java</goal>
                        </goals>
                    </execution>
                </executions>
                <configuration>
                    <mainClass>com.u.rcs.netty.action.echo.server.EchoServer</mainClass>
                    <arguments>
                        <argument>9001</argument>
                    </arguments>
                </configuration>
            </plugin>
        </plugins>
    </build>
    </profile>
    <profile>
        <id>1</id>
        <activation>
        	<property>
        		<name>echoClient</name>
        	</property>
        </activation>
    <build>
        <plugins>
            <plugin>
                <groupId>org.codehaus.mojo</groupId>
                <artifactId>exec-maven-plugin</artifactId>
                <executions>
                    <execution>
                        <goals>
                            <goal>java</goal>
                        </goals>
                    </execution>
                </executions>
                <configuration>
                    <mainClass>com.u.rcs.netty.action.echo.client.EchoClient</mainClass>
                    <arguments>
                        <argument>127.0.0.1</argument>
                        <argument>9001</argument>
                    </arguments>
                </configuration>
            </plugin>
        </plugins>
    </build>
    </profile>
</profiles>
```
