https://www.hi-linux.com/posts/14346.html

https://deepzz.com/post/how-to-setup-ssh-config.html

https://liam.page/2017/09/12/rescue-your-life-with-SSH-config-file/

https://www.jianshu.com/p/6761199bedba

## ssh配置linux免密登录

### 客户端配置
#### 生成ssh密钥对
1. 在终端输入`ssh-keygen`，下面输入的是：`cloud-tx`
   - 总共要输入三次
     - 第一次：指定密钥名称，不输入默认为`id_rsa` `id_rsa.pub`
     - 第二次：密钥文件密码
     - 第三次：确认密钥文件密码
     - **保证密钥文件的安全，如果输入密码，在ssh登录时，需要输入密码；如果没有输入密码，则在ssh登录时，可以实现无密码登录，默认使用私钥验证**
    ```
    baozc@bogon  ~/.ssh  ssh-keygen -t rsa
    Generating public/private rsa key pair.
    Enter file in which to save the key (/Users/baozc/.ssh/id_rsa): cloud-tx
    Enter passphrase (empty for no passphrase):
    Enter same passphrase again:

    Your identification has been saved in cloud-tx.
    Your public key has been saved in cloud-tx.pub.
    The key fingerprint is:
    SHA256:1rgbssYR3z02YUnwQa7u/7E0QEkSKsAwc19G8Q/7VxY baozc@bogon
    The key's randomart image is:
    +---[RSA 2048]----+
    |  +oo  .=.+++    |
     1 Host github.com
    |   +.o o o =.o   |
    |      o . o.=. E |
    |      .. o *+   .|
    |       oS.+oo.  o|
    |      ...o..=. o |
    |     ...o ...o=  |
    |      oo +   o + |
    |     .. . ....o  |
    +----[SHA256]-----+
    ```

2. 配置ssh config，[config说明][bbd60b4b]
    ```bash
    # 用于我们执行 SSH 命令的时候如何匹配到该配置。
    host tx
        # 主机地址
    	hostname 49.232.57.150
        # 用户名
    	user root
        # 认证文件
    	PreferredAuthentications publickey
    	#IdentityFile ~/.ssh/id_rsa
    	IdentityFile ~/.ssh/cloud-tx
    ```
3. 使用`ssh tx`就会登录到远程主机
   - 相比较原先`ssh root@49.232.57.150`方便许多
   - `scp seaboxdata.zip tx:~`

- 注意：

    **我原先在生成密钥时，设置了文件的安全密码，导致每次ssh时，都需要输入安全密码。困扰我很久……来回弄了好几遍，最后发面是设置安全密码的问题。**

    **如果想要ssh免密登录，需要在生成密钥时，安全密码为空，只验证私钥就可以了**

### 服务端配置
1. 把客户端生成的公钥，添加到`.ssh/authorized_keys`中，添加方法很多，不会google
2. 可以先试下可以不可以，再确定要不要执行以下操作
3. `vim /etc/ssh/sshd_config`，[ssh_config说明][31d43572]
    ```bash
    # 是否允许使用纯 RSA 公钥认证。仅用于SSH-1。默认值是"yes"。
    RSAAuthentication yes
    # 是否允许公钥认证。仅可以用于SSH-2。默认值为"yes"。
    PubkeyAuthentication yes
    # 是否允许使用基于密码的认证。默认为"yes"。
    #PasswordAuthentication yes

    # The default is to check both .ssh/authorized_keys and .ssh/authorized_keys2
    # but this is overridden so installations will only check .ssh/authorized_keys
    # 存放该用户可以用来登录的 RSA/DSA 公钥。 默认值是".ssh/authorized_keys"。
    AuthorizedKeysFile .ssh/authorized_keys
    ```
4. 重启服务，`service sshd restart`
5. 客户端验证ssh


  [bbd60b4b]: https://deepzz.com/post/how-to-setup-ssh-config.html "config"
   [31d43572]: https://www.jianshu.com/p/e87bb207977c "ssh_config"
