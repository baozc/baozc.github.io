- 分割命令： split

如果你有档案太大，导致一些携带式装置无法复制的问题，嘿嘿！找 split 就对了！ 他可以帮你将一个大档案，依据档案大小或行数来分割，就可以将大档案分割成为小档案了！ 快速又有效啊！真不错～

```
[root@linux ~]# split [-bl] file PREFIX
参数：
-b ：后面可接欲分割成的档案大小，可加单位，例如 b, k, m 等；
-l ：以行数来进行分割。
范例：
范例一：我的 /etc/termcap 有七百多 K，若想要分成 300K 一个档案时？
[root@linux ~]# cd /tmp; split -b 300k /etc/termcap termcap
[root@linux tmp]# ls -l termcap*
-rw-rw-r-- 1 root root 307200 8 月 17 00:25 termcapaa
-rw-rw-r-- 1 root root 307200 8 月 17 00:25 termcapab
-rw-rw-r-- 1 root root 184848 8 月 17 00:25 termcapac
# 那个档名可以随意取的啦！我们只要写上前导文字，小档案就会以
# xxxaa, xxxab, xxxac 等方式来建立小档案的！
范例二：如何将上面的三个小档案合成一个档案，档名为 termcapback
[root@linux tmp]# cat termcap* >> termcapback
# 很简单吧？就用数据流重导向就好啦！简单！
范例三：使用 ls -al / 输出的信息中，每十行记录成一个档案
[root@linux tmp]# ls -al / | split -l 10 - lsroot
# 重点在那个 - 啦！一般来说，如果需要 stdout/stdin 时，但偏偏又没有档案，
# 有的只是 - 时，那么那个 - 就会被当成 stdin 或 stdout ～
```

在 Windows 的情况下，你要将档案分割需要如何作？！伤脑筋吧！呵呵！在 Linux 底下就简单的多了！你要将档案分割的话，那么就使用 -b size 来将一个分割的档案限制其大小，如果是行数的话，那么就使用 -l line 来分割！好用的很！如此一来，你就可以轻易的将你的档案分割成 floppy 的大小，方便你 copy啰！
