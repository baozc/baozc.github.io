---
layout: post
name: tools
position: Developer
category: jvm
---
### 参考
- 深入理解java虚拟机
- [jvm性能调优入门][81126e12]

  [81126e12]: https://www.jianshu.com/p/c6a04c88900a "jvm性能调优入门"

### jps 虚拟机进程状况工具

> JDK的很多小工具的名字都参考了UNIX命令的命名方式， jps（ JVM Process Status Tool）是其中的典型。除了名字像UNIX的ps命令之外，它的功能也和ps命令类似：可以列出正在运行的虚拟机进程，并显示虚拟机执行主类（MainClass,main()函数所在的类）名称以及这些进程的本地虚拟机唯一ID（LocalVirtualMachineIdentifier,LVMID）。虽然功能比较单一，但它是使用频率最高的JDK命令行工具，因为其他的JDK工具大多需要输入它查询到的LVMID来确定要监控的是哪一个虚拟机进程。对于本地虚拟机进程来说，LVMID与操作系统的进程ID（ProcessIdentifier,PID）是一致的，使用Windows的任务管理器或者UNIX的ps命令也可以查询到虚拟机进程的LVMID，但如果同时启动了多个虚拟机进程，无法根据进程名称定位时，那就只能依赖jps命令显示主类的功能才能区分了。

列出正在运行的虚拟机进程，
jps 命令格式:
```
jps [-option] [hostid]
```

| 选项 | 作用                                        |
| ---- | ------------------------------------------- |
| q    | 只输出LVMID，省略主类的名称                 |
| m    | 输出main method的参数                       |
| l    | 输出完全的包名，应用主类名，jar的完全路径名 |
| v    | 输出jvm参数                                 |


### jstat
> jstat（ JVM Statistics Monitoring Tool）是用于监视虚拟机各种运行状态信息的命令行工具。它可以显示本地或者远程[1]虚拟机进程中的类装载、内存、垃圾收集、JIT编译等运行数据，在没有GUI图形界面，只提供了纯文本控制台环境的服务器上，它将是运行期定位虚拟机性能问题的首选工具。

jstat 命令格式:
```
jstat -<option> <pid> [interval[s|ms]]
```
参数interval和count代表查询间隔和次数，如果省略这两个参数，说明只查询一次。假设需要每250毫秒查询一次进程2764垃圾收集状况，一共查询20次，那命令应当是：
```
jstat- gc 2764 250 20
```

选项option代表着用户希望查询的虚拟机信息，主要分为3类：类装载、垃圾收集、运行期编译状况，具体选项及作用请参考表4-3中的描述。

| 选项           | 作用|
| -------------- | ---------------------------------------------------- |
| gc             | 输出每个堆区域的当前可用空间以及已用空间，GC执行的总次数，GC操作累计所花费的时间。|
| gccapactiy     | 输出每个堆区域的最小空间限制（ms）/最大空间限制（mx），当前大小，每个区域之上执行GC的次数。（不输出当前已用空间以及GC执行时间）。 |
| gccause        | 输出-gcutil提供的信息以及最后一次执行GC的发生原因和当前所执行的GC的发生原因。         |
| gcnew          | 输出新生代空间的GC性能数据。 |
| gcnewcapacity  | 输出新生代空间的大小的统计数据。|
| gcold          | 输出老年代空间的GC性能数据。|
| gcoldcapacity  | 输出老年代空间的大小的统计数据。|
| gcpermcapacity | 输出持久带空间的大小的统计数据。|
| gcutil         | 输出每个堆区域使用占比，以及GC执行的总次数和GC操作所花费的事。 |

```
S0C    S1C    S0U    S1U      EC       EU        OC         OU       MC     MU    CCSC   CCSU   YGC     YGCT    FGC    FGCT     GCT
20992.0 20992.0  0.0    0.0   375296.0 312895.3  136192.0   39291.7   59096.0 56149.4 8064.0 7509.7     15    0.270   3      0.377    0.647
```

