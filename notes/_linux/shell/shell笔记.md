## shell编程习惯
- 使用变量最好加上双引号，如`"$str"`
- 在语句结束时，不用加分号


## 变量

### 赋值
1. 直接使用 `变量=值` 的形式赋值，默认string
2. 如需使用int，需要使用`declare -i 变量名值`，参数含义：
	- `-a` ：将后面的 variable 定义成为数组 (array)
	- `-A` : 设置字典项
	- `-i` ：将后面接的 variable 定义成为整数数字curl -i 127.0.0.1:38099/DataSync/ (integer)
	- `-x` ：用法与 export 一样，就是将后面的 variable 变成环境变量；
	- `-r` ：将一个 variable 的变量设定成为 readonly ，该变量不可被更改内容，也不能 unset
3. int类型，在shell中可以使用 `sum+=100`这样的形式
4. 在调用 shell文件时，可以在.sh后直接加参数 如`sh my.sh bao zhi chao`，这时在shell中就可以用`$1 $2 $3 ..`来取shell文件后面对应的参数
5.  $(( )),它是用来作整数运算的。在 bash 中，$(( )) 的整数运算符号大致有这些：
	1. \+ - * / ：分别为 "加、减、乘、除"。
	2. % ：余数运算
	3. & | ^ !：分别为 "AND、OR、XOR、NOT" 运算。
	4. 在 $(( )) 中的变量名称，可于其前面加 $ 符号来替换，也可以不用，如：$(( $a + $b * $c)) 也可得到 19 的结果
	5. 例：
		```shell
		$ a=5; b=7; c=2
		$ echo $(( a+b*c ))
		19
		$ echo $(( (a+b)/c ))
		6
		$ echo $(( (a*b)%c ))
		1
		```
###  输入/输出重定向
1. 2>&1
2. 0 输入
3. 1 输出
4. 2 错误信息

### 变量使用
1. 使用 `$变量名` 或者 `${变量名}` 调用变量
2. `|`管线命令，可以接收前一个命令的输出或者返回值

### 输出语句
1. `echo`默认换行，可以使用`-n`来不换行
2. `echo -e  "\033[32m 绿色字 \033[0m"`，使用`-e`参数，可以实现输出自定义字体颜色和背景颜色
2. `read 变量名`，可以接收输入的变量值，也可以使用`read -p "提示语句：" -t 等待秒数 变量名`

### 比较，详见test.md
1. bash比较，使用 &&（成功） 和 ||(失败)
2. test 比较，字符串比较
	- 是否相等， test str1 = str2 或者 str1 == str2，在test中= 和 ==是一样的，都是对比数据
	- 不相等， test str1 != str2
	- **`if [表达式] then`** 中，表达式就是test模式，不用加test
3. test 比较，数值比较
	- 相等用 `-eq`
	- 不等用 `-ne`
	- 大于、小于使用 `-gt`，`-lt`等
4. 比较字符串是否为空，使用`if [ -z $str ]; then `为空则返回true

### if [ ]; then
1. `if [ $str1 == "str1" ]; then` ， **在if..then表达式中，要注意几点**
	1. if..then表达式，要使用[];来判断
	2. `[ $str1 == "str1" ]`中括号中的判断，在中括号前后需要有 **空格** 不然会报错
2. `if [[ $str1 =~ regular]] then` 可以使用 [[ =~ ]]形式来使用if的正则
3. 条件判断加&& || 时要双括号[[]]
4. 用`-a -o`时，要用单括号[]
5. `eq lt gt`等符号只支持比较数字

### function
1. 可以像javascript一样定义function
2. shell是面向过程的，所以使用function时必须已经定义
3. 参数使用`$1 $2 $3...`方式获得
4. 使用`return`跳出函数，返回值只能是数字

### 数组、字典
```shell
echo "shell定义字典"
#必须先声明
declare -A dic
dic=([key1]="value1" [key2]="value2" [key3]="value3")

#打印指定key的value
echo ${dic["key1"]}
#打印所有key值
echo ${!dic[*]}
#打印所有value
echo ${dic[*]}
#字典添加一个新元素
dic+=（[key4]="value4"）

#遍历key值
for key in $(echo ${!dic[*]})
do
    echo "$key : ${dic[$key]}"
done

echo "shell定义数组"

#数组
list=("value1" "value2" "value3")
#打印指定下标
echo ${list[1]}
#打印所有下标
echo ${!list[*]}
#打印数组下标
echo ${list[*]}
#数组增加一个元素
list=("${list[@]}" "value3")

#按序号遍历
for i in "${!arr[@]}"; do
    printf "%s\t%s\n" "$i" "${arr[$i]}"
done

#按数据遍历
for NUM in ${ARR[*]}
do
    echo $NUM
done
```
