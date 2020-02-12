## 一般命令
1. `version`显示当前版本
2. `status`显示当前状态
3. `sofia status`显示 sofia状态
4. `help`显示帮助

## fs_cli "/"开头的命令
1. `/event`开启事件接收
2. `/noevents`关闭事件接收
3. `/nixevent`除了特定一种外，开启所有事件
4. `/log`设置log级别，如`/log info`或`/log debug`等

### 呼叫
- `originate user/1000 &echo`，呼叫用户1000，听到回声
  - `user/1000` 呼叫字符串，有时也叫 Call URL
- `originate user/1000 &hold`，呼叫用户1000，hold能在等待的同时播放保持音乐
- `originate user/1000 &playback(/root/welcome.wav)`，呼叫用户1000，播放特定的声音

### 桥连
1. 拨打电话1000，`originate user/1000 &park`
2. 拨打电话1234，`originate user/1234 &park`
3. 显示两个通话的通道，`show channels`
4. 桥连两个通话，`uuid_bridge 1000_uuid 1234_uuid`

100543752282
