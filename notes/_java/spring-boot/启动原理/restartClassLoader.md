---
layout: post
categories: spring springboot
name: restart class loader
tags: [spring,spring boot]
# date: 2019-10-12 18:09:20 +0800
---
## spring boot restartClassLoader
### restartClassLoader类加载逻辑
**在初始化`RestartClassLoader`时，`urls`信息为类编译路径，不包含jar包信息**
1. `loadClass(String name, boolean resolve)`
    - 通过重写该方法，实现`restart`自定义逻辑
    ```java
    @Override
	public Class<?> loadClass(String name, boolean resolve) throws ClassNotFoundException {
		String path = name.replace('.', '/').concat(".class");
		ClassLoaderFile file = this.updatedFiles.getFile(path);
		if (file != null && file.getKind() == Kind.DELETED) {
			throw new ClassNotFoundException(name);
		}
		synchronized (getClassLoadingLock(name)) {
			Class<?> loadedClass = findLoadedClass(name);
			if (loadedClass == null) {
				try {
					loadedClass = findClass(name);
				}
				catch (ClassNotFoundException ex) {
					loadedClass = getParent().loadClass(name);
				}
			}
			if (resolve) {
				resolveClass(loadedClass);
			}
			return loadedClass;
		}
	}
    ```
    - 首先，在`updatedFiles`缓存中查找文件，判断文件状态
    - 调用`ClassLoader.findLoadedClass(String name)`查找类是否被加载过
    - 没有找到，通过`findClass(String name)`查找类，此方法是重写父类方法的自定义实现
    - 通过`findClass(String name)`没有找到，则调用父加载器即`Launcher$AppClassLoader.loadClass(String name)`
2. `findClass(String name)`
    - 通过重写该方法，实现`restart`自定义逻辑
    ```java
    @Override
	protected Class<?> findClass(String name) throws ClassNotFoundException {
		String path = name.replace('.', '/').concat(".class");
		final ClassLoaderFile file = this.updatedFiles.getFile(path);
		if (file == null) {
			return super.findClass(name);
		}
		if (file.getKind() == Kind.DELETED) {
			throw new ClassNotFoundException(name);
		}
		return AccessController.doPrivileged((PrivilegedAction<Class<?>>) () -> {
			byte[] bytes = file.getContents();
			return defineClass(name, bytes, 0, bytes.length);
		});
	}
    ```
    - 首先查询缓存信息，查询到则返回类信息
    - 查询不到，调用父类的`findClass(String name)`，即`URLClassLoader.findClass(String name)`
    - 因为`urls`信息为类编译路径，不包含jar包信息，则`URLClassLoader`只会加载类编译路下的类，如果在编译路径下找不到该类，则会交给父加载器`Launcher.$AppClassLoader.loadClass(String name)`去加载，因为父类加载会加载`java.class.path`包含的类（包括jar包）
