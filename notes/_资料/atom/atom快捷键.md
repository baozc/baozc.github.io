<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [atom快捷键](#atom快捷键)
	- [文件操作](#文件操作)
	- [文本操作](#文本操作)
	- [选取](#选取)
	- [目录树操作](#目录树操作)
	- [其它](#其它)
		- [插件快捷键](#插件快捷键)
	- [markdwon-writer 快捷键](#markdwon-writer-快捷键)
		- [atom-beautity](#atom-beautity)
<!-- /TOC -->
# atom快捷键

## 文件操作
- `ctrl-shift-s` 保存所有打开的文件
- `ctrl-shift-o` 打开目录
- `ctrl-p` 从添加的项目中查找文件
- `ctrl-b` 在打开的文件中搜索
- `ctrl-t` 快速多文件切换
- `ctrl-r` 在文件内搜索函数
- `alt-数字` 定位到指定打开文件
- `alt-a` 新建文件在目录路径下

## 文本操作
- `ctrl-up`,`ctrl-down` 使当前行向上或者向下移动
- `ctrl-enter`,ctrl-shift-enter在当前行的下一行或上一行插入新的一行
- `ctrl-shift-D` 复制当前行（或者选中的文本）到下一行
- `alt-backspace`或`ctrl-alt-h`删除到当前子单词开始
- `alt-delete`或`ctrl-alt-d`删除到当前**子**单词结束
- `ctrl-backspace`或`alt-h`删除到当前单词开始
- `alt-d`或ctrl-delete删除到当前子单词开始
- `alt-b` 或 `ctrl-left` 移动到单词开始
- `alt-f` 或 `造词ctrl-right` 移动到单词末尾
- `ctrl-g` 移动到指定行
- `ctrl-j` 将下一行与当前行合并
- `ctrl-shift-K` 或`ctrl-x`**删除当前行**
- `ctrl-k ctrl-l`使当前字符小写
- `ctrl-k ctrl-u`使当前字符大写

## 选取
- `alt-shift-B`或 `ctrl-shift-left` 选取至字符开始
- `alt-shift-F`或`ctrl-shift-right` 选取至字符结束
- `ctrl-a` 全选()
- `alt-f3`选取文档中和当前单词相同的所有单词
- `shift-end` 选取至本行结束
- `ctrl-l` 选取一行，继续按回选取下一行
- `ctrl-d` 选取文档中和当前单词相同的下一处
- `Command + [`    对选中内容向左缩进
- `Command + ]`    对选中内容向右缩进

## 目录树操作
- `ctrl-\`显示或隐藏目录树
- `alt-\`焦点移动或移出目录树
- `a` 在目录树下添加文件
- `d`将当前文件另存为
- `m`将当前文件移动到...
- `alt-right` 和 `alt-left` 展开(隐藏)所有目录
- `ctrl-shift-C` 复制当前文件绝对路径

## 其它
- `ctrl-m` 相应括号之间，html tag之间等跳转
- `ctrl-alt-up`, `ctrl-alt-down` 增加上（下）一行光标
- `ctrl-shift-u` 调出切换编码选项
- `ctrl-f` 在buffer中查找
- `ctrl-shift-f` 在整个工程中查找
- `alt-ctrl-[` 折叠
- `alt-ctrl-]` 展开
- `ctrl-alt-i`调用控制台
- `ctrl-/`注释
- `ctrl-9` 重置字体

***

```java
public void ss(){

}
```

### 插件快捷键
- `ctrl-shift-x` xml文件格式化
- `ctrl-shift-b` 运行script:run
- `ctrl-alt-n` 格式化代码

## markdwon-writer 快捷键
- `ctrl-shift-k` [插入链接][30d316e3]
- `ctrl-i` _斜体字_
- `ctrl-alt-b` **粗体字**
- `ctrl-'` `代码块`
- [ ] `alt-t` 添加任务，未完成 `shift-cmd-x`
- [x] `alt-d` 添加任务，已完成
- `alt-u` 添加无序排列，<kbd>ul</kbd>
- `alt-o` 添加有序排列，<kbd>ol</kbd>
- `ctrl-k` 按一按键次后，直接输入内容。像键盘按键那样展示，如：<kbd>ctrl</kbd>
- `ctrl-h` ~~中划线，废弃~~
- `ctrl-shift-'` {% highlight %}代码高亮，好像不管用{% highlight %}
- `ctrl-alt-1` **1-5表示h1-h5**
- `ctrl-j ctrl-p` 跳转到上个h标签
- `ctrl-j ctrl-n` 跳转到下个h标签
- 其它无快捷键的，可以通过`ctrl-shift-p`输入markdown writer来调用相关指令
### atom-beautity
> 代码美化工具，支持java、c、c++、js、html、json等数据格式
快捷键<kbd>ctrl + alt + b</kbd> 或者 <kbd>ctrl + alt + n</kbd>

  [30d316e3]: https://github.com "github"
