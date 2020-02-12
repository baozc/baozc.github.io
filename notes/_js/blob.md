### 简介
>[blob][2a1f7dfe]

`Blob`(Binary Large Object)术语最初来自数据库，早期数据库因为要存储声音、图片、以及可执行程序等二进制数据对象所以给该类对象取名为`Blob`。

  [2a1f7dfe]: https://blog.csdn.net/gentlycare/article/details/50445014 "blob"

在Web领域，`Blob`被定义为包含只读数据的类文件对象。`Blob`中的数据不一定是js原生数据形式。常见的File接口就继承自`Blob`，并扩展它用于支持用户系统的本地文件。

### 构建一个`Blob`对象通常有三种方式
1. 通过`Blob`对象的构造函数来构建。
2. 从已有的`Blob`对象调用slice接口切出一个新的`Blob``对象。
3. `canvas API toBlob`方法，把当前绘制信息转为一个`Blob`对象。

### 下面分别看看3种方式的实现

#### 构造函数
`var blob = new Blob(array[optional], options[optional]);`

>1. `array`(可选): 一个数组。数组元素可以是：`ArrayBuffer`、`ArrayBufferView`、`Blob`、`DOMString`.或者他们的组合。
>2. `options`(可选): 包含了两个属性的对象，用于指定`Blob`对象的属性，其两个属性分别是：
>  1. type -- MIME 的类型，用于指定将要放入`Blob`中的数据的类型(`MIME`)
>  2. `ndings` -- 决定 append() 的数据格式，（数据中的 \n 如何被转换）可以取值为 `transparent` 或者 `native`（t* 的话不变，n* 的话按操作系统转换；t* 为默认） 。

#### Blob对象的基本属性
>`size` : Blob对象包含的字节数。(只读)
>`type` : Blob对象包含的数据类型MIME，如果类型未知则返回空字符串。
> `isClosed` (只读) : 布尔值，指示 Blob.close() 是否在该对象上调用过。 关闭的 blob 对象不可读。

#### Blob对象的基本方法
>- `Blob.close()`
> 关闭 Blob 对象，以便能释放底层资源。
>- `Blob.slice([start, [end, [content-type]]])`
> 返回一个新的 Blob 对象，包含了源 Blob 对象中指定范围内的数据。其实就是对这个blob中的数据进行切割，我们在对文件进行分片上传的时候需要使用到这个方法。

### 使用旧方法创建 Blob 对象。
旧的方法使用 BlobBuilder 来创建一个Blob 实例，并且使用一个 append() 方法，将字符串（或者 ArrayBuffer 或者 Blob，此处用 string 举例）插入，一旦数据插入成功，就可以使用 getBlob() 方法设置一个 mime 。
```javascript
  var builder = new BolbBuilder();
  builder.append("Hello World!");
  var blob = builder.getBlob("text/plain");
```

### 新方法创建Blob 对象
在新的方法中直接可以通过 Blob() 的构造函数来创建了。
构造函数，接受两个参数，第一个为一个数据序列，可以是任意格式的值，例如，任意数量的字符串，Blobs 以及 ArrayBuffers。第二个参数，是一个包含了两个属性的对象，其两个属性分别是：

type -- MIME 的类型。

endings -- 决定 append() 的数据格式，（数据中的 \n 如何被转换）可以取值为 "transparent" 或者 "native"（t* 的话不变，n* 的话按操作系统转换；t* 为默认） 。
```javascript
 var blob = new Blob(["Hello World!"],{type:"text/plain"});
```

### 原生对象构建Blob
```javascript
  var arg = {hello: "2016"};
  var blob = new Blob([JSON.stringify(arg, null, "\t")], {type: "application/json"});
  console.log(blob.type);//application/json
  console.log(blob.size);//20
```
blob.type等于application/json没问题。arg转为字符串后的长度为16加上制表符\t的宽度4个字节等于20。

### 用slice切出一个Blob对象
```javascript
window.onload = function() {
    var arg = {hello: "2016"};
    var str = JSON.stringify(arg, null, "\t");
    var blob = new Blob([str], {type: "application/json"});
    var blob2 = blob.slice();

    console.log(blob2.size);//20
    console.log(blob2.type);//""
}
```
可以看到，原始的Blob对象的type属性并不能传递给新的Blob对象，所以还是要自己指定。
```javascript
window.onload = function() {
    var arg = {hello: "2016"};
    var str = JSON.stringify(arg, null, "\t");
    var blob = new Blob([str], {type: "application/json"});
    var blob2 = blob.slice(0, blob.size, "application/json");
    console.log(blob2.size);//20
    console.log(blob2.type);//application/json
}
```

### blob 转换 string

由于没有现成的方法使blob转换成string，所以需要中转下。

可以使用`FileReader`来读取blob内容。

```javascript
  var blob = new Blob(['H','e','l','l','o'])
	console.log(blob);
	var reader = new FileReader();
	reader.readAsText(blob, 'UTF-8');
	reader.onload = function (e) {
	    console.info(this.result);
	}
```

### Blob对象转File对象
Blob 对象是包含有只读原始数据的类文件对象.File 接口基于 Blob，继承了 Blob 的功能,并且扩展支持用户计算机上的本地文件。
```javascript
var blob=new Blob();
var file = new File([blob], "image.png", {type:"image/png"});
```
