# shell脚本语言测试示例
# 用到输入、输出，判断比较，数值运算等
# 可以实现自定义颜色输出

#if [ -z $1 ]; then
#  echo -e "输入为空"
#else
#  echo -e "第一个参数是：$1"
#fi

green="\033[32m";
blue="\033[34m";
red="\033[31m";
colorEnd=" \033[0m";

echo -e
echo -e  "$green 辅助计算梦幻装备shell~$colorEnd"
echo -e
echo -e "$green请输入头盔需要的特技：$blue(\"水清\",\"笑里\",\"流云\") $colorEnd"
read tou

declare -i sum=0;

if [[ $tou =~ ^(水清)|sq$ ]]; then
  echo -e " 头盔特技为：$blue水清$colorEnd"
  p1=" 头盔特技为：$blue水清$colorEnd"
  sum=600;
elif [[ $tou =~ ^笑里|xl$ ]]; then

  echo -e " 头盔特技为：$blue笑里$colorEnd"
  p1=" 头盔特技为：$blue笑里$colorEnd"

  sum=450;

elif [[ $tou =~ ^流云|ly$ ]]; then

  echo -e " 头盔特技为：$blue流云$colorEnd"
  p1=" 头盔特技为：$blue流云$colorEnd"

  sum=400;
else
  echo -e "$red 请输入特技名称或字母~！$colorEnd"
  exit 1
fi

echo -e
echo -e "$green请输入饰品需要的特技：$blue(\"水清\",\"笑里\",\"流云\")  $colorEnd"
read shipin

if [[ $shipin =~ ^(水清)|sq$ ]]; then
  echo -e " 饰品特技为：$blue水清$colorEnd"
  p2=" 饰品特技为：$blue水清$colorEnd"
  sum+=700;
elif [[ $shipin =~ ^笑里|xl$ ]]; then

  echo -e " 饰品特技为：$blue笑里$colorEnd"
  p2=" 饰品特技为：$blue笑里$colorEnd"
  sum+=650;

elif [[ $shipin =~ ^流云|ly$ ]]; then

  echo -e " 饰品特技为：$blue流云$colorEnd"
  p2=" 饰品特技为：$blue流云$colorEnd"
  sum+=400;
else
  echo -e "$red请输入特技名称或字母~！$colorEnd"
  exit 1
fi

echo -e
echo -e "$green请输入鞋子需要的特技：$blue(\"水清\",\"笑里\",\"流云\") $colorEnd "
read xizi

if [[ $xizi =~ ^(水清)|sq$ ]]; then
  echo -e " 鞋子特技为：$blue水清$colorEnd"
  p3=" 鞋子特技为：$blue水清$colorEnd"
  sum+=1000;
elif [[ $xizi =~ ^笑里|xl$ ]]; then

  echo -e " 鞋子特技为：$blue笑里$colorEnd"
  p3=" 鞋子特技为：$blue笑里$colorEnd"
  sum+=950;

elif [[ $xizi =~ ^流云|ly$ ]]; then

  echo -e " 鞋子特技为：$blue流云$colorEnd"
  p3=" 鞋子特技为：$blue流云$colorEnd"
  sum+=500;
else
  echo -e "$red请输入特技名称或字母~！$colorEnd"
  exit 1
fi

echo -e
echo -e "$red当前选择的特技为：$colorEnd"
echo -e "$p1"
echo -e "$p2"
echo -e "$p3"
echo -e
echo -e "$red总价格大约为：$colorEnd$sum(RMB)"

exit 0
