### function

　　什么是『函数 (function)』功能啊？简单的说，其实， 函数可以在 shell script 当中做出一个类似自订执行指令的东西，最大的功能是， 可以简化我们很多的程序代码。

```shell
function fname() {
	#程序段
}
```
调用，直接输入函数名（带不带分号不确定）

　　function 也是拥有内建变量的～他的内建变量与 shell script 很类似， 函数名称代表示 $0 ，而后续接的变量也是以 $1, $2... 来取代的～
function 变量作用域，如果需要只在函数内部有效，命名时加上Locate，如`locate name="baozc"`，这样就和外部同名变量不冲突了
function 返回值，1使用return , 2使用变量接收, 3函数内最后一条echo输出
Shell 函数返回值只能是整数，一般用来表示函数执行成功与否，0表示成功，其他值表示失败。如果 return 其他数据，比如一个字符串，往往会得到错误提示：“numeric argument required”。

**function接收参数时，如果参数带空格会当多个参数来接收，需要加双引号，如："$s"**

例：
```shell
export PATH

function printit(){
echo "Your choice is $1"
}

echo "This program will print your selection !"

case $1 in
	"one")
		printit 1
		;;
	"two")
		printit 2
		;;
	"three")
		printit 3
		;;
	*)
		echo "Usage {one|two|three}"
		;;
esac
```
