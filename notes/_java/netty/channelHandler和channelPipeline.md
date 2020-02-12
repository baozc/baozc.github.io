> 使得事件流经 ChannelPipeline 是 ChannelHandler 的工作，它们是在应用程序的初 始化或者引导阶段被安装的。这些对象接收事件、执行它们所实现的处理逻辑，并将数据传递给 链中的下一个 ChannelHandler。它们的执行顺序是由它们被添加的顺序所决定的。实际上， 被我们称为 ChannelPipeline 的是这些 ChannelHandler 的编排顺序。
>
> 在Netty中，有两种发送消息的方式。你可以直接写到Channel中，也可以 写到和Channel- Handler 相关联的 ChannelHandlerContext 对象中。前一种方式将会导致消息从 Channel- Pipeline 的尾端开始流动，而后者将导致消息从 ChannelPipeline 中的下一个 Channel- Handler 开始流动。


## 更加深入地了解 ChannelHandler

### 为什么需要适配器类

有一些适配器类可以将编写自定义的 ChannelHandler 所需要的努力降到最低限度，因为它们提供了定义在对应接口中的所有方法的默认实现。

下面这些是编写自定义 ChannelHandler 时经常会用到的适配器类:
- ChannelHandlerAdapter
- ChannelInboundHandlerAdapter
- ChannelOutboundHandlerAdapter
- ChannelDuplexHandler

### 编码器和解码器
　　当你通过 Netty 发送或者接收一个消息的时候，就将会发生一次数据转换。
　　通常来说，这些基类的名称将类似于 ByteToMessageDecoder 或 MessageToByte- Encoder。对于特殊的类型，你可能会发现类似于 ProtobufEncoder 和 ProtobufDecoder 这样的名称——预置的用来支持 Google 的 Protocol Buffers。
　　你将会发现对于入站数据来说，channelRead 方法/事件已经被重写了。对于每个从入站 Channel 读取的消息，这个方法都将会被调用。随后，它将调用由预置解码器所提供的 decode() 方法，并将已解码的字节转发给 ChannelPipeline 中的下一个 ChannelInboundHandler。
　　出站消息的模式是相反方向的:编码器将消息转换为字节，并将它们转发给下一个 ChannelOutboundHandler。

### 抽象类 SimpleChannelInboundHandler
　　最常见的情况是，你的应用程序会利用一个 ChannelHandler 来接收解码消息，并对该数据应用业务逻辑。要创建一个这样的 ChannelHandler，你只需要扩展基类 SimpleChannel- InboundHandler<T>，其中 T 是你要处理的消息的 Java 类型 。在这个 ChannelHandler 中， 你将需要重写基类的一个或者多个方法，并且获取一个到 ChannelHandlerContext 的引用， 这个引用将作为输入参数传递给 ChannelHandler 的所有方法。
　　在这种类型的 ChannelHandler 中，最重要的方法是 channelRead0(Channel- HandlerContext,T)。除了要求不要阻塞当前的 I/O 线程之外，其具体实现完全取决于你。我 们稍后将对这一主题进行更多的说明。

### Channel的方法
| 方法名        | 描述                                                                         |
| ------------- | ---------------------------------------------------------------------------- |
| eventLoop     | 返回分配给 Channel 的 EventLoop                                              |
| pipeline      | 返回分配给 Channel 的 ChannelPipeline                                        |
| isActive      | 如果 Channel 是活动的，则返回 true。活动的意义可能依赖于底层的传输。         |
| localAddress  | 返回本地的 SokcetAddress                                                     |
| remoteAddress | 返回远程的 SokcetAddress                                                     |
| write         | 将数据写到远程节点。这个数据将被传递给 ChannelPipeline，并且排队直到它被冲刷 |
| flush         | 将之前已写的数据冲刷到底层传输，如一个 Socket                                |
| writeAndFlush | 一个简便的方法，等同于调用write()并接着调用flush()                           |
