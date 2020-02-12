测试的标志  | 代表意义
---  |  ---
**1.** | **关于某个档名的『类型』侦测(存在与否)，如 test -e filename**
-e | 该『档名』是否存在？(常用)
-f | 该『档名』是否为档案(file)？(常用)
-d | 该『文件名』是否为目录(directory)？(常用)
-b | 该『文件名』是否为一个 block device 装置？
-c | 该『文件名』是否为一个 character device 装置？
-S | 该『档名』是否为一个 Socket 档案？
-p | 该『档名』是否为一个 FIFO (pipe) 档案？
-L | 该『档名』是否为一个连结档？
**2.** | **关于档案的权限侦测，如 test -r filename**
-r | 侦测该文件名是否具有『可读』的属性？
-w | 侦测该档名是否具有『可写』的属性？
-x | 侦测该档名是否具有『可执行』的属性？
-u | 侦测该文件名是否具有『SUID』的属性？
-g | 侦测该文件名是否具有『SGID』的属性？
-k | 侦测该文件名是否具有『Sticky bit』的属性？
-s | 侦测该档名是否为『非空白档案』？
**3.** | **两个档案之间的比较，如： test file1 -nt file2**
-nt | (newer than)判断 file1 是否比 file2 新
-ot | (older than)判断 file1 是否比 file2 旧
-ef | 判断 file2 与 file2 是否为同一档案，可用在判断 hard link 的判定上。 主要意义在判定，两个档案是否均指向同一个 inode 哩！
**4.** | **关于两个整数之间的判定，例如 test n1 -eq n2**
-eq | 两数值相等 (equal)
-ne | 两数值不等 (not equal)
-gt | n1 大于 n2 (greater than)
-lt | n1 小于 n2 (less than)
-ge | n1 大于等于 n2 (greater than or equal)
-le | n1 小于等于 n2 (less than or equal)
**5.** | **判定字符串的数据**
test -z string | 判定字符串是否为 0 ？若 string 为空字符串，则为 true
test -n string | 判定字符串是否非为 0 ？若 string 为空字符串，则为 false。<br/>注： -n 亦可省略
test str1 = str2 | 判定 str1 是否等于 str2 ，若相等，则回传 true
test str1 != str2 | 判定 str1 是否不等于 str2 ，若相等，则回传 false
**6.** | **多重条件判定，例如： test -r filename -a -x filename**
-a | (and)两状况同时成立！例如 test -r file -a -x file，则 file 同时具有 r 与 x 权限时，才回传 true。
-o | (or)两状况任何一个成立！例如 test -r file -o -x file，则 file具有 r 或 x 权限时，就可回传 true。
! | 反相状态，如 test ! -x file ，当 file 不具有 x 时，回传 true

OK！现在我们就利用 test 来帮我们写几个简单的例子。首先，判断一下， 让使用者输入一个档名，我们判断：

1. 这个档案是否存在，若不存在则给予一个『Filename does not exist』的讯息，并中断程序；
2. 若这个档案存在，则判断他是个档案或目录，结果输出『Filename is regular file』或 『Filename
is directory』
3. 判断一下，执行者的身份对这个档案或目录所拥有的权限，并输出权限数据！

你可以先自行创作看看，然后再跟底下的结果讨论讨论。注意利用 test 与 && 还有 || 等标志！

```shell
[root@linux scripts]# vi sh05.sh
#!/bin/bash
# Program:
# Let user input a filename, the program will search the filename
#  1.) exist? 2.) file/directory? 3.) file permissions
# History:
# 2005/08/25  VBird  First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
# 1. 让使用者输入档名，并且判断使用者是否真的有输入字符串？
echo -e "The program will show you that filename is exist which input by you.\n\n"
read -p "Input a filename : " filename
test -z $filename && echo "You MUST input a filename." && exit 0
# 2. 判断档案是否存在？
test ! -e $filename && echo "The filename $filename DO NOT exist" && exit 0
# 3. 开始判断档案类型与属性
test -f $filename && filetype="regulare file"
test -d $filename && filetype="directory"
test -r $filename && perm="readable"
test -w $filename && perm="$perm writable"
test -x $filename && perm="$perm executable"
# 4. 开始输出信息！
echo "The filename: $filename is a $filetype"
echo "And the permission are : $perm"
```
