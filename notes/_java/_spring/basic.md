---
layout: post
categories: spring
name: basic
tags: spring
# date: 2019-10-12 18:09:20 +0800
---

[SpEL][7e7193f5]

  [7e7193f5]: https://leokongwq.github.io/2019/04/17/spring-spel.html "SpEL"

课程主题
spring核心概念介绍和手写spring基础容器分析

课程目标
1.搞清楚spring全家桶都包含哪些东西？
2.搞清楚spring framework中的各个模块都是什么作用？
3.搞清楚spring基础容器（BeanFactory）和高级容器（ApplicationContext）的区别？
4.搞清楚BeanPostProcessor和BeanFactoryPostProcessor的区别？
5.搞清楚BeanFactory和FactoryBean的区别？
6.搞清楚IoC、DI、AOP这些核心概念
7.搞清楚基础容器BeanFactory的继承体系中的类的作用
8.搞清楚基础容器BeanFactory是如何加载BeanDefinition和并生成Bean实例的

### 一些概念
- IoC（核心中的核心）：Inverse of Control，控制反转。对象的创建权力由程序反转给Spring框架。
- DI（核心中的核心）：Dependency Injection，依赖注入。在Spring框架负责创建Bean对象时，动态的将依赖对象注入到Bean组件中！！
- AOP：Aspect Oriented Programming，面向切面编程。在不修改目标对象的源代码情况下，增强IoC容器中Bean的功能。spring是BOP编程思想的实现。在spring里面一切都是由bean开始。

### 底层接口

- BeanFactory和ApplicationContext的区别：
    1. ApplicationContext接口是继承于BeanFactory接口
    2. BeanFactory创建bean实例的时机是第一次回去该bean实例的时候才去创建。
    3. ApplicationContext创建bean实例的时机，是初始化的时候，一次性创建所有的单例bean的实例。

- BeanPostProcessor和BeanFactoryPostProcessor的区别？
BeanFactoryPostProcessor：可以在bean创建实例之前，对bean的定义信息（BeanDefinition）进行修改
BeanPostProcessor：可以在bean创建实例前后，对bean对象进行后置处理。

- BeanFactory和FactoryBean的区别？
BeanFactory：就是ioc的基础容器，管理着spring中需要管理的所有的bean。
FactoryBean：只是spring容器管理的bean的一员。
	只是这个bean比较特殊，它也可以产生一些指定类型bean的实例。


基本容器BeanFactory的学习
1.通过手写spring基础容器去了解它
分析如何写spring基础容器

简单工厂案例：
public class BeanFactory{

	public Object getBean(String beanName){
		//根据beanName找对应的bean实例
		if("userService".equals(beanName)){
			UserService userService = new UserService();
			UserDao userDao = new UserDao();
			userService.setDao(userDao);
			return userService;
		}....
	}
}

优化之后的BeanFactory

public class BeanFactory{

	//存放着beanname和bean实例的映射关系
	private Map<String,Object> singletons=new HashMap();

	//存放着beanname和bean的定义信息的映射关系
	private Map<String,bean的定义信息> bean的定义信息集合=new HashMap();


	public Object getBean(String beanName){
		//从集合中回去bean实例
		Object obj = singletons.get(beanName);
		// 如果获取不到，则执行bean的创建------如何创建bean？
		// 程序员得告诉spring如何创建bean---通过配置文件告诉spring
		// 配置文件会配置很多的bean信息，所以要建立beanname（key）和bean信息的映射关系
		// 创建bean需要知道哪些信息呢？class信息、是否单例、属性信息、beanName

		//创建完成对象之后，放入单例集合中
		//需要进行DI操作
		//还可能需要一些初始化操作（aop的实现就是在此）。

	}
}

配置文件
<beans>
	<bean name="" class="" scope="singleton">
		<property name="" value=""></property>
	</bean>
</beans>



2.了解BeanFactory的继承体系去了解它
