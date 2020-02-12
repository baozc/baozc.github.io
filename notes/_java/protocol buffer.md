>windows需要安装protoc-x.x.x-win32
>
> linux需要下载源码包安装
>
> 下载地址：https://developers.google.com/protocol-buffers/docs/downloads  
>
>运行所需jar包：artifactId:protobuf-java

### 生成java文件
```
protoc.exe --proto_path=d:/workspace  --java_out=d:/workspace/protobuf/src  d:/workspace/protobuf/resourcese/addressbook.proto
```
- `--proto_path=.proto` 文件所在目录,指定对导入文件的搜索路径，若不指定，则为当前路径；
- `--java_out=java文件输出目录 `
- `d:/workspace/protobuf/resourcese/addressbook.proto` 是定义结构的.proto文件所在路径
- 查看详细参数：protoc.exe -h
- **默认搜索目录是~  windows下是c盘user目录，具体应该是这样，当初试完没有记录**

#### 示例 addressbook.proto
```java
package tutorial; //包名称，当java_package没有设置时，java输出文件为--java_out+package

//使用java_package时，package无效，java输出文件为--java_out+java_package
option java_package = "com.protocol.test";
//输出java类的类名
option java_outer_classname = "AddressBookProtos";

//在.proto文件中，最基本的数据类型为message，其定义如上所示，由message引导，
//之后是message类型的名字，之后是由{}包含的各个域(fields)。
message Person {
  required string name = 1; //required 表示这个域是必需的
  required int32 id = 2;
  optional string email = 3;//optional 该域选，出现０次或１次
}

message AddressBook {
  repeated Person person = 1;//repeated 重复出现，０次或多次 list
}
```

***

>　　string是域的类型，可是简单的标量类型（如bool,int32,float,double,string等），也可是复合类型(message,enum等)
name是域的名字，=1是给域一个数字标签，这会影响到该域在二进制文件中顺序。

>　　关于这个数字标签也是有说明的，1到15是只使用一个字节编号，而其他的使用多个字节，所以应把1-15编号给最经常使用的域。数字标签的最大值为2**29 - 1（或536,870,911），其中还有一段是保留用于proto的实现，从19000到19999 （FieldDescriptor::kFirstReservedNumber 到FieldDescriptor::kLastReservedNumber）。
有optional说明的域可以有一个默认值，在不指定该域时使用，如optional PhoneType type = 2 [default = HOME];

>　　还有一种类型是enum，如上enum PhoneType的定义。类型可以定义一在一个message类型中，也可以单独定义，如上enum PhoneType和message PhoneNumber是嵌套定义在message Person中，message AddressBook中单独定义的。　　
可以访问一个嵌套定义在另一个message类型中的message，但需使用域范围标示，如同的c++里使用另一个命名空间的类：person::PhoneNumber。

>　　添加注释：//optional int32 page_number = 2;// Which page number do we want?

>　　导入：proto可以导入在不同的文件中的定义。通过在文件顶端加入一个import语句  import "myproject/other_protos.proto";

---

### java类说明
>生成java类，大概说明：
	在不指定option optimize_for = LITE_RUNTIME;时
	AddressBookProtos中每个message大致结构：
		包含PersonOrBuilder接口，实现com.google.protobuf.MessageOrBuilder，方法主要有各字段get、has、FieldBytes
		用来获取字段值，判断字段是否有值，获取字段bytes

		>final class Person继承com.google.protobuf.GeneratedMessage实现PersonOrBuilder
		每一个Message类都会包含一个静态内部类，即与之对应的Builder类


		Builder类，内部方法：
			clear() 清空当前对象中的所有设置。调用后，所有字段has方法均返回false
			clone()	克隆出一个Builder对象。
			各字段的has、get、set方法，这些方法均返回Builder对象，方便调用者在一条代码中方便的连续修改多个字段
		Message类(Person)，内部方法：
			Person(Builder builder) 由于所有构造函数均为私有方法，由此可见，我们不能直接new Person的对象实例，
									而是只能通过与其对应Builder来构造，或是直接通过反序列化的方式生成。
			newBuilder() 该静态方法为该类Builder接口的工厂方法。返回的Builder实现类在完成各个字段的
						   初始化后，通过build()方法返回与其对应的消息实现类，即	Person类
			toBuilder()	通过该类的对象获取与其对应的Builder类对象，一般用于通过Builder类完成消息字段的修改。
			isInitialized() 判断当前对象的所有字段是否都已经被初始化。
			getSerializedSize() 获取已经被初始化后的对象序列化时所占用的字节空间。
			parseFrom(xxx) 序列化对象，用于从不同的数据源反序列化对象。

			XXX_FIELD_NUMBER = 1  静态变量对应于该字段在.proto中定义的标签号。
								    该变量的命名规则为：字段(全部大写) + _FIELD_NUMBER。

			更多方法可以查看Message抽象父类

	指定option optimize_for = LITE_RUNTIME;时.proto文件生成的所有Java类的父类均为com.google.protobuf.GeneratedMessageLite，
	而非com.google.protobuf.GeneratedMessage，同时与之对应的Builder类则均继承自com.google.protobuf.MessageLiteOrBuilder，
	而非com.google.protobuf.MessageOrBuilder。

	MessageLite接口是Message的父接口，在MessageLite中将缺少Protocol Buffer对反射的支持，而此功能均在Message接口中提供了接口规范，
	同时又在其实现类GeneratedMessage中给予了最小功能的实现。对于我们的项目而言，整个系统相对比较封闭，不会和更多的外部程序进行交互，与此同时，
	我们的客户端部分又是运行在Android平台，有鉴于此，我们考虑使用LITE版本的Protocol Buffer。
	这样不仅可以得到更高编码效率，而且生成代码编译后所占用的资源也会更少，至于反射所能带来的灵活性和极易扩展性，对于该项目而言完全可以忽略。
