### 利用 if .... then

这个 if .... then 是最常见的条件判断式了～简单的说，就是当符合某个条件判断的时候， 就予以进行某项工作就是了。我们可以简单的这样看：
```shell
if [ 条件判断式 ]; then
	当条件判断式成立时，可以进行的指令工作内容；
fi
```

至于条件判断式的判断方法，与前一小节的介绍相同啊！较特别的是，如果我有多个条件要判别时， 除了sh06.sh 那个案例，也就是将多个条件写入一个中括号内的情况之外， 我还可以有多个中括号来隔开喔！而括号与括号之间，则以 && 或 || 来隔开，他们的意义是：
- && 代表 AND ；
- || 代表 or ；

所以，在使用中括号的判断式中， && 及 || 就与指令下达的状态不同了。举例来说， sh06.sh 那个例子我可以改写成这样：
```shell
[root@linux scripts]$ vi sh06-2.sh
#!/bin/bash
# Program:
# This program will show the user's choice
# History:
# 2005/08/25  VBird  First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
read -p "Please input (Y/N): " yn
if [ "$yn" == "Y" ] || [ "$yn" == "y" ]; then
	echo "OK, continue"
	exit 0
fi
if [ "$yn" == "N" ] || [ "$yn" == "n" ]; then
	echo "Oh, interrupt!"
	exit 0
fi
echo "I don't know what is your choise" && exit 0
```

不过，由这个例子看起来，似乎也没有什么了不起吧？ sh06.sh 还比较简单呢～ 但是，如果我们考虑底下的状态，您就会知道 if then 的好处了：
```shell
if [ 条件判断式 ]; then
	当条件判断式成立时，可以进行的指令工作内容；
else
	当条件判断式不成立时，可以进行的指令工作内容；
fi
```
如果考虑更复杂的情况，则可以使用这个语法：
```shell
if [ 条件判断式一 ]; then
	当条件判断式一成立时，可以进行的指令工作内容；
elif [ 条件判断式二 ]; then
	当条件判断式二成立时，可以进行的指令工作内容；
else
	当条件判断式一与二均不成立时，可以进行的指令工作内容；
fi
```
那我就可以将 sh06-2.sh 改写成这样：
```shell
[root@linux scripts]# vi sh06-3.sh
#!/bin/bash
# Program:
# This program will show the user's choice
# History:
# 2005/08/25  VBird  First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
read -p "Please input (Y/N): " yn
if [ "$yn" == "Y" ] || [ "$yn" == "y" ]; then
	echo "OK, continue"
elif [ "$yn" == "N" ] || [ "$yn" == "n" ]; then
	echo "Oh, interrupt!"
else
	echo "I don't know what is your choise"
fi
```

是否程序变得很简单，而且依序判断，可以避免掉重复判断的状况，这样真的很容易设计程序的啦！ ^\_^ 好了，那么如果我要侦测你所输入的参数是否为 hello 呢 ， 也就是说，如果我想要知道，你在程序后面所接的第一个参数 (就是 $1 啊！) 是否为 hello
1. 如果是的话，就显示 "Hello, how are you ?"；
2. 如果没有加任何参数，就提示使用者必须要使用的参数下达法；
3. 而如果加入的参数不是 hello ，就提醒使用者仅能使用 hello 为参数。

整个程序的撰写可以是这样的：
```shell
[root@linux scripts]# vi sh08.sh
#!/bin/bash
# Program:
# Show "Hello" from $1....
# History:
# 2005/08/28  VBird  First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
if [ "$1" == "hello" ]; then
	echo "Hello, how are you ?"
elif [ "$1" == "" ]; then
	echo "You MUST input parameters, ex> $0 someword"
else
	echo "The only parameter is 'hello'"
fi
```

然后您可以执行这支程序，分别在 $1 的位置输入 hello, 没有输入与随意输入， 就可以看到不同的输出啰～是否还觉得挺简单的啊！ ^\_^。事实上， 学到这里，也真的很厉害了～好了，底下我们继续来玩一些比较大一点的啰～ 我们在前一章已经学会了 grep 这个好用的玩意儿，那么多学一个叫做 netstat 的指令， 这个指令可以查询到目前主机有开启的网络服务端口口 (service ports)， 相关的功能我们会在服务器架设篇继续介绍，这里您只要知道，我可以利用『 netstat -tuln 』来取得目前主机有启动的服务，而且取得的信息有点像这样：

