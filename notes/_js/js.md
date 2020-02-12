### prototype
> **定义和用法**
prototype 属性使您有能力向对象添加属性和方法。
**语法**
``` javascript
object.prototype.name=value
```

#### javascript的方法可以分为三类
1. 类方法
2. 对象方法
3. 原型方法

例1：
``` javascript
function People(name)
{
  this.name=name;
  //对象方法
  this.Introduce=function(){
    alert("My name is "+this.name);
  }
}
//类方法
People.Run=function(){
  alert("I can run");
}
//原型方法
People.prototype.IntroduceChinese=function(){
  alert("我的名字是"+this.name);
}
//测试

var p1=new People("Windking");

p1.Introduce();

People.Run();

p1.IntroduceChinese();
```

总结：
 1. javascript创建对象就是定义函数
 2. javascript对象定义方法和属性有三种方式
	- 在函数内部定义方法和属性，类似java的定义，如例1
	- 使用函数名.prototype定义方法和属性，例2：
	``` javascript
	function scriptBean(){}
	//定义方法
	scriptBean.prototype = {
		_sayHello : function(msg){
			console.log(this.name + " say : " +msg);
		},
		_destroy : function(){
			console.log(this.name + " destroy");
		}
	}
	//定义属性
	scriptBean.prototype.name = "scriptBean";
	//调用
	var bean = new scriptBean();
    //bean.name = "test";
	console.log(bean.name);
	bean._sayHello("hello");
	bean._destroy();
	```

        - 使用prototype定义属性时，要放在定义方法的后面，不然属性会是undefined
    	- 使用prototype和函数内部定义方法和属性，其作用是一样的，都需要实例化函数后才可使用
	- 直接使用函数名定义方法和属性，类似java的静态该当和变量，如：
	``` javascript
    function scriptBean(){}
    //定义方法
    scriptBean.sayHello = function(msg){
    	console.log(this.name + " say : " +msg);
    }
    //定义属性
    scriptBean.name = "scriptBean";
    //调用
    scriptBean.sayHello("hello");
	```
