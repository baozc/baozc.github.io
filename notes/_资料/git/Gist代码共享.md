> **摘自GitHub入门与实践**

---

> Gist，Gist 功能主要用于管理及发布一些没必要保存在仓库中的代码，比如小的代码片段等。系统会自动管理更新历史，并且提供了 Fork 功能。另外，通过 Gist还可以很方便地为同事编写代码示例。

## 通过Gist轻松实现代码共享
>Gist A 是一款简单的 Web 应用程序，常被开发者们用来共享示例代码和错误信息。开发者在线交流时难免会涉及软件日志的内容，但直接发送日志会占据很大的篇幅，给交流带来不便。这种情况下，笔者习惯把日志粘贴到 Gist，然后将 URL 发送给对方。

>此外，Gist 还可以用在如下场合。
- 代替记事本记录简短代码段
- 给对方发送示例代码
- 使用 Gist 处理这类情况可以省去不少麻烦。

### Gist 的特点
>Gist 最大的特点是可以与其他人轻松分享示例代码。它使用JavaScript 编写的 Ace B 编辑器，只需打开浏览器便可编写简单代码。

>另外，Gist 中的文档都在版本管理系统的管理之下，用户可以放心编辑。而且由于其版本历史记录保管在Git 仓库中，所以还可以通过clone 操作将 Gist 获取至本地。共享 Gist 的人之间能够互相添加评论，所有交流都会被记录下来。

>Gist 支持多种语言的语法高亮，可以大幅增强代码可读性。可以说，这一工具就是专为程序员设计的。

### 创建 Gist
- 登录GitHub网站：[GitHub][6254c822]
> 点击gist进入![gist打开方式](http://img0.ph.126.net/VjgcIReVsgVWHQSvXI3LMw==/6631643909795285208.jpg)

> 或者登录gist网站:[https://gist.github.com][83646bf0]

- Gist description... 对当前 Gist 所包含的文件进行简要的说明。说明内容应尽量简明扼要，让自己一看就知道是什么。
    - 此项目并不是必填项，所以如果内容没有值得说明的地方，这一项大可不必填写。
- FileName  including extension... 这一项可供用户指定文件名。系统能够自动识别扩展名，将右侧的语言自动设置为对应种类。
    - 此项目不是必填项，缺省状态下会以“gistfile1. 扩展名”的形式自动分配名称。
- 文件，这个文本框用来编辑文件的内容，可以手动编写也可以从剪贴板粘贴。
    - Gist 可以将 Markdown 语法的标题以及编程语言的方法或函数折叠起来，以大纲形式显示内容。
- 右侧是缩进的设置，可以选择用空格缩进还是 Tab 缩进。再右边是选择缩进幅度的下拉菜单。
-  Add File，一个 Gist 中可以包含多个文件。点击这个按钮可以在下方添加新的文件信息录入框，供用户添加更多文件。
-  Create Secret Gist，通过这个按钮创建的 Gist 不会被公开，只有知道其 URL 的人可以阅览相关内容。
-  Create Public Gist，以当前内容创建 Gist。在 Discover Gists A 上也可以看到创建好的 Gist。每个 Gist 在创建时都会被自动分配一个 URL。

### 查看Gist
>在自己的 Gist 中有 Edit（编辑）和 Delete（删除）按钮。
>
在两者共有的 Advanced Options 中，可以通过 Report as Abuse 来举报不良的 Gist 内容。将 Gist 标记为 Star 后，可以在 Your Gists 的 Starred页快速找到这一 Gist。Your Gists 的相关内容我们将在后面讲到。
>
在其他人的 Gist 下有 Fork 按钮，用户可以根据其他人的 Gist 创建
自己的 Gist。但是这个 Fork 与 GitHub 不同，不可以进行 Pull Request。

- Revisions 可以查看 Gist 的变更历史记录及差别。

![查看Gist选项](http://img0.ph.126.net/y7zCMT6rheZonPTyYa3t8Q==/6632107903699113180.jpg)
- Embed, _Embed this gist your website_
    - 显示将 Gist 分享至博客时所需的 HTML。想在博客上分享语法高亮的代码时可以利用这一功能。
- Clone via HTTPS 显示 clone 所需的https路径。如果是自己的 Gist，在本地编辑后还可以进行 push 等操作。
- Clone via SSH 显示 clone 所需的ssh路径。如果是自己的 Gist，在本地编辑后还可以进行 push 等操作。
- Share,_Copy sharable URL for this gist_
    - 显示当前 Gist 的 URL。分享 Gist 时可以直接将这个 URL 告诉对方。

>通过这款应用，我们可以轻松共享笔记、错误信息以及一些没必要放入仓库的代码片段。各位不妨在日常中多加利用，与其他人共享琐碎信息。


  [6254c822]: https://github.com "GitHub网站"
  [83646bf0]: https://gist.github.com/ "gist网站"
