---
layout: post
name: vm options
position: Developer
category: jvm
---
## 查看当前jdk支持的vm参数
`java -XX:+PrintFlagsFinal -version  `

- `-XX:+PrintFlagsInitial`
    - 显示所有可设置参数及默认值，可结合`-XX:+PrintFlagsInitial`与`-XX:+PrintFlagsFinal`对比设置前、设置后的差异，方便知道对那些参数做了调整。
- `-XX:+PrintFlagsFinal`
    - 可以获取到所有可设置参数及值(手动设置之后的值)，这个参数只能使用在Jdk6 update 21以上版本(包括该版本)。`-XX:+PrintFlagsFinal`参数的使用 与上面-`XX:+PrintFlagsInitial` 参数使用相同

### 常用的vm参数

#### Heap（堆）内存大小设置
- `-Xms512m` 初始堆大小
- `-Xmx1g` 最大堆大小

#### New Generation（新生代）内存大小设置
- `-Xmn256m` 新生代大小
    - 设置JVM的新生代内存大小（－Xmn 是将NewSize与MaxNewSize设为一致。256m）,同下面两个参数
        ```
        -XX:NewSize=256m
        -XX:MaxNewSize=256m
        ```
    - 增大新生代后，将会减小老年代大小。此值对系统性能影响较大。Sun官方推荐配置为整个堆的3/8
- `-XX:NewRatio=4` 新生代(包括Eden和两个Survivor区)与老年代的比值(除去永久代)
    - `-XX:NewRatio=4`表示新生代与老年代所占比值为1:4，新生代占整个堆栈的1/5，Xms=Xmx并且设置了Xmn的情况下，该参数不需要进行设置。

##### Survivor内存大小设置
- `-XX:SurvivorRatio` Eden区与Survivor区的大小比值
    - 设置为8，则两个Survivor区与一个Eden区的比值为2:8,一个Survivor区占整个新生代的1/10

##### Eden内存大小设置
新生代减去2*Survivor的内存大小就是Eden的大小。

#### Old Generation（老年的）的内存大小设置
堆内存减去新生代内存
如上面设置的参数举例如下：
```
老年代初始内存为：512M-256M=256M
老年代最大内存为：1G-256M=768M
```

***
如果配置如下：
```
-Xms1000m
-Xmx1000m
-Xmn300m
```
则堆内存默认为1000m，新生代总大小为300m，

#### Stack(栈)内存大小设置
- `-Xss` 每个线程的堆栈大小
    - JDK5.0以后每个线程堆栈大小为1M，以前每个线程堆栈大小为256K，可以带 K, M 或 G单位

#### ~~Permanent Generation（持久代）内存大小设置~~
方法区内存分配（__JDK8以前的版本使用，JDK8以后没有持久代了，使用的MetaSpace__）
```
-XX: PermSize=128m 设置持久代初始内存大小128M
-XX:MaxPermSize=512m 设置持久代最大内存大小512M
```

##### Metaspace（元空间）内存大小设置
元空间（Metaspace）(JDK8)
- `-XX:MetaspaceSize=128m` `-XX:MaxMetaspaceSize=512m`**（JDK8）**，JDK8的持久代几乎可用完机器的所有内存，同样设一个128M的初始值，512M的最大值保护一下。
1. 默认情况下，类元数据分配受到可用的本机内存容量的限制（容量依然取决于你使用32位JVM还是64位操作系统的虚拟内存的可用性）。
2. 一个新的参数 (MaxMetaspaceSize)可以使用。允许你来限制用于类元数据的本地内存。如果没有特别指定，元空间将会根据应用程序在运行时的需求动态设置大小。

#### Direct ByteBuffer（直接内存）内存大小设置
-XX:MaxDirectMemorySize
> 此参数的含义是当Direct ByteBuffer分配的堆外内存到达指定大小后，即触发Full GC。注意该值是有上限的，默认是64M，最大为sun.misc.VM.maxDirectMemory()，在程序中中可以获得-XX:MaxDirectMemorySize的设置的值。使用NIO可以api可以使用直接内存。

#### 设置新生代代对象进入老年代的年龄
-XX:MaxTenuringThreshold=15
> 设置垃圾最大年龄。如果设置为0的话，则新生代对象不经过Survivor区，直接进入老年代。对于老年代比较多的应用，可以提高效率。如果将此值设置为一个较大值，则新生代对象会在Survivor区进行多次复制，这样可以增加对象再新生代的存活时间，增加在新生代即被回收的概论。


***
### **java jvm 参数问题**
> JAVA虚拟机设置参数的时候大概分为：`-X` `-XX` `-`
> 如：`-server -XX:+PrintGCDetails  -XX:SurvivorRatio=8 -XX:MaxTenuringThreshold=15 -Xms40M -Xmx40M -Xmn20M`

**为什么设置参数会分为这几种？（以下为找到的一些资料）**

1. java launcher的所有标准参数都有文档描述（Standard Options）段落下：
Windows: http://docs.oracle.com/javase/7/docs/technotes/tools/windows/java.html
Solaris和Linux: http://docs.oracle.com/javase/7/docs/technotes/tools/solaris/java.html

    - 兼容性好的JDK/JRE里的java launcher应该支持几乎所有标准参数。只有用于选择VM用的-client/-server这些不一定被支持（因为这个参数就是VM的名字，而VM的名字大家都不一样）。

2. -XX:开头的参数，这些是HotSpot VM特有的参数，或者叫VM flags。别的JVM不需要支持这些参数；在版本之间HotSpot VM所支持的-XX:参数也不一定一样。这些参数最主要是给JVM的开发者调整、调优VM用的，外部用户要用的话自担责任（use at your own risk）。

3. -X开头的参数被称为非标准参数（Non-standard Option）。通过java -X可以看到自己用的java launcher支持哪些non-standard option。
这些参数之中有许多都是事实上的标准，兼容性好的JDK/JRE也应该支持，例如-Xmx、-Xms、-Xss等。
有些-X参数则不那么流行，例如-Xmixed、-Xint这些本来都只是给HotSpot VM用的，不一定被别的JDK/JRE支持。
