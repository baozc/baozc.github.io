# [tig](https://jonas.github.io/tig/)
> tig, 就是把 Git 这个单词倒过来念, 它是一个命令行工具, 日常使用中我用它来取代 Git 最高频的几个操作, 如 git log, git diff 以及 git blame等, 使用常见安装源能够方便地安装它.
>
> Git 和 tig 的关系有点像 top 和 htop, 是一种命令行交互式操作工具 tig 的所有功能都是 Git 命令行已经具备的,  tig 提供了一种直观, 方便快捷的 Git 操作.

## 基本操作
> 可以参考下[这篇文章][420bf051]
1. `j` `k`上、下操作，类似vi
2. `enter` 输入并打开的选定的行
3. 两个窗口时，可以通过tab键切换窗口
4. `Q` or `ctrl + c `退出
5. 在主界面或者日志界面，按t，进入目录树(即可进入此次 commit 中所有文件列表)
6. **查看文件全部提交记录**，`tig filename`
7. **查看某个commit以及以前的提交**，`tig commit-id filename`
3. 根据help界面的绑定键，实现git命令快捷操作

### 比较常用的功能

#### 状态视图
分为三大块，和`git status`相似：
1. **changes to be committed**，添加到暂存区没有提交的文件
2. **changes not staged for commit**，修改的文件，还没有添加到暂存区的
3. **untracked files**，未跟踪的文件，没有添加到git仓库管理的

在这三个模块中，选中文件列表：
- 按<kbd>u</kbd>快捷键，会添加/取消到待提交（类似于`git add`）
- 按<kbd>!</kbd>快捷键，撤销当前修改(`git reset HEAD`)

在暂存区中操作文件：
- 按代码块区分，按<kbd>u</kbd>或者<kbd>i</kbd>
- 选中修改的行，按<kbd>1</kbd>，把当前行添加/取消到待提交

**按大写<kbd>C</kbd>，提交文件( `git cherry-pick` )**

#### 主视图
- 参考help的option toggling，可以切换显示
- 点击回车，会在右侧打开该提交记录的diff界面

#### diff view
- <kbd>[</kbd> <kbd>]</kbd> 显示详细程度+-1行
- <kbd>@</kbd> 按照代码块(提交的修改)的粒度浏览

#### blame view
显示所有修改的记录？

---

### help操作
> 查看help操作前，可以先看下[这篇文章][855fd704]的一些概念介绍。

#### View switching(视图切换)

- <kbd>m</kbd> 主视图（显示当前分支）
- <kbd>d</kbd> 异视图（显示该commit修改了什么）
- <kbd>l</kbd> 日志视图（类似于git log）
- <kbd>t</kbd> 文件树视图（用于查阅当前commit的各个文件）
- <kbd>f</kbd> 过滤视图（快速搜索当前commit的文件名并查阅）
- <kbd>b</kbd> 追责视图（在文件树视图下使用，查看文件的每一行是在哪个commit产生的）
- <kbd>r</kbd> 参考视图（查阅各个分支）
- <kbd>s</kbd>, S 状态视图（即git status）
- <kbd>c</kbd> 描述视图（类似于差异视图）
- <kbd>y</kbd> 藏匿视图（git stash相关，不太懂）
- <kbd>g</kbd> grep视图（在整个项目中搜索关键词）
- <kbd>p</kbd> 呼叫视图（不知道干嘛的）
- <kbd>h</kbd> 帮助视图（即本文）

> 在命令行输入`tig`，进入`tig`主界面后按键切换视图

具体还包括:
- `View manipulation(视图操作)`
- `View manipulation`
- `Cursor navigation`
- `Scrolling`
- `Searching`
- `Misc`
- `Option toggling`
- `search bindings`
- `main bindings`
- `diff bindings`
- `refs bindings`
- `status bindings`
- `stage bindings`
- `stash bindings`

help列举了所有模块可以执行的操作，如：快捷键、操作切换、外部命令等。

**看不懂英文的，可以看github上的[这篇翻译][e6aaad7c]**

[855fd704]: https://www.jianshu.com/p/b8814eed1e52 "tig正确使用姿式"
[420bf051]: https://www.jianshu.com/p/e4ca3030a9d5 "颠覆 Git 命令使用体验的神器"
[e6aaad7c]: https://github.com/bieberg0n/blog/issues/30 "tig 命令快捷键功能翻译"
