### 基本内容
- POM包括了所有的项目信息
- groupId:项目或者组织的唯一标志，并且配置时生成路径也是由此生成，如org.myproject.mojo生成的相对路径为：/org/myproject/mojo
- artifactId:项目的通用名称
- version:项目的版本
- packaging:打包机制，如pom,jar,maven-plugin,ejb,war,ear,rar,par
- name:用户描述项目的名称，无关紧要的东西，可选
- url:应该是只是写明开发团队的网站，无关紧要，可选
- classifer:分类

>其中groupId,artifactId,version,packaging这四项组成了项目的唯一坐标。一般情况下，前面三项就可以组成项目的唯一坐标了。
> POM关系：主要为依赖，继承，合成

[maven搜索jar包地址1][007c9c59]

[maven搜索jar包地址2][e06bae7f]

  [007c9c59]: http://mvnrepository.com/ "maven地址"
  [e06bae7f]: http://search.maven.org "maven地址"
