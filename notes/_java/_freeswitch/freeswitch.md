# 环境配置

> 分为centOS和Ubuntu系统，两种配置
> [Ubuntu系统配置][f20794d6]，为freeswitch官网文档，但是卡在make上一直有错，执行不下去。
> [centOS系统配置][d3c22bf7]，总体没什么问题，可能会遇到xxx包找不到的问题，自行解决就可以。

## freeswitch配置，使其支持webRtc

freeswitch默认配置为使用sip.js。
默认配置存放在freeswitch安装目录conf文件夹下。

### 修改配置文件
1. 修改`/usr/local/freeswitch/conf/sip_profiles/internal.xml`文件
    ```xml
    # Set these params and save the file:
    <param name="tls-cert-dir" value="/usr/local/freeswitch/certs"/>
    <param name="wss-binding" value=":7443"/>
    ```
2. 修改`/conf/vars.xml`文件中，增加
    ```xml
    <X-PRE-PROCESS cmd=="set" data="proxy_media=true"/>
    ```
    修改`internal_ssl_enable`和`external_ssl_enable`为`true`
    ```xml
    <X-PRE-PROCESS cmd="set" data="internal_ssl_enable=true"/>
    <X-PRE-PROCESS cmd="set" data="external_ssl_enable=true"/>
    ```
3. 修改`/conf/sip_profiles/internal.xml`文件，设置`inbound-proxy-media`和`inbound-late-negotiation`为`true`
    ```xml
    <!--Uncomment to set all inbound calls to proxy media mode-->
    <param name="inbound-proxy-media" value="true"/>
    <!-- Let calls hit the dialplan before selecting codec for the a-leg -->
    <param name="inbound-late-negotiation" value="true"/>
    ```

    **修改配置之后重启FreeSWITCH或者打开FS_Cli输入`reloadxml`，然后测试webRtc。**

>**如果一直报视频编解码问题的错误，可以尝试修改`/conf/var.xml`的配置项`global_codec_prefs` 和 `outbound_codec_prefs`如下(增加可用编解码器)**
> ```xml
> <X-PRE-PROCESS cmd="set" data="global_codec_prefs=OPUS,G722,PCMU,PCMA,GSM,H263,H264,VP8,H263-1998"/>
> <X-PRE-PROCESS cmd="set" data="outbound_codec_prefs=OPUS,G722,PCMU,PCMA,GSM,H263,H264,VP8,H263-19>98"/>
> ```

### freeswitch wss.pem证书配置

sipJS 在本地测试时不用配置，但是需要放到服务器或者外网访问时，sipJS 需要使用wss连接freeswitch服务器，否则功能无法使用。

freeswitch wss.pem证书默认存放在freeswitch安装目录certs中，即`/usr/local/freeswitch/certs/wss.pem`，wss.pem默认只有freeswitch的证书，需要集成服务器的https证书到其中。

集成后的`wss.pem`文件布局，如下：
```pem
-----BEGIN PRIVATE KEY-----
<freeswitch_cert>
-----END PRIVATE KEY-----
-----BEGIN CERTIFICATE-----
<freesiwtch_key>
-----END CERTIFICATE-----


-- Cert, Key and Chain(s) are all contained in a single file in this order:
-----BEGIN CERTIFICATE-----
<https.crt_cert>
-----END CERTIFICATE-----
-----BEGIN RSA PRIVATE KEY-----
<https.key_key>
-----END RSA PRIVATE KEY-----
-----BEGIN CERTIFICATE-----
<https.root_chain>
-----END CERTIFICATE-----
```

**添加的顺序为，证书.crt，证书.key，root.crt**

首先，生成https证书后, 默认后缀是`.crt`,`.key`和`.pem`文件格式是一样的。然后需要把对应证书的内容添加到`wss.pem`中。

***

#### 证书集成

```bash
echo '' >> /usr/local/freeswitch/certs/wss.pem && cat _.u.com.cn.crt >> /usr/local/freeswitch/certs/wss.pem && cat _.u.com.cn.key >> /usr/local/freeswitch/certs/wss.pem && echo '' >> /usr/local/freeswitch/certs/wss.pem && cat root.crt >> /usr/local/freeswitch/certs/wss.pem
```

集成证书后，需要重启服务
**_在浏览器中第一次使用时，需要首先访问`https://域名:7443`，把Https证书下载到本地，否则还是会连接不到wss_**

  [f20794d6]: https://freeswitch.org/confluence/display/FREESWITCH/WebRTC "Ubuntu系统配置"
  [d3c22bf7]: https://sipjs.com/guides/server-configuration/freeswitch/ "centOS系统配置"
