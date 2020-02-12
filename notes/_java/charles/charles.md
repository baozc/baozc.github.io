---
layout: post
category: 抓包工具
name: charles
tags: 抓包工具
# date: 2019-10-12 18:09:20 +0800
---
## 破解
[破解教程](https://zhile.io/2017/07/07/charles-proxy-usage-and-license.html)

### 外部处理设置

[shadowsocks-NG配置](http://wangjiawen.farbox.com/skill/shadowsocks-work-with-charles)

> Charles 的原理是把自己设置成系统的代理服务器，但是在中国，由于工作需要，我们常常需要使用 Google 搜索，所以大部分程序员都有自己的翻墙软件，而这些软件的基本原理，也是把自己设置成系统的代理服务器，来做到透明的翻墙。

> 为了使得两者能够和平共处，我们可以在 Charles 的External Proxy Settings中，设置翻墙的代理端口以及相关信息。同时，我们也要关闭相关翻墙软件的自动设置，使其不主动修改系统代理，避免 Charles 失效。

打开设置 - 网络 - 高级 - 代理 或者 打开蓝灯 - 设置 - 代理 ，来查看代理端口

charles代理前
![lantern代理](lantern代理.png)

![https://mmbiz.qpic.cn/mmbiz_jpg/n8NnoITA0a8RYCiap5qhmia9YWngXNwdpVnT1YEDFHHDEXNhJjAG1tACYx6CooyibprMEZuh575VCKTq1JZzW0IXw/640?wx_fmt=jpeg&wxfrom=5&wx_lazy=1&wx_co=1](assets/markdown-img-paste-20191107140504864.png)

charles代理后
![网络代理](网络代理.png)

在charles 中设置外部代理，填写host和port

如果抓取 https 包返回结果不可看时，需要设置 ssl proxying - enable ssl proxying 用于启用指定 IP 和端口的监听，如 *:443代表监听所有 URL 端口为443的 https 请求

### 手机抓包
[手机抓包](https://www.jianshu.com/p/8034b451585b)
[https 错误][02336ff0]

**注意：不能开启手机端VPN软件**

  [02336ff0]: https://www.jianshu.com/p/993ffc7e05fa "Client SSL handshake failed - Remote host closed connection during handshake"

### question
- 打开电脑代理后，无法抓包
    - **除了配置不对，可能本地启动了个8888端口的服务，两者端口冲突导致**
    - 修改`charles`端口
- 手机代理抓包，没反应，手机也无法上网
    - 查看手机WIFI代理中IP是否写对，通过alfred获取ip会带个空格，**要去掉**
    - charles获取本地ip有问题，正常应该获取到一个ip，在`help-local ip address`中查看
        - 默认以`local ip address`第一行为准，如下图，本机IP为`192.168.26.94`，但是charles第一行为路由IP，所以在手机端配置代理IP时，需要设置成`192.168.2.1`，如果设置成第二行本机IP，会无法访问网络
        ![](assets/markdown-img-paste-20190719092809430.png)
    - 网线换无线试下
    - 网线插头多插拔几次试试

### 手机端https证书下载
`help - SSL Proxying - Install Charles Root Certificate on a Mobile Device`
