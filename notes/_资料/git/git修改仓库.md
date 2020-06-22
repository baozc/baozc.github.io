# 本地项目关联到远程git仓库
初始化`git`仓库
```
git init .
```
设置远程仓库地址
```
git remote add oringi<设置的远程仓库名称> https://gitlab.jinxin.dev/ej-dr/samp1/samp_dqs/dqs-server.git<远程仓库地址>
```
将文件加入git版本管理、提交到tree中
```
git add .
git commit -m 'init'
```
推荐到远程分支

默认远程主机名`origin`，如果相同可以省略

可以通过`git branch -vv`查看本地分支和远程分支关联关系，默认省略了分支关系
```
git push <远程主机名> <本地分支名>:<远程分支名>
```
执行完以上操作，项目就与远程git仓库关联到了一起，可以正常使用了，去git项目页上可以看到刚刚提交的代码

# 有文件的项目关系
```
git init .
git remote add origin 地址
```
拉取远程仓库数据，不拉取后续无法操作
```
git pull
```
会把远程分支拉取下来

## 设置本地分支和远程分支关系
将当前分支设置为远程仓库的master分支
```
git branch --set-upstream-to=origin/master master
```

# 原有资源库地址更改
- 更新远程仓库地址
```
git remote set-url origin https://gitlab.jinxin.dev/ej-dr/samp1/samp_dqs/dqs-server.git
```
- 拉取远程仓库代码
```
git pull
```
- 查看当前所有分支，包括远程分支
```
git branch -a
```
- 查看本地分支和远程分支关系
```
git branch -vv
```
- 如果没有关系需要通过`git branch --set-upstream-to=origin/master master`，建立对应分支关系
- 查看代码状态，推送提交过的代码(新的仓库中没有的，会通过tree自动匹配)

# 解决Git中fatal: refusing to merge unrelated histories
在你操作命令后面加`--allow-unrelated-histories`，例：`git pull --allow-unrelated-histories`