| 列    | 说明                                                       | jstat参数                                             |
| ----- | ---------------------------------------------------------- | ----------------------------------------------------- |
| S0C   | Survivor0空间的大小。单位KB                                | -gc -gccapacity -gcnew -gcnewcapacity                 |
| S1C   | Survivor1空间的大小。单位KB                                | -gc -gccapacity -gcnew -gcnewcapacity                 |
| S0U   | Survivor0已用空间的大小。单位KB                            | -gc -gcnew                                            |
| S1U   | Survivor1已用空间的大小。单位KB                            | -gc -gcnew                                            |
| EC    | Eden空间的大小。单位                                       | -gc -gccapacity -gcnew -gcnewcapacity                 |
| EU    | Eden已用空间的大小。单位KB                                 | -gc-gcnew                                             |
| OC    | 老年代空间的大小。单位KB                                   | -gc -gccapacity -gcold -gcoldcapacity                 |
| OU    | 老年代已用空间的大小。单位KB。                             | -gc -gcold                                            |
| PC    | 持久代空间的大小。单位KB                                   | -gc -gccapacity -gcold -gcoldcapacity -gcpermcapacity |
| PU    | 持久代已用空间的大小。单位KB                               | -gc -gcold                                            |
| YGC   | 新生代空间GC时间发生的次数                                 |                                                       |
| YGCT  | 新生代GC处理花费的时间                                     | -gc-gcnew-gcutil-gccause                              |
| FGC   | full GC发生的次数。                                        |                                                       |
| FGCT  | full GC操作花费的时间。                                    |                                                       |
| GCT   | GC操作花费的总时间                                         |                                                       |
| NGCMN | 新生代最小空间容量，单位KB                                 | -gccapacity -gcnewcapacity                            |
| NGCMX | 新生代最大空间容量，单位KB                                 | -gccapacity -gcnewcapacity                            |
| NGC   | 新生代当前空间容量，单位KB。                               | -gccapacity -gcnewcapacity                            |
| OGCMN | 老年代最小空间容量，单位KB。                               | -gccapacity-gcoldcapacity                             |
| OGCMX | 老年代最大空间容量，单位KB。                               | -gccapacity-gcoldcapacity                             |
| OGC   | 老年代当前空间容量制，单位KB。                             | -gccapacity -gcoldcapacity                            |
| PGCMN | 持久代最小空间容量，单位KB。                               | -gccapacity -gcpermcapacity                           |
| PGCMX | 持久代最大空间容量，单位KB。                               | -gccapacity -gcpermcapacity                           |
| PGC   | 持久代当前空间容量，单位KB。                               | -gccapacity -gcpermcapacity                           |
| PC    | 持久代当前空间大小，单位KB。                               | -gccapacity -gcpermcapacity                           |
| PU    | 持久代当前已用空间大小，单位KB。                           | -gc -gcold                                            |
| LGCC  | 最后一次GC发生的原因。                                     | -gccause                                              |
| GCC   | 当前GC发生的原因。                                         | -gccause                                              |
| TT    | 老年化阈值。被移动到老年代之前，在新生代空存活的次数。     | -gcnew                                                |
| MTT   | 最大老年化阈值。被移动到老年代之前，在新生代空存活的次数。 |                                                       |
| DSS   | 幸存者区所需空间大小，单位KB。                             |                                                       |



### jinfo Java 配置信息工具

> jinfo（ Configuration Info for Java）的作用是实时地查看和调整虚拟机各项参数。使用jps命令的-v参数可以查看虚拟机启动时显式指定的参数列表，但如果想知道未被显式指定的参数的系统默认值，除了去找资料外，就只能使用jinfo的-flag选项进行查询了（如果只限于JDK1.6或以上版本的话，使用java-XX:+PrintFlagsFinal查看参数默认值也是一个很好的选择），jinfo还可以使用-sysprops选项把虚拟机进程的System.getProperties()的内容打印出来。这个命令在JDK1.5时期已经随着Linux版的JDK发布，当时只提供了信息查询的功能，JDK1.6之后，jinfo在Windows和Linux平台都有提供，并且加入了运行期修改参数的能力，可以使用-flag[+|-]name或者-flagname=value修改一部分运行期可写的虚拟机参数值。JDK1.6中，jinfo对于Windows平台功能仍然有较大限制，只提供了最基本的-flag选项。
jinfo 命令格式：
```
jinfo [option] pid
```
执行样例： 查询 CMSInitiatingOccupancyFraction 参数值。
```
 C:\ ＞ jinfo- flag CMSInitiatingOccupancyFraction 1444 -XX: CMSInitiatingOccupancyFraction= 85
 ```

 ### jmap Java 内存映像工具

 >  jmap（MemoryMapforJava）命令用于生成堆转储快照（一般称为heapdump或dump文件）。如果不使用jmap命令，要想获取Java堆转储快照，还有一些比较“暴力”的手段：譬如在第2章中用过的-XX:+HeapDumpOnOutOfMemoryError参数，可以让虚拟机在OOM异常出现之后自动生成dump文件，通过-XX:+HeapDumpOnCtrlBreak参数则可以使用[Ctrl]+[Break]键让虚拟机生成dump文件，又或者在Linux系统下通过Kill-3命令发送进程退出信号“吓唬”一下虚拟机，也能拿到dump文件。

>  jmap的作用并不仅仅是为了获取dump文件，它还可以查询finalize执行队列、Java堆和永久代的详细信息，如空间使用率、当前用的是哪种收集器等。

>  和jinfo命令一样，jmap有不少功能在Windows平台下都是受限的，除了生成dump文件的-dump选项和用于查看每个类的实例、空间占用统计的-histo选项在所有操作系统都提供之外，其余选项都只能在Linux/Solaris下使用。

生成堆存储快照
jmap 命令格式:
```
jmap [ -option ] <pid>
```

| 选项  | 作用                                                                                              |
| ----- | ------------------------------------------------------------------------------------------------- |
| dump  | 生成堆存储快照，格式为：-dump:[live, ]format=b, file=<filename>，live说明是否只dump出存活的对象。 |
| heap  | 显示java堆详细信息，如使用那种回收器、参数配置、分代状况等。                                      |
| histo |  显示堆中对象统计信息，包括类、实例数量、合计容量。                                                                                                 |

### jstack Java 堆栈跟踪工具

> jstack（ Stack Trace for Java）命令用于生成虚拟机当前时刻的线程快照（一般称为threaddump或者javacore文件）。线程快照就是当前虚拟机内每一条线程正在执行的方法堆栈的集合，生成线程快照的主要目的是定位线程出现长时间停顿的原因，如线程间死锁、死循环、请求外部资源导致的长时间等待等都是导致线程长时间停顿的常见原因。线程出现停顿的时候通过jstack来查看各个线程的调用堆栈，就可以知道没有响应的线程到底在后台做些什么事情，或者等待着什么资源。

jstack 命令格式:
```
jstack [option] vmid
```
