# hashMap面试题

## 能描述一下HashMap的实现原理吗？

底层使用哈希表(数组 + 链表)方式实现，当hash冲突过多，链表过长时(超过默认值8)会转换为红黑树，以实现O(logn)时间复杂度的查找

## put()方法原理
- 判断数组是否为空或者长度是否为0，是则进行`resize`(扩容或者数组初始化)
- 通过hash算法((`n - 1) & hash`)找到数组下标(即i的值)，得到数组元素，为空则新建node节点
- 不为空时，Node节点追加或者转换为红黑树，不涉及Node[]数组操作
  - 找到数组元素，hash相等同 && key相等 || key值相等，则直接覆盖
  - 当前节点node值是treeNode，即红黑树结构，操作红黑树
  - 循环遍历链表中的值，进行节点追加或者转换红黑树操作
    - 遍历当前Node链表，查找`Node.next`为空的节点，进行赋值
    - 如果找到`Node.next`为空节点时，`binCount`已经超过二叉树的阀值`(TREEIFY_THRESHOLD - 1)`
      - 则转换当前Node链表为红黑树
    - 如果当前key等于链表中的值，则不做操作
  - `++size > threshold` 如果当前数组的长度大于扩容阀值，执行`resize()`

## hash()函数是怎么实现的
```java
 return (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16);
 ```

 进行扰动计算，降低哈希冲突的概率

 无符号右移16位，高16位为0，与`hashCode`异或，即高16位和低16位的变化都能对最终得到的结果产生影响。

 即高16位和低16位做异或

 ## hashMap怎么计算下标的
 通过hash对数组长度取余，计算数组下标i

 hashMap中计算：`(n - 1) & hash`

 `(n - 1) & hash == hash % 2^n`

 **& 字符虽然和 % 效果一样，但是操作效率更高**

 ## 如果两个键的hashcode相同，你如何获取值对象？
 HashCode相同，通过equals比较内容获取值对象

 ## resize()扩容

 - 原来下标节点只有一个，重新hash计算下标
 - 如果下标节点是TreeNode，则进行树操作
 - 如果原下标节点是node链表，则数组下标只可能在两个位置
   - 一个是原下标位置
   - 一个是原下标位置 + 原容量

**这个知识点，有点绕，参考源码注释**

 ## 为什么初始容量必须为2 的幂？为什么负载因子为0.75f？为什么要做那么多扰动处理？
 **为了减少哈希冲突**

 ### 容量必须为2 的幂是为了增加取值的可能性，数组下标好算。

2 的n次幂转化为二进制为1后面n个0，在计算下标的时候是`hash & (length - 1)`，也就是`&(n-1)个1`: 初始容量为`length = 4 -> 100`，`length - 1 = 3 -> 11`。

所有的二进制为都为1有什么好处(**没弄懂**)？
- 0/1 & 1 都为它本身
- 0/1 & 0 都为 0

_可以看出&1保证了取值的平均。如果某一位为0 ，比如最后一位，那么它&出来下标就一定是个偶数，减少了HashMap 数组一半的取值，大大增加了冲突的可能。_

### 负载因子为0.75f 是空间与时间的均衡
**太小时：冲突可能性变小，扩容频繁**

**太大时：冲突可能变大，极端情况下查询效率可能会从O(1)退货到O(n)**

- 如果负载因子小，意味着阈值变小。比如容量为10 的HashMap，负载因子为0.5f，那么存储5个就会扩容到20，出现哈希冲突的可能性变小，但是空间利用率不高。适用于有足够内存并要求查询效率的场景。
- 相反如果阈值为1 ，那么容量为10，就必须存储10个元素才进行扩容，出现冲突的概率变大，极端情况下可能会从O(1)退化到O(n)。适用于内存敏感但不要求要求查询效率的场景

## 平时在使用HashMap时一般使用什么类型的元素作为Key？
String或者Integer这样的类

因为这种类是不可变的(Immutable)，并且这些类已经很规范的覆写了`hashCode()`以及`equals()`方法，相同值的`hashCode()`都是一样的。

作为不可变类天生是线程安全的，而且可以很好的优化比如可以缓存hash值，避免重复计算等等

## 如果让你实现一个自定义的class作为HashMap的key该如何实现？
覆写hashCode以及equals方法应该遵循的原则

- 如果两个对象相等(使用equals()方法),那么必须拥有相同的哈希码(使用hashCode()方法).
- 即使两个对象有相同的哈希值(hash code),他们不一定相等.意思就是: 多个不同的对象,可以返回同一个hash值.

## 如何使HashMap变成线程安全的呢?
调用工具类`Collections.synchronizedMap(map)`
```java
HashMap map =new HashMap();
map.put("测试","使map变成有序Map");
Map map1 = Collections.synchronizedMap(map);
```

## HashMap是线程安全的吗？ 如果多个线程操作同一个HashMap对象会产生哪些非正常现象？
- 多线程的put可能导致元素的丢失

两个key的hash值相同，两条线程操作时，可能由于要做链表追加，在判断为空时可能发生并发

- put和get并发时，可能导致get为null

在代码#1位置，用新计算的容量new了一个新的hash表，#2将新创建的空hash表赋值给实例变量table。

注意此时实例变量table是空的。

那么，如果此时另一个线程执行get时，就会get出null。

## HashMap 是浅拷贝，说一说浅拷贝和深拷贝的区别
- 浅拷贝：只复制对象的引用，两个引用仍然指向同一个对象，在内存中占用同一块内存；
- 深拷贝：被复制对象的所有变量都含有与原来的对象相同的值，除去那些引用其他对象的变量；

## 说一说Collections.synchronizedMap()和HashTable 的区别

## 说一说HashMap 如何实现有序(LinkHashMap 和TreeMap)以及他们的差别

## 说一说ConcurrentHashMap 如何实现线程安全

---

参考文章：
- [HashMap面试题：90%的人回答不上来][9346eaeb]
- [HashMap的实现原理+阿里HasMap面试题][94551e9d]
- [【Java 容器面试题】谈谈你对HashMap 的理解][73fdbae6]
- [hashMap为什么是线程不安全的？][122ab27f]

https://www.cnblogs.com/zerotomax/p/8687425.html

  [9346eaeb]: https://www.jianshu.com/p/7af5bb1b57e2 "HashMap面试题：90%的人回答不上来"
  [73fdbae6]: https://juejin.im/post/5c1da988f265da6143130ccc "【Java 容器面试题】谈谈你对HashMap 的理解"
  [94551e9d]: https://blog.csdn.net/lizhen1114/article/details/79001257 "HashMap的实现原理+阿里HasMap面试题"
  [122ab27f]: https://juejin.im/post/5c8910286fb9a049ad77e9a3 "为什么是现在不安全的？"
