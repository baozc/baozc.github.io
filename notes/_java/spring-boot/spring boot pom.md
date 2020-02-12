## Maven
Maven用户可以从spring-boot-starter-parent项目中继承以获得合理的默认值。父项目提供以下功能：
- Java 1.6作为默认的编译器级别。
- UTF-8源码编码。
- 一个依赖管理部分，让您省去<version>了公共依赖标签，从继承的 spring-boot-dependenciesPOM。
- 明智的资源过滤。
- 明智的插件配置（exec插件， surefire， Git提交ID， 阴影）。
- 明智的资源过滤application.properties和application.yml包括配置文件特定的文件（例如application-foo.properties和application-foo.yml）

最后一点：因为默认配置文件接受Spring样式占位符（${…​}），Maven过滤被改为使用@..@占位符（您可以用Maven属性覆盖 resource.delimiter）。

### spring-boot配置Maven的两种方式
1. 继承初始父项   

	要配置你的项目从spring-boot-starter-parent简单的设置继承parent：
	```xml
	<!-- 从Spring Boot继承默认值(Inherit defaults from Spring Boot) -->
	<parent>
	    <groupId>org.springframework.boot</groupId>
	    <artifactId>spring-boot-starter-parent</artifactId>
	    <version>1.5.9.RELEASE</version>
	</parent>
	```
	> 您应该只需要在此依赖项上指定Spring Boot版本号。如果您导入更多的启动器，则可以安全地省略版本号。

	通过该设置，您还可以通过在自己的项目中重写属性来覆盖各个依赖项。例如，要升级到另一个Spring Data发行版，您需要将以下内容添加到您的pom.xml。
	```xml
	<properties>
	    <spring-data-releasetrain.version>Fowler-SR2</spring-data-releasetrain.version>
	</properties>
	```

2. 使用没有父POM的Spring Boot

	不是每个人都喜欢从spring-boot-starter-parentPOM 继承。你可能有你自己的企业标准的父母，你需要使用，或者你可能只是喜欢显式声明所有的Maven配置。
	如果你不想使用它spring-boot-starter-parent，你仍然可以通过使用一个scope=import 依赖来保持依赖管理（而不是插件管理）的好处：
	```xml
	<dependencyManagement>
	     <dependencies>
	        <dependency>
	            <!-- Import dependency management from Spring Boot -->
	            <groupId>org.springframework.boot</groupId>
	            <artifactId>spring-boot-dependencies</artifactId>
	            <version>1.5.9.RELEASE</version>
	            <type>pom</type>
	            <scope>import</scope>
	        </dependency>
	    </dependencies>
	</dependencyManagement>
	```
	如上所述，该设置不允许您使用属性覆盖单个依赖项。要达到相同的结果，您需要在输入之前在dependencyManagement项目中添加一个 条目。例如，要升级到另一个Spring Data发行版，您需要将以下内容添加到您的。spring-boot-dependenciespom.xml
	```xml
	<dependencyManagement>
	    <dependencies>
	        <!-- Override Spring Data release train provided by Spring Boot -->
	        <dependency>
	            <groupId>org.springframework.data</groupId>
	            <artifactId>spring-data-releasetrain</artifactId>
	            <version>Fowler-SR2</version>
	            <scope>import</scope>
	            <type>pom</type>
	        </dependency>
	        <dependency>
	            <groupId>org.springframework.boot</groupId>
	            <artifactId>spring-boot-dependencies</artifactId>
	            <version>1.5.9.RELEASE</version>
	            <type>pom</type>
	            <scope>import</scope>
	        </dependency>
	    </dependencies>
	</dependencyManagement>
	```

#### 更改java版本
该spring-boot-starter-parent选相当保守的Java兼容性。如果您想遵循我们的建议并使用较新的Java版本，则可以添加一个 java.version属性：
```xml
<properties>
    <java.version>1.8</java.version>
</properties>
```

#### 使用Spring Boot Maven插件(打包可执行Jar包)
Spring Boot包含一个Maven插件 ，可以将项目打包为可执行的jar文件。<plugins> 如果你想使用它，将插件添加到你的部分：
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
> 如果你使用Spring Boot的启动父POM，你只需要添加插件，除非你想改变在父代中定义的设置，否则不需要进行配置。
