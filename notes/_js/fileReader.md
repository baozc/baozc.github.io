### 简介
#### 在HTML5中，文件选择标签file增加了如下两个属性：
- multiple：设定当前元素可以选取多个文件。
- accept：设定当前选择器可以选择的MIME类型或后缀名。

`<input type="file" multiple name="" id="myfilePhoto" value="" accept="image/jpg, image/png">`

于此同时，其出现了`FileReader`对象，使用`FileReader`对象,web应用程序可以异步的读取存储在用户计算机上的文件(或者原始数据缓冲)内容,可以使用`File`对象或者`Blob`对象来指定所要处理的文件或数据。

`FileReader`：是window对象的一个构造函数,用于读取文件选择标签选择的File的Dom对象。即用来把文件选择的信息读入内存，并且读取文件中的数据。其接口提供了一个异步API，使用该API可以在浏览器主线程中异步访问文件系统，读取文件中的数据。为了安全FileReader可以读取表单上已经选择的文件，不能读取本地文件，它以二进制信息的方式读取表单文件：主要用于大文件的信息读取。

##### 特点：
> 1. 读取后，二进制信息在浏览器内存中，批量的向服务器进行传输。
> 2. 一般要配合后台程序，第三方插件共同完成
> 3. 断点下载和断点上传

### 使用介绍

#### 创建FileReader对象

##### 想要创建一个FileReader对象,很简单,如下:
`var fr = new FileReader();`

#### FileReader的状态常量：

方法名  | 参数  |  描述
--| --- | --
readAsArrayBuffer  | filefile  | 将文件读取为一个ArrayBuffer对象以表示所读取文件的内容.
readAsBinaryString  | file  | 将文件读取为二进制编码
readAsText  | file  | 将文件读取为文本
readAsDataURL  | file  | 将文件读取为DataURL，读取的内容是加密以后的本地文件路径 终端读取操作
abort  | file  | 终端读取操作

#### FileReader的属性

属性名 | 类型 | 描述
 --   |  -- | --
error  |  DOMError |  在读取文件时发生的错误. 只读.
readyState  |  unsigned short | 表明FileReader对象的当前状态. 值为State constants中的一个. 只读
result  |  jsval |  读取到的文件内容.这个属性只在读取操作完成之后才有效,并且数据的格式取决于读取操作是由哪个方法发起的. 只读.

#### FileReader接口事件
FileReader接口包含了一套完整的事件模型，用于捕获读取文件时的状态。

事件  | 描述
--   | --
onabort  |  中断
onerror  |  出错出错
onloadstart  |  开始
onprogress  |  正在读取
onload  |  成功读取
onloadend  |  读取完成，无论成功失败
