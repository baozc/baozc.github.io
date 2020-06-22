## shell script 的追踪与 debug

　　scripts 在执行之前，最怕的就是出现问题了！那么我们如何 debug 呢？有没有办法不需要透过直接执行该 scripts 就可以来判断是否有问题呢！？呵呵！ 当然是有的！我们就直接以 bash 的相关参数来进行判断吧！

```bash    
[root@linux ~]$ sh [-nvx] scripts.sh
参数：
-n ：不要执行 script，仅查询语法的问题；
-v ：再执行 sccript 前，先将 scripts 的内容输出到屏幕上；
-x ：将使用到的 script 内容显示到屏幕上，这是很有用的参数！
#范例：
#范例一：测试 sh16.sh 有无语法的问题？
[root@linux ~]$ sh -n sh16.sh
# 若语法没有问题，则不会显示任何信息！
#范例二：将 sh15.sh 的执行过程全部列出来～
[root@linux ~]$ sh -x sh15.sh
+ PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/home/vbird/bin
+ export PATH
+ for animal in dog cat elephant
+ echo 'There are dogs.... '
There are dogs....
+ for animal in dog cat elephant
+ echo 'There are cats.... '
There are cats....
+ for animal in dog cat elephant
+ echo 'There are elephants.... '
There are elephants....
# 使用 -x 真的是追踪 script 的好方法，他可以将所有有执行的程序段在执行前列出来，
# 如果是程序段落，则输出时，最前面会加上 + 字号，表示他是程序代码而已，
# 实际的输出则与 standard output 有关啊～如上所示。
```

　　在上面的范例二当中，我们可以透过这个简单的参数 -x 来达成 debug 的目的，这可是一个不可多得的参数， 通常如果您执行 script 却发生问题时，利用这个 -x 参数，就可以知道问题是发生在哪一行上面了！

　　熟悉 sh 的用法，将可以使您在管理 Linux 的过程中得心应手！至于在 Shell scripts 的学习方法上面，需要『多看、多模仿、并加以修改成自己的样式！』 是最快的学习手段了！网络上有相当多的朋友在开发一些相当有用的 scripts ，若是您可以将对方的 scripts 拿来，并且改成适合自己主机的样子！那么学习的效果会是最快的呢！
