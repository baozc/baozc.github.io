- 一些关键代码的注释

```java
public class HashMap<K,V> extends AbstractMap<K,V>
    implements Map<K,V>, Cloneable, Serializable {

    private static final long serialVersionUID = 362498820763181265L;

    /**
     * 默认的初始容量 - 必须是2的次幂
     * The default initial capacity - MUST be a power of two.
     */
    static final int DEFAULT_INITIAL_CAPACITY = 1 << 4; // aka 16

    /**
     * The maximum capacity, used if a higher value is implicitly specified
     * by either of the constructors with arguments.
     * MUST be a power of two <= 1<<30.
     */
    static final int MAXIMUM_CAPACITY = 1 << 30;

    /**
     * 负载因子
     * 设置成0.75有一个好处，那就是0.75正好是3/4，而capacity又是2的幂。所以，两个数的乘积都是整数。
     * The load factor used when none specified in constructor.
     */
    static final float DEFAULT_LOAD_FACTOR = 0.75f;

    /**
     * 二叉树转换阀值
     * The bin count threshold for using a tree rather than list for a
     * bin.  Bins are converted to trees when adding an element to a
     * bin with at least this many nodes. The value must be greater
     * than 2 and should be at least 8 to mesh with assumptions in
     * tree removal about conversion back to plain bins upon
     * shrinkage.
     */
    static final int TREEIFY_THRESHOLD = 8;

    /**
     * 二叉树转链表阀值
     * 当扩容时，桶中元素个数小于这个值就会把树形的桶元素还原（切分）为链表结构
     *
     * The bin count threshold for untreeifying a (split) bin during a
     * resize operation. Should be less than TREEIFY_THRESHOLD, and at
     * most 6 to mesh with shrinkage detection under removal.
     */
    static final int UNTREEIFY_THRESHOLD = 6;

    /**
     * 当哈希表中的容量大于这个值时，表中的桶才能进行树形化否则桶内元素太多时会扩容
     * ，而不是树形化为了避免进行扩容、树形化选择的冲突，这个值不能小于 4 * TREEIFY_THRESHOLD
     *
     * The smallest table capacity for which bins may be treeified.
     * (Otherwise the table is resized if too many nodes in a bin.)
     * Should be at least 4 * TREEIFY_THRESHOLD to avoid conflicts
     * between resizing and treeification thresholds.
     */
    static final int MIN_TREEIFY_CAPACITY = 64;

    /**
     * Basic hash bin node, used for most entries.  (See below for
     * TreeNode subclass, and in LinkedHashMap for its Entry subclass.)
     */
    static class Node<K,V> implements Map.Entry<K,V> {
        final int hash;
        final K key;
        V value;
        Node<K,V> next;

        Node(int hash, K key, V value, Node<K,V> next) {
            this.hash = hash;
            this.key = key;
            this.value = value;
            this.next = next;
        }

        public final K getKey()        { return key; }
        public final V getValue()      { return value; }
        public final String toString() { return key + "=" + value; }

        public final int hashCode() {
            return Objects.hashCode(key) ^ Objects.hashCode(value);
        }

        public final V setValue(V newValue) {
            V oldValue = value;
            value = newValue;
            return oldValue;
        }

        public final boolean equals(Object o) {
            if (o == this)
                return true;
            if (o instanceof Map.Entry) {
                Map.Entry<?,?> e = (Map.Entry<?,?>)o;
                if (Objects.equals(key, e.getKey()) &&
                    Objects.equals(value, e.getValue()))
                    return true;
            }
            return false;
        }
    }

    /* ---------------- Static utilities -------------- */

    /**
     * Computes key.hashCode() and spreads (XORs) higher bits of hash
     * to lower.  Because the table uses power-of-two masking, sets of
     * hashes that vary only in bits above the current mask will
     * always collide. (Among known examples are sets of Float keys
     * holding consecutive whole numbers in small tables.)  So we
     * apply a transform that spreads the impact of higher bits
     * downward. There is a tradeoff between speed, utility, and
     * quality of bit-spreading. Because many common sets of hashes
     * are already reasonably distributed (so don't benefit from
     * spreading), and because we use trees to handle large sets of
     * collisions in bins, we just XOR some shifted bits in the
     * cheapest possible way to reduce systematic lossage, as well as
     * to incorporate impact of the highest bits that would otherwise
     * never be used in index calculations because of table bounds.
     */
    static final int hash(Object key) {
        int h;
        // 这段代码是为了对key的hashCode进行扰动计算，防止不同hashCode的高位不同但低位相同导致的hash冲突。
        // 为了把高位的特征和低位的特征组合起来，降低哈希冲突的概率，也就是说，尽量做到任何一位的变化都能对最终得到的结果产生影响。
        // 无符号右移16位，高16位为0，与hashCode 异或，即高16位和低16位的变化都能对最终得到的结果产生影响。
        // 在JDK1.8的实现中，优化了高位运算的算法，通过hashCode()的高16位异或低16位实现的：(h = k.hashCode()) ^ (h >>> 16)，主要是从速度、功效、质量来考虑的。
        return (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16);
    }

    /**
     * <a href="https://www.hollischuang.com/archives/2431">运算原理</a><br>
     *
     * 把一个数转化成第一个比他自身大的2的幂
     * 为给定的目标容量返回两个大小的幂。
     *
     * Returns a power of two size for the given target capacity.
     */
    static final int tableSizeFor(int cap) {
        int n = cap - 1;
        n |= n >>> 1;
        n |= n >>> 2;
        n |= n >>> 4;
        n |= n >>> 8;
        n |= n >>> 16;
        return (n < 0) ? 1 : (n >= MAXIMUM_CAPACITY) ? MAXIMUM_CAPACITY : n + 1;
    }

    /* ---------------- Fields -------------- */

    /**
     * 存储数组的变量
     * The table, initialized on first use, and resized as
     * necessary. When allocated, length is always a power of two.
     * (We also tolerate length zero in some operations to allow
     * bootstrapping mechanics that are currently not needed.)
     */
    transient Node<K,V>[] table;

    /**
     * 保留EntrySet，将节点最为【Set<Entry<K, V>>】形式
     * Holds cached entrySet(). Note that AbstractMap fields are used
     * for keySet() and values().
     */
    transient Set<Map.Entry<K,V>> entrySet;

    /**
     * hashMap中键值对的个数
     * The number of key-value mappings contained in this map.
     */
    transient int size;

    /**
     * 用于判断，多线程下访问使用迭代器遍历hashMap时，别的线程修改了map的内容，
     * 【解释，modCount指的是更新次数，迭代器遍历时，可以判断是否被修改】
     *
     * The number of times this HashMap has been structurally modified
     * Structural modifications are those that change the number of mappings in
     * the HashMap or otherwise modify its internal structure (e.g.,
     * rehash).  This field is used to make iterators on Collection-views of
     * the HashMap fail-fast.  (See ConcurrentModificationException).
     */
    transient int modCount;

    /**
     * 临界值，当实际KV个数超过threshold时，HashMap会将容量扩容，threshold＝ 容量*加载因子
     *
     * The next size value at which to resize (capacity * load factor).
     * @serial
     */
    // (The javadoc description is true upon serialization.
    // Additionally, if the table array has not been allocated, this
    // field holds the initial array capacity, or zero signifying
    // DEFAULT_INITIAL_CAPACITY.)
    int threshold;

    /**
     * 加载因子，上面那个是默认的加载因子，这个是实际中使用到的
     * The load factor for the hash table.
     *
     * @serial
     */
    final float loadFactor;

    /* ---------------- Public operations -------------- */

    /**
     * Constructs an empty <tt>HashMap</tt> with the specified initial
     * capacity and load factor.
     *
     * @param  initialCapacity the initial capacity
     * @param  loadFactor      the load factor
     * @throws IllegalArgumentException if the initial capacity is negative
     *         or the load factor is nonpositive
     */
    public HashMap(int initialCapacity, float loadFactor) {
        if (initialCapacity < 0)
            throw new IllegalArgumentException("Illegal initial capacity: " +
                                               initialCapacity);
        if (initialCapacity > MAXIMUM_CAPACITY)
            initialCapacity = MAXIMUM_CAPACITY;
        if (loadFactor <= 0 || Float.isNaN(loadFactor))
            throw new IllegalArgumentException("Illegal load factor: " +
                                               loadFactor);
        this.loadFactor = loadFactor;
        this.threshold = tableSizeFor(initialCapacity);
    }

    /**
     * Constructs an empty <tt>HashMap</tt> with the specified initial
     * capacity and the default load factor (0.75).
     *
     * @param  initialCapacity the initial capacity.
     * @throws IllegalArgumentException if the initial capacity is negative.
     */
    public HashMap(int initialCapacity) {
        this(initialCapacity, DEFAULT_LOAD_FACTOR);
    }

    /**
     * Constructs an empty <tt>HashMap</tt> with the default initial capacity
     * (16) and the default load factor (0.75).
     */
    public HashMap() {
        this.loadFactor = DEFAULT_LOAD_FACTOR; // all other fields defaulted
    }

    /**
     * Returns the number of key-value mappings in this map.
     *
     * @return the number of key-value mappings in this map
     */
    public int size() {
        return size;
    }

    /**
     * Returns <tt>true</tt> if this map contains no key-value mappings.
     *
     * @return <tt>true</tt> if this map contains no key-value mappings
     */
    public boolean isEmpty() {
        return size == 0;
    }

    /**
     * Returns the value to which the specified key is mapped,
     * or {@code null} if this map contains no mapping for the key.
     *
     * <p>More formally, if this map contains a mapping from a key
     * {@code k} to a value {@code v} such that {@code (key==null ? k==null :
     * key.equals(k))}, then this method returns {@code v}; otherwise
     * it returns {@code null}.  (There can be at most one such mapping.)
     *
     * <p>A return value of {@code null} does not <i>necessarily</i>
     * indicate that the map contains no mapping for the key; it's also
     * possible that the map explicitly maps the key to {@code null}.
     * The {@link #containsKey containsKey} operation may be used to
     * distinguish these two cases.
     *
     * @see #put(Object, Object)
     */
    public V get(Object key) {
        Node<K,V> e;
        return (e = getNode(hash(key), key)) == null ? null : e.value;
    }

    /**
     * Associates the specified value with the specified key in this map.
     * If the map previously contained a mapping for the key, the old
     * value is replaced.
     *
     * @param key key with which the specified value is to be associated
     * @param value value to be associated with the specified key
     * @return the previous value associated with <tt>key</tt>, or
     *         <tt>null</tt> if there was no mapping for <tt>key</tt>.
     *         (A <tt>null</tt> return can also indicate that the map
     *         previously associated <tt>null</tt> with <tt>key</tt>.)
     */
    public V put(K key, V value) {
        return putVal(hash(key), key, value, false, true);
    }

    /**
     * Implements Map.put and related methods
     *
     * @param hash hash for key
     * @param key the key
     * @param value the value to put
     * @param onlyIfAbsent if true, don't change existing value
     * @param evict if false, the table is in creation mode.
     * @return previous value, or null if none
     */
    final V putVal(int hash, K key, V value, boolean onlyIfAbsent,
                   boolean evict) {
        /**
         * tab = table, 存储数组的变量
         * p 根据hash计算出当前下标i的值，即tab[i]的值
         * n 当前数组的容量(长度)
         */
        Node<K,V>[] tab; Node<K,V> p; int n, i;

        // 判断数组是否为空或者长度是否为0，是则进行扩容数组初始化
        if ((tab = table) == null || (n = tab.length) == 0)
            n = (tab = resize()).length;

        // 通过hash算法找到数组下标(即i的值)，得到数组元素，为空则新建
        // (n - 1) & hash == hash % 2^n
        // 这里有一个概念需要转换：X % 2^n = X & (2^n – 1)
        // i = hashcode 得到的int值对数组长度进行取模
        if ((p = tab[i = (n - 1) & hash]) == null)
            tab[i] = newNode(hash, key, value, null);
        else {
            // 不为空时，Node节点追加或者转换为红黑树，不涉及Node[]数组操作
            // e 当前的节点值，k 当前的key值
            Node<K,V> e; K k;
            // 找到数组元素，hash相等同 && key相等 || key值相等，则直接覆盖
            if (p.hash == hash &&
                ((k = p.key) == key || (key != null && key.equals(k))))
                e = p;
            // 当前节点node值是treeNode，即红黑树结构，操作红黑树
            else if (p instanceof TreeNode)
                e = ((TreeNode<K,V>)p).putTreeVal(this, tab, hash, key, value);
            else {
                // 走到这步还找不到k值时，则表示当前Node数组的第i个下标处已经有数据了，并且和当前key不同，发生了hash碰撞
                // for循环逻辑：
                // 1. 遍历当前Node链表，查找Node.next为空的节点，进行赋值
                // 2. 如果找到Node.next为空节点时，binCount已经超过二叉树的阀值(TREEIFY_THRESHOLD - 1)
                //      2.1. 则转换当前Node链表为红黑树
                // 3. 如果当前key等于链表中的值，则不做操作
                for (int binCount = 0; ; ++binCount) {
                    if ((e = p.next) == null) {
                        // 新建链表中数据元素
                        // 1. 遍历当前Node链表，查找Node.next为空的节点，进行赋值
                        p.next = newNode(hash, key, value, null);
                        /**
                         * 如果进这个循环里面，则表示：当前链表长度大于TREEIFY_THRESHOLD阀值，转换当前链表为二叉树
                         * binCount当前循环值(链表长度)，链表长度 >= 8 - 1 结构转为 红黑树
                         * TREEIFY_THRESHOLD 链表转二叉树阀值，默认8
                         */
                        // 2. 如果找到Node.next为空节点时，binCount已经超过二叉树的阀值(TREEIFY_THRESHOLD - 1)
                        if (binCount >= TREEIFY_THRESHOLD - 1) // -1 for 1st
                            // 2.1 则转换当前Node链表为红黑树
                            treeifyBin(tab, hash);
                        break;
                    }
                    // 3. 如果当前key等于链表中的值，则退出循环，不做操作
                    if (e.hash == hash &&
                        ((k = e.key) == key || (key != null && key.equals(k))))
                        break;
                    p = e;
                }
            }
            if (e != null) { // existing mapping for key
                V oldValue = e.value;
                if (!onlyIfAbsent || oldValue == null)
                    e.value = value;
                afterNodeAccess(e);
                return oldValue;
            }
        }
        ++modCount;
        if (++size > threshold)
            resize();
        afterNodeInsertion(evict);
        return null;
    }

    /**
     * Initializes or doubles table size.  If null, allocates in
     * accord with initial capacity target held in field threshold.
     * Otherwise, because we are using power-of-two expansion, the
     * elements from each bin must either stay at same index, or move
     * with a power of two offset in the new table.
     *
     * @return the table
     */
    final Node<K,V>[] resize() {
        // 旧的table
        Node<K,V>[] oldTab = table;
        // 旧的容量
        int oldCap = (oldTab == null) ? 0 : oldTab.length;
        // 阀值
        int oldThr = threshold;
        int newCap, newThr = 0;

        // 旧容量大于0
        if (oldCap > 0) {
            // 超过最大限制，不进行扩容
            if (oldCap >= MAXIMUM_CAPACITY) {
                threshold = Integer.MAX_VALUE;
                return oldTab;
            }
            // 扩容2倍后，小于最大容量，旧容量大于默认容量，则进行原始长度*2扩容
            else if ((newCap = oldCap << 1) < MAXIMUM_CAPACITY &&
                     oldCap >= DEFAULT_INITIAL_CAPACITY)
                newThr = oldThr << 1; // double threshold
        }
        // 旧容量 <=0 & 旧阀值 > 0，初始容量设置为阀值
        else if (oldThr > 0) // initial capacity was placed in threshold
            newCap = oldThr;
        else {               // zero initial threshold signifies using defaults
            // 进行到这一步，表示初始容量和阀值都为0，使用默认值。
            // 默认容量16，阀值 = 0.75(负载因子) * 16(默认容量)
            newCap = DEFAULT_INITIAL_CAPACITY;
            newThr = (int)(DEFAULT_LOAD_FACTOR * DEFAULT_INITIAL_CAPACITY);
        }

        // 新阀值 = 0，表示上面执行的是else if(oldThr > 0)
        if (newThr == 0) {
            // 拿新table的容量替换默认容量，计算新的负载因子
            float ft = (float)newCap * loadFactor;
            newThr = (newCap < MAXIMUM_CAPACITY && ft < (float)MAXIMUM_CAPACITY ?
                      (int)ft : Integer.MAX_VALUE);
        }

        // 重新设置负载因子为扩容后的
        threshold = newThr;

        // 初始化空的Node数组，并赋值给table
        @SuppressWarnings({"rawtypes","unchecked"})
            Node<K,V>[] newTab = (Node<K,V>[])new Node[newCap];
        table = newTab;

        // 如果旧的Node数组不为null，则遍历oldTab，重新hash
        if (oldTab != null) {
            for (int j = 0; j < oldCap; ++j) {
                Node<K,V> e;

                // 获取当前循环的值，并赋值给e，临时变量
                if ((e = oldTab[j]) != null) {
                    oldTab[j] = null;
                    // 如果Node[]当前下标只有一个值，重新hash索引并赋值
                    if (e.next == null)
                        newTab[e.hash & (newCap - 1)] = e;
                    // 如果Node[]当前下标为红黑树，则替换
                    else if (e instanceof TreeNode)
                        ((TreeNode<K,V>)e).split(this, newTab, j, oldCap);
                    else { // preserve order
                        // 执行到这里，说明Node[]当前节点链表有多个值，hash碰撞
                        // 方法比较特殊： 它并没有重新计算元素在数组中的位置
                        // 而是采用了 原始位置加原数组长度的方法计算得到位置

                        // head头，tail尾
                        // lo low低的位，指索引不变的值
                        // hi hight高的位，指索引增加的值
                        Node<K,V> loHead = null, loTail = null;
                        Node<K,V> hiHead = null, hiTail = null;
                        Node<K,V> next;

                        do {
                            //<editor-fold desc="Description">
                            /**
                             * 注: e本身就是一个链表的节点，它有自身的值和next(链表的值)，但是因为next值对节点扩容没有帮助，
                             * 所有在下面讨论中，我近似认为 e是一个只有自身值，而没有next值的元素。
                             *
                             * resize扩容重新hash原理：
                             *
                             * 首先原hash计算：(n - 1) & hash == hash % 2^n
                             * n -1 的二进制，如
                             *      16 : 0001 0000
                             *      15 : 0000 1111
                             * 2的次幂16为:      0001 0000，只有高位为1
                             * 2的次幂减1，15为:  0000 1111，所有位为1
                             *
                             * 扩容后的位置计算方式：
                             * 2次幂的扩展(指长度扩为原来2倍)，所以，元素的位置要么是在原位置，要么是在原位置再移动2次幂的位置
                             *
                             * 举例：
                             * hashcode1 = 5  0000 0101
                             * hashcode2 = 21 0001 0101
                             *
                             * 当oldCap = 16时
                             * 16 = 0001 0000
                             * 15 = 0000 1111
                             * hashcode1的索引位置：5  & (16 -1) = 5 , 0000 0101
                             * hashcode2的索引位置：21 & (16 -1) = 5 , 0000 0101
                             *
                             * 当扩容后newCap = 32时
                             * 32 = 0010 0000
                             * 31 = 0001 1111
                             * hashcode1的索引位置：5  & (32 -1) = 5  , 0000 0101
                             * hashcode2的索引位置：21 & (32 -1) = 21 , 0001 0101
                             *
                             * 扩容后hashcode2(21)的索引位置为：21 = 5(原索引位置) + 16(oldCap, 扩容的容量)
                             *
                             * 计算方式原理：
                             *      元素在重新计算hash之后，因为n变为2倍，那么n-1的mask范围在高位多1bit，即15和31的区别
                             *      只需要看看原来的hash值新增的那个bit是1还是0就好了，是0的话索引没变，是1的话索引变成“原索引+oldCap”
                             *
                             *      即扩容后的cap - 1的高位多1，原先hash的值如果对应高位也为1，则新索引为：原索引位置 + 扩容的容量，
                             *                               原先hash的值如果对应高位不为1，则新索引位置不变
                             *
                             *      校验方式为：(hash & oldCap) == 0
                             *      还是上面的示例：
                             *
                             *      当oldCap = 16时
                             *      hashcode1 = (5  & 16) = (0000 0101 & 0001 0000) = 0
                             *
                             *      因为oldCap容量(2次幂)值只有高位为1，所以做位与运算时
                             *          如果高位相同，则结果不为0
                             *          如果高位不同，则结果为0
                             *
                             *      因为newCap - 1扩容后(2次幂)的值，最高位和oldCap最高位相同
                             *      所以校验方式: (hash & oldCap) == 0，可以校验出扩容后索引位置会不会改变
                             *
                             *      hashcode2 = (21 & 16) = (0001 0101 & 0001 0000) = 16 = 0001 0000
                             *
                             *      当newCap = 32时
                             *      hashcode1 = (5  & 32) = (0000 0101 & 0010 0000) = 0
                             *      hashcode2 = (21 & 32) = (0001 0101 & 0010 0000) = 16 = 0001 0000
                             *
                             *      原理参考博文：[Java8的HashMap详解](https://blog.csdn.net/login_sonata/article/details/76598675)
                             */
                            //</editor-fold>
                            next = e.next;

                            // 重新hash，赋值逻辑
                            // 尾为null时，设置头为e，否则尾的下一个结点为e，即第一次设置头，其余设置尾的下一个结点为e，并设置尾为e
                            // 大白话说，设置head为第一个节点值的地址，余下每次赋值给head的next，形成链表
                            if ((e.hash & oldCap) == 0) {
                                if (loTail == null)
                                    loHead = e;
                                else
                                    loTail.next = e;
                                loTail = e;
                            }
                            else {
                                if (hiTail == null)
                                    hiHead = e;
                                else
                                    hiTail.next = e;
                                hiTail = e;
                            }
                        } while ((e = next) != null);

                        // 如果新的索引不会变
                        if (loTail != null) {
                            loTail.next = null;
                            newTab[j] = loHead;
                        }

                        // 如果新的索引会变，j(原索引) + oldCap
                        if (hiTail != null) {
                            hiTail.next = null;
                            newTab[j + oldCap] = hiHead;
                        }
                    }
                }
            }
        }
        return newTab;
    }

    /**
     * Replaces all linked nodes in bin at index for given hash unless
     * table is too small, in which case resizes instead.
     */
    final void treeifyBin(Node<K,V>[] tab, int hash) {
        int n, index; Node<K,V> e;
        if (tab == null || (n = tab.length) < MIN_TREEIFY_CAPACITY)
            resize();
        else if ((e = tab[index = (n - 1) & hash]) != null) {
            TreeNode<K,V> hd = null, tl = null;
            do {
                TreeNode<K,V> p = replacementTreeNode(e, null);
                if (tl == null)
                    hd = p;
                else {
                    p.prev = tl;
                    tl.next = p;
                }
                tl = p;
            } while ((e = e.next) != null);
            if ((tab[index] = hd) != null)
                hd.treeify(tab);
        }
    }

}
```