```shell
[root@linux ~]# netstat -tuln
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address Foreign Address State
tcp 0 0 0.0.0.0:199 0.0.0.0:* LISTEN
tcp 0 0 :::80 :::* LISTEN
tcp 0 0 :::22 :::* LISTEN
tcp 0 0 :::25 :::* LISTEN
```

上面的重点是特殊字体的那个部分，那些特殊字体的部分代表的就是 port 啰～ 那么每个 port 代表的意义为何呢？几个常见的 port 与相关网络服务的关系是：
- 80: WWW
- 22: ssh
- 21: ftp
- 25: mail

那我如何透过 netstat 去侦测我的主机是否有开启这四个主要的网络服务端口口呢？ 我可以简单的这样去写这个程序喔：
```shell
[root@linux scripts]# vi sh09.sh
#!/bin/bash
# Program:
# Using netstat and grep to detect WWW,SSH,FTP and Mail services.
# History:
# 2005/08/28  VBird  First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
# 1. 先作一些告知的动作而已～
echo "Now, the services of your Linux system will be detect!"
echo -e "The www, ftp, ssh, and mail will be detect! \n"
# 2. 开始进行一些测试的工作，并且也输出一些信息啰！
testing=`netstat -tuln | grep ":80 "`
if [ "$testing" != "" ]; then
	echo "WWW is running in your system."
fi
testing=`netstat -tuln | grep ":22 "`
if [ "$testing" != "" ]; then
	echo "SSH is running in your system."
fi
testing=`netstat -tuln | grep ":21 "`
if [ "$testing" != "" ]; then
	echo "FTP is running in your system."
fi
testing=`netstat -tuln | grep ":25 "`
if [ "$testing" != "" ]; then
	echo "Mail is running in your system."
fi
```

这样又能够一个一个的检查啰～是否很有趣啊！ ^\_^。接下来，我们再来玩更难一点的。 我们知道可以利用 date 来显示日期与时间，也可以利用 $((计算式)) 来计算数值运算。 另外， date 也可以用来显示自 19710101 以来的『总秒数』 (请自行查阅 man date 及 infodate) 。那么，您是否可以撰写一支小程序，用来『计算退伍日期还剩几天？』也就是说：
1. 先让使用者输入他们的退伍日期；
2. 再由现在日期比对退伍日期；
3. 由两个日期的比较来显示『还需要几天』才能够退伍的字样。

似乎挺难的样子？其实也不会啦，利用『 date --date="YYYYMMDD" +%s 』就能够达到我们所想要的啰～如果您已经写完了程序，对照底下的写法试看看：
```shell
[root@linux scripts]# vi sh10.sh
#!/bin/bash
# Program:
# Tring to calculate your demobilization date at how many days
#  later...
# History:
# 2005/08/29  VBird  First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
# 1. 告知使用者这支程序的用途，并且告知应该如何输入日期格式？
echo "This program will try to calculate :"
echo "How many days about your demobilization date..."
read -p "Please input your demobilization date (YYYYMMDD ex>20050401): " date2
# 2. 测试一下，这个输入的内容是否正确？利用正规表示法啰～
date_d=`echo $date2 |grep '[0-9]\{8\}'`
if [ "$date_d" == "" ]; then
	echo "You input the wrong format of date...."
	exit 1
fi
# 3. 开始计算日期啰～
declare -i date_dem=`date --date="$date2" +%s`
declare -i date_now=`date +%s`
declare -i date_total_s=$(($date_dem-$date_now))
declare -i date_d=$(($date_total_s/60/60/24))
if [ "$date_total_s" -lt "0" ]; then
	echo "You had been demobilization before: " $((-1*$date_d)) " ago"
else
	declare -i date_h=$(($(($date_total_s-$date_d*60*60*24))/60/60))
	echo "You will be demobilized after $date_d days and $date_h hours."
fi
```

瞧一瞧，这支程序可以帮您计算退伍日期呢～如果是已经退伍的朋友， 还可以知道已经退伍多久了～哈哈！很可爱吧～利用 date 算出自 1971/01/01 以来的总秒数， 再与目前的总秒数来比对，然后以一天的总秒数 (60*60*24) 为基数去计算总日数， 就能够得知两者的差异了～瞧～全部的动作都没有超出我们所学的范围吧～ ^\_^ 还能够避免使用者输入错误的数字，所以多了一个正规表示法的判断式呢～ 这个例子比较难，有兴趣想要一探究竟的朋友，可以作一下课后练习题 关于计算生日的那一题喔！～加油！
