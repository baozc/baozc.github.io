### zookeeper cli

使用`zkCli`使用进入zookeeper命令行界面，可以指定参数`-server ip:port`进入指定服务
```
Connecting to localhost:2181
Welcome to ZooKeeper!
JLine support is enabled

WATCHER::

WatchedEvent state:SyncConnected type:None path:null
[zk: localhost:2181(CONNECTED) 0]
```

#### 命令行工具的一些简单操作如下：
1. 显示根目录下、文件： `ls /` 使用 ls 命令来查看当前 ZooKeeper 中所包含的内容
2. 显示根目录下、文件： `ls2 /` 查看当前节点数据并能看到更新次数等数据
3. 创建文件，并设置初始内容： `create /zk "test"` 创建一个新的 znode节点“ zk ”以及与它关联的字符串
4. 获取文件内容： `get /zk` 确认 znode 是否包含我们所创建的字符串
5. 修改文件内容： `set /zk` "zkbak" 对 zk 所关联的字符串进行设置
6. 删除文件： `delete /zk` 将刚才创建的 znode 删除
7. 退出客户端： `quit`
8. 帮助命令： `help`

##### connect命令
连接zk服务端，与close命令配合使用可以连接或者断开zk服务端。
如`connect 127.0.0.1:2181`

##### get命令
获取节点信息，注意节点的路径皆为绝对路径，也就是说必要要从/（根路径）开始。
```
[zk: localhost:2181(CONNECTED) 1] get /zk
test
cZxid = 0x2
ctime = Wed Mar 13 13:49:21 CST 2019
mZxid = 0x2
mtime = Wed Mar 13 13:49:21 CST 2019
pZxid = 0x2
cversion = 0
dataVersion = 0
aclVersion = 0
ephemeralOwner = 0x0
dataLength = 4
numChildren = 0
[zk: localhost:2181(CONNECTED) 2]
```
- `test`为节点数据
- `cZxid`节点创建时的`zxid`
- `ctime`节点创建时间
- `mZxid`节点最近一次更新时的`zxid`
- `mtime`节点最近一次更新的时间
- `cversion`子节点数据更新次数
- `dataVersion`本节点数据更新次数
- `aclVersion`节点ACL(授权信息)的更新次数
- `ephemeralOwner`如果该节点为临时节点,`ephemeralOwner`值表示与该节点绑定的session id. 如果该节点不是临时节点,`ephemeralOwner`值为0
- `dataLength`节点数据长度，本例中为`test`的长度
- `numChildren`子节点个数

##### ls命令
获取路径下的节点信息，注意此路径为绝对路径，类似于linux的ls命令。
```zookeeper
[zk: localhost:2181(CONNECTED) 2] ls /
[zk, zk1, services, zookeeper]
[zk: localhost:2181(CONNECTED) 3]
```
表示`/`节点下存在`zk, zk1, services, zookeeper`几个节点

##### ls2命令
ls2为ls命令的扩展，比ls命令多输出本节点信息。
```
[zk: localhost:2181(CONNECTED) 4] ls2 /
[zk, zk1, services, zookeeper]
cZxid = 0x0
ctime = Thu Jan 01 08:00:00 CST 1970
mZxid = 0x0
mtime = Thu Jan 01 08:00:00 CST 1970
pZxid = 0x1e
cversion = 2
dataVersion = 0
aclVersion = 0
ephemeralOwner = 0x0
dataLength = 0
numChildren = 4
[zk: localhost:2181(CONNECTED) 5]
```

##### set命令
设置节点的数据。
```
[zk: localhost:2181(CONNECTED) 3] set /zk "hello world"
cZxid = 0x2
ctime = Wed Mar 13 13:49:21 CST 2019
mZxid = 0x71
mtime = Wed Mar 13 17:05:01 CST 2019
pZxid = 0x2
cversion = 0
dataVersion = 1
aclVersion = 0
ephemeralOwner = 0x0
dataLength = 11
numChildren = 0
[zk: localhost:2181(CONNECTED) 4]
```

##### rmr命令
删除节点命令，此命令与`delete`命令不同的是`delete`不可删除有子节点的节点，但是rmr命令可以删除，注意路径为绝对路径。
如`rmr /zookeeper/znode`

##### delquota命令
删除配额，-n为子节点个数，-b为节点数据长度。
如`delquota –n 2`，请参见`listquota`和`setquota`命令。

##### quit命令
退出。

##### printwatches命令
设置和显示监视状态，`on`或者`off`。
如`printwatches on`

##### create命令
创建节点，其中-s为顺序充点，-e临时节点。
如create /zookeeper/node1"test_create" world:anyone:cdrwa
其中acl处，请参见getAcl和setAcl命令。
