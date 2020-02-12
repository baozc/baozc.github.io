---
layout: post
name: vm-gc-options
position: Developer
category: jvm
---
### 常用的gc参数
- `-XX:+PrintGC` 输出GC日志
    ```
    [GC (Metadata GC Threshold)  399559K->60116K(544768K), 0.0198954 secs]
    [Full GC (Metadata GC Threshold)  60116K->51814K(599552K), 0.2561579 secs]
    ```
- `-XX:+PrintGCDetails` 输出GC的详细日志
    ```
    [GC (Allocation Failure) [PSYoungGen: 33280K->3521K(38400K)] 33280K->3529K(125952K), 0.0060113 secs] [Times: user=0.01 sys=0.00, real=0.01 secs]
    [GC (Allocation Failure) [PSYoungGen: 36801K->4893K(38400K)] 36809K->4909K(125952K), 0.0079897 secs] [Times: user=0.01 sys=0.00, real=0.01 secs]
    [GC (Allocation Failure) [PSYoungGen: 38173K->5117K(38400K)] 38189K->8268K(125952K), 0.0122021 secs] [Times: user=0.02 sys=0.00, real=0.01 secs]
    [GC (Allocation Failure) [PSYoungGen: 38397K->5115K(71680K)] 41548K->9358K(159232K), 0.0205128 secs] [Times: user=0.01 sys=0.00, real=0.02 secs]
    [GC (Metadata GC Threshold) [PSYoungGen: 70865K->5096K(71680K)] 75108K->12301K(159232K), 0.0114424 secs] [Times: user=0.02 sys=0.00, real=0.01 secs]
    [Full GC (Metadata GC Threshold) [PSYoungGen: 5096K->0K(71680K)] [ParOldGen: 7204K->7830K(53248K)] 12301K->7830K(124928K), [Metaspace: 20588K->20588K(1067008K)], 0.0272125 secs] [Times: user=0.07 sys=0.01, real=0.02 secs]
    ```
- `-XX:+PrintGCTimeStamps` 输出GC的时间戳（以基准时间的形式）(**-XX:+PrintGCDetails -XX:+PrintGCTimeStamps**)
    ```
    1.067: [GC (Allocation Failure) [PSYoungGen: 33280K->3500K(38400K)] 33280K->3508K(125952K), 0.0052656 secs] [Times: user=0.01 sys=0.00, real=0.00 secs]
    1.516: [GC (Allocation Failure) [PSYoungGen: 36780K->4798K(38400K)] 36788K->4814K(125952K), 0.0168708 secs] [Times: user=0.02 sys=0.00, real=0.01 secs]
    1.905: [GC (Allocation Failure) [PSYoungGen: 38078K->5104K(38400K)] 38094K->8303K(125952K), 0.0118276 secs] [Times: user=0.02 sys=0.01, real=0.01 secs]
    2.202: [GC (Allocation Failure) [PSYoungGen: 38384K->5112K(71680K)] 41583K->9356K(159232K), 0.0082443 secs] [Times: user=0.01 sys=0.00, real=0.01 secs]
    2.615: [GC (GCLocker Initiated GC) [PSYoungGen: 66747K->5114K(71680K)] 70991K->12154K(159232K), 0.0119761 secs] [Times: user=0.02 sys=0.01, real=0.01 secs]
    2.645: [GC (Metadata GC Threshold) [PSYoungGen: 9792K->5591K(141824K)] 16832K->12639K(229376K), 0.0073965 secs] [Times: user=0.02 sys=0.00, real=0.00 secs]
    2.653: [Full GC (Metadata GC Threshold) [PSYoungGen: 5591K->0K(141824K)] [ParOldGen: 7047K->5690K(46080K)] 12639K->5690K(187904K), [Metaspace: 20890K->20890K(1069056K)], 0.0269697 secs] [Times: user=0.06 sys=0.00, real=0.03 secs]
    ```
- `-XX:+PrintGCDateStamps` 输出GC的时间戳（以日期的形式，如 2013-05-04T21:53:59.234+0800）(**-XX:+PrintGCDetails -XX:+PrintGCDateStamps**)
    ```
    2019-01-11T15:39:42.287-0800: 1.109: [GC (Allocation Failure) [PSYoungGen: 33280K->3521K(38400K)] 33280K->3529K(125952K), 0.0064544 secs] [Times: user=0.01 sys=0.00, real=0.01 secs]
    2019-01-11T15:39:42.656-0800: 1.478: [GC (Allocation Failure) [PSYoungGen: 36801K->4891K(38400K)] 36809K->4907K(125952K), 0.0079733 secs] [Times: user=0.01 sys=0.01, real=0.01 secs]
    2019-01-11T15:39:42.995-0800: 1.817: [GC (Allocation Failure) [PSYoungGen: 38171K->5116K(38400K)] 38187K->8278K(125952K), 0.0117279 secs] [Times: user=0.02 sys=0.00, real=0.01 secs]
    2019-01-11T15:39:43.248-0800: 2.070: [GC (Allocation Failure) [PSYoungGen: 38396K->5110K(71680K)] 41558K->9318K(159232K), 0.0125445 secs] [Times: user=0.02 sys=0.00, real=0.02 secs]
    2019-01-11T15:39:43.682-0800: 2.504: [GC (Metadata GC Threshold) [PSYoungGen: 70384K->5112K(71680K)] 74592K->12267K(159232K), 0.0115870 secs] [Times: user=0.02 sys=0.00, real=0.01 secs]
    2019-01-11T15:39:43.694-0800: 2.516: [Full GC (Metadata GC Threshold) [PSYoungGen: 5112K->0K(71680K)] [ParOldGen: 7154K->7856K(55808K)] 12267K->7856K(127488K), [Metaspace: 20591K->20591K(1067008K)], 0.0306414 secs] [Times: user=0.07 sys=0.00, real=0.03 secs]
    ```
