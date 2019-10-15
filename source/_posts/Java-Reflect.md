---
title: Java-Reflect
date: 2019-09-21 17:26:19
tags: 
- Java
- Reflect
Categories:
- Java基础
---

> Reflection is commonly used by programs which require the ability to examine or modify the runtime behavior of applications running in the Java virtual machine. This is a relatively advanced feature and should be used only by developers who have a strong grasp of the fundamentals of the language. With that caveat in mind, reflection is a powerful technique and can enable applications to perform operations which would otherwise be impossible.

**能够在程序运行时修改程序的行为**

# 反射入口

## Class

反射的入口是Class，也是一个类

```
public final class Class<T> implements java.io.Serializable,
                              GenericDeclaration,
                              Type,
                              AnnotatedElement {...}
```

## 如何获取Class

3种方式获取Class

* ins.getClass()

```
class Demo{}

Demo d = new Demo();
Class clazz = d.getClass();
```

* .class

```
Class clazz = int.class;
clazz = Demo.class;
```

* Class.forName("类全限定名")

```
Class clazz = Class.forClass("com.walker.reflect.Demo");
```

# Class详情

## Class名字

3种方式获取Class名字

```
Class.getName();
Class.getSimpleName();
//以上两种的综合可用下方法表示
Class.getCanonicalName();
```

## Class修饰符

> Java中一个类往往有很多修饰符配合使用，主要有以下：
>
> 用来限制作用域，如public、protected、private
>
> 用来提示子类复写，如abstract
>
> 用来标注为静态类，如static
>
> 注解，如Component

* 代码

```
public class TestReflect extends Demo{
    public static void main(String[] args){
        Class clazz = Demo.class;
        System.out.println("class modifiers value: "+clazz.getModifiers());
        System.out.println("class modifiers: "+ Modifier.toString(clazz.getModifiers()));
    }
}

abstract class Demo{
}
```

* 输出

```
class modifiers value: 1024
class modifiers: abstract
```

* 为什么输出value是数字

一个Class的修饰符可能有多个，为了一并获取，使用位运算，用int数值代替所有的修饰符。具体相关可查看`Modifier`这个类

## Class成员

Java类的成员包含属性、方法和构造器，对应的`Class`为`Field`、`Method`、`Constructor`。总体上需注意两点：

+ getDeclaredXxx()：能获取到当前类定义的所有成员
+ GetXxx()：能获取到全部(包含父类)`public`的成员

### Field

```
public Field getDeclaredField(String name)
                       throws NoSuchFieldException,
                              SecurityException;

public Field getField(String name)
               throws NoSuchFieldException,
                      SecurityException;
                      
public Field[] getDeclaredFields() throws SecurityException {}

public Field[] getFields() throws SecurityException {}
```

### Method

```
public Method[] getMethods() throws SecurityException {}

public Method getMethod(String name, Class<?>... parameterTypes)
        throws NoSuchMethodException, SecurityException {}
    
public Method[] getDeclaredMethods() throws SecurityException {}
 
public Method getDeclaredMethod(String name, Class<?>... parameterTypes)
        throws NoSuchMethodException, SecurityException {)
```

### Constructor

Constructor不能从父类继承，故不能通过`getConstructors()`获取到父类的构造方法

```
public Constructor<?>[] getConstructors() throws SecurityException {}

public Constructor<T> getConstructor(Class<?>... parameterTypes)
        throws NoSuchMethodException, SecurityException {}
    
public Constructor<?>[] getDeclaredConstructors() throws SecurityException {}
```



