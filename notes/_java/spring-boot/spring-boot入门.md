## spring-boot使用maven配置
1. pom配置
	```xml
	<!-- 从Spring Boot继承默认值 -->
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>1.5.8.RELEASE</version>
    </parent>

    <!-- 添加Web应用程序的典型依赖关系 -->
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
    </dependencies>

    <!-- Package as an executable jar -->
    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
	```
2. 安装Spring Boot CLI
	- 配置环境变量，验证是否成功
	```
	$ sdk install springboot
	$ spring --version
	Spring Boot v1.5.8.RELEASE
	```
3. 编写代码，Maven将src/main/java默认编译源代码，因此您需要创建该文件夹结构，然后添加一个名为src/main/java/Example.java：
	```java
	import org.springframework.boot.*;
	import org.springframework.boot.autoconfigure.*;
	import org.springframework.stereotype.*;
	import org.springframework.web.bind.annotation.*;

	@RestController
	@EnableAutoConfiguration
	public class Example {

	    @RequestMapping("/")
	    String home() {
	        return "Hello World!";
	    }

	    public static void main(String[] args) throws Exception {
	        SpringApplication.run(Example.class, args);
	    }

	}
	```
4. 运行示例
	- 在这一点上我们的应用程序应该工作 由于我们已经使用了 spring-boot-starter-parentPOM，我们有一个有用的run目标，我们可以用它来启动应用程序。`mvn spring-boot:run`从根项目目录中键入以启动应用程序：
	```
	$ mvn spring-boot:run

		.   ____          _                                              __ _ _
	/\\ / ___'_ __ _ _(_)_ __  __ _          ___               _      \ \ \ \
	( ( )\___ | '_ | '_| | '_ \/ _` |        | _ \___ _ __  ___| |_ ___ \ \ \ \
	\\/  ___)| |_)| | | | | || (_| []::::::[]   / -_) '  \/ _ \  _/ -_) ) ) ) )
	'  |____| .__|_| |_|_| |_\__, |        |_|_\___|_|_|_\___/\__\___|/ / / /
	=========|_|==============|___/===================================/_/_/_/
	 :: Spring Boot ::（v1.5.8.RELEASE）
	....... 。。
	....... 。。（在这里输出日志）
	....... 。。
	........启动例2.222秒（JVM运行6.514）6
	```
	- 如果你打开一个web浏览器到localhost：8080你应该看到下面的输出：
	```
	Hello World!
	```
	- 优雅地退出应用程序命中`ctrl-c`。
5. 创建一个可执行的jar
	- 让我们通过创建一个完全独立的可执行jar文件来完成我们的例子，我们可以在生产环境中运行它。可执行jar（有时也称为“fat jars”）是包含您编译的类以及您的代码需要运行的所有jar依赖项的归档文件。
	- 要创建一个可执行的jar我们需要添加`spring-boot-maven-plugin`到我们的 `pom.xml`。在`dependencies`部分下方插入以下几行：
	```xml
	<build>
	    <plugins>
	        <plugin>
	            <groupId>org.springframework.boot</groupId>
	            <artifactId>spring-boot-maven-plugin</artifactId>
	        </plugin>
	    </plugins>
	</build>
	```
	- 保存pom.xml并从命令行运行mvn package：
	```maven
	$ mvn包

	[INFO]扫描项目...
	[信息]
	[INFO] ----------------------------------------------- -------------------------
	[INFO]构建myproject 0.0.1-SNAPSHOT
	[INFO] ----------------------------------------------- -------------------------
	[信息] ....
	[INFO] --- maven-jar-plugin：2.4：jar（默认jar）@ myproject ---
	[INFO]构建jar：/Users/developer/example/spring-boot-example/target/myproject-0.0.1-SNAPSHOT.jar
	[信息]
	[INFO] --- spring-boot-maven-plugin：1.5.8.RELEASE：重新包装（默认）@ myproject ---
	[INFO] ----------------------------------------------- -------------------------
	[信息]建立成功
	[INFO] ----------------------------------------------- -------------------------
	```
	- 如果你看看target你应该看到的目录myproject-0.0.1-SNAPSHOT.jar。该文件大小应该在10 MB左右。如果你想偷看，你可以使用jar tvf：
	```
	$ jar tvf target / myproject-0.0.1-SNAPSHOT.jar
	```
	- 你还应该看到myproject-0.0.1-SNAPSHOT.jar.original 在target目录中命名的小得多的文件。这是Maven在被Spring Boot重新包装之前创建的原始jar文件。
    - 要运行该应用程序，请使用以下java -jar命令：
	```
	$ java -jar target / myproject-0.0.1-SNAPSHOT.jar

		.   ____          _                                              __ _ _
	/\\ / ___'_ __ _ _(_)_ __  __ _          ___               _      \ \ \ \
	( ( )\___ | '_ | '_| | '_ \/ _` |        | _ \___ _ __  ___| |_ ___ \ \ \ \
	\\/  ___)| |_)| | | | | || (_| []::::::[]   / -_) '  \/ _ \  _/ -_) ) ) ) )
	'  |____| .__|_| |_|_| |_\__, |        |_|_\___|_|_|_\___/\__\___|/ / / /
	=========|_|==============|___/===================================/_/_/_/
	 :: Spring Boot ::（v1.5.8.RELEASE）
	....... 。。
	....... 。。（在这里输出日志）
	....... 。。
	........在2.536秒内启动例子（运行2.864的JVM）
	```
	- 像以前一样，优雅地退出应用程序命中ctrl-c。