- `-XX:+PrintHeapAtGC` 在进行GC的前后打印出堆的信息(**-XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintHeapAtGC**)
    ```
    {Heap before GC invocations=1 (full 0):
     PSYoungGen      total 38400K, used 33280K [0x0000000795580000, 0x0000000798000000, 0x00000007c0000000)
      eden space 33280K, 100% used [0x0000000795580000,0x0000000797600000,0x0000000797600000)
      from space 5120K, 0% used [0x0000000797b00000,0x0000000797b00000,0x0000000798000000)
      to   space 5120K, 0% used [0x0000000797600000,0x0000000797600000,0x0000000797b00000)
     ParOldGen       total 87552K, used 0K [0x0000000740000000, 0x0000000745580000, 0x0000000795580000)
      object space 87552K, 0% used [0x0000000740000000,0x0000000740000000,0x0000000745580000)
     Metaspace       used 9204K, capacity 9402K, committed 9728K, reserved 1058816K
      class space    used 1131K, capacity 1190K, committed 1280K, reserved 1048576K
    2019-01-11T15:41:15.316-0800: 1.020: [GC (Allocation Failure) [PSYoungGen: 33280K->3559K(38400K)] 33280K->3567K(125952K), 0.0055965 secs] [Times: user=0.01 sys=0.00, real=0.01 secs]
    Heap after GC invocations=1 (full 0):
     PSYoungGen      total 38400K, used 3559K [0x0000000795580000, 0x0000000798000000, 0x00000007c0000000)
      eden space 33280K, 0% used [0x0000000795580000,0x0000000795580000,0x0000000797600000)
      from space 5120K, 69% used [0x0000000797600000,0x0000000797979d50,0x0000000797b00000)
      to   space 5120K, 0% used [0x0000000797b00000,0x0000000797b00000,0x0000000798000000)
     ParOldGen       total 87552K, used 8K [0x0000000740000000, 0x0000000745580000, 0x0000000795580000)
      object space 87552K, 0% used [0x0000000740000000,0x0000000740002000,0x0000000745580000)
     Metaspace       used 9204K, capacity 9402K, committed 9728K, reserved 1058816K
      class space    used 1131K, capacity 1190K, committed 1280K, reserved 1048576K
    }
    {Heap before GC invocations=2 (full 0):
     PSYoungGen      total 38400K, used 36839K [0x0000000795580000, 0x0000000798000000, 0x00000007c0000000)
      eden space 33280K, 100% used [0x0000000795580000,0x0000000797600000,0x0000000797600000)
      from space 5120K, 69% used [0x0000000797600000,0x0000000797979d50,0x0000000797b00000)
      to   space 5120K, 0% used [0x0000000797b00000,0x0000000797b00000,0x0000000798000000)
     ParOldGen       total 87552K, used 8K [0x0000000740000000, 0x0000000745580000, 0x0000000795580000)
      object space 87552K, 0% used [0x0000000740000000,0x0000000740002000,0x0000000745580000)
     Metaspace       used 11948K, capacity 12250K, committed 12416K, reserved 1060864K
      class space    used 1493K, capacity 1587K, committed 1664K, reserved 1048576K
    2019-01-11T15:41:15.739-0800: 1.444: [GC (Allocation Failure) [PSYoungGen: 36839K->4767K(38400K)] 36847K->4783K(125952K), 0.0060933 secs] [Times: user=0.01 sys=0.00, real=0.01 secs]
    Heap after GC invocations=2 (full 0):
     PSYoungGen      total 38400K, used 4767K [0x0000000795580000, 0x0000000798000000, 0x00000007c0000000)
      eden space 33280K, 0% used [0x0000000795580000,0x0000000795580000,0x0000000797600000)
      from space 5120K, 93% used [0x0000000797b00000,0x0000000797fa7d48,0x0000000798000000)
      to   space 5120K, 0% used [0x0000000797600000,0x0000000797600000,0x0000000797b00000)
     ParOldGen       total 87552K, used 16K [0x0000000740000000, 0x0000000745580000, 0x0000000795580000)
      object space 87552K, 0% used [0x0000000740000000,0x0000000740004000,0x0000000745580000)
     Metaspace       used 11948K, capacity 12250K, committed 12416K, reserved 1060864K
      class space    used 1493K, capacity 1587K, committed 1664K, reserved 1048576K
    }
    ```
- `-Xloggc:../logs/gc.log ` 日志文件的输出路径
