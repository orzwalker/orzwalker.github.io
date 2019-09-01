---
title: Java-Annotation
date: 2019-08-31 14:19:47
tags:
- Java
- Annotation
categories: 
- Java基础
---

![71261209_p0](Java-Annotation.assets/71261209_p0.jpg)

# 注解

> 注解可以简单理解为`标签`：是对事物行为的某些角度的评价与解释
>
> 注解是一系列元数据，它提供数据用来解释程序代码，但是注解并非是所解释的代码本身的一部分。注解对于代码的运行效果没有直接影响。
>
> 注解并不是代码本身的一部分

## 注解的作用

- 提供信息给编译器： 编译器可以利用注解来探测错误和警告信息
- 编译阶段时的处理： 软件工具可以用来利用注解信息来生成代码、Html文档或者做其它相应处理。
- 运行时的处理： 某些注解可以在程序运行的时候接受代码的提取

# 元注解

Java定义了4个标准的meta-annotation类型，被用来提供对其他annotation类型作说明：

**@Target**

描述注解的使用范围，取值ElementType有：

- CONSTRUCTOR:用于描述构造器 　
- FIELD:用于描述域 　
- LOCAL_VARIABLE:用于描述局部变量 　
- METHOD:用于描述方法 　
- PACKAGE:用于描述包 　
- PARAMETER:用于描述参数 　
  TYPE:用于描述类、接口(包括注解类型) 或enum声明	

**@Retention**

定义了当前annotation被保留的时间长短，**表示需要在什么级别保存该注解信息，用于描述注解的生命周期（被描述的注解在什么范围内有效）**，取值RetentionPolicy有：

+ SOURCE：在原文件中有效

- CLASS：在Class字节码文件中有效
- RUNTIME：只在运行时有效，注解保存在JVM运行时刻,能够在运行时刻通过反射API来获取到注解的信息

**@Documented**

是否将注解信息添加在Java文档中，可以被javadoc工具文档化

**@Inherited**

表示某个被标注的类型是被继承的，如果一个使用好了@Inherited注解修饰的annotation类型被用于一个Class，则这个annotation也被用于该class的子类

# Java预置注解

+ @Deprecated：经常用于不建议或过时的方法

+ @Override：子类需要复写基类中标注了该注解的方法
+ SuppressWarnings：忽略警告
+ FunctionalInterface：函数式接口注解，使用了该注解的接口，只包含一个方法，如Runable接口，该类方法都能转为Lambda表达式

# Spring中常用到的注解

## Spring

### 组件类注解

三个有具体语义的注解被@Component注解标注，所以可以代替，但是在开发中尽量使用带有具体语义的注解

```java
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Component
public @interface Controller {
    String value() default "";
}
```

- @Component：标注一个普通的Spring bean类；
- @Controller：标注一个控制器组件类；
- @Service：标注一个业务逻辑组件类；
- @Repository：标注一个DAO组件类，如impl

### 装配bean时常用到的注解

- @Autowired：属于Spring
- @Resource：属于J2EE

两者的区别：

- @Resource可以代替@Autowired；
- @Autowired按照类型进行装配；
- @Resource有两个关键属性，name和type，如果没有指定name和type，则容器使用属性的名称作为默认name在容器中查找依赖，若没找到，则会根据type进行查找；如果指定了name，则只会根据name在容器中装配，推荐使用@Resource



## Spring MVC

- @Controller：表明该类会作为与前端作交互的控制层组件，通过服务接口定义的提供访问应用程序的一种行为，解释用户的输入，将其转换成一个模型然后将试图呈献给用户；

- @RequestMapping：用于将url映射到整个处理类或者特定的处理请求的方法；

- @RequestParam：默认情况下，required=true，也就是改参数必须要传。如果改参数可以传可不传，可以配置required=false；

- @RequestBody：指方法参数应该被绑定到HTTP请求Body上；

- @ResponseBody：与@RequestBody类似，它的作用是将返回类型直接输入到HTTP response body中；

- @RestController：控制器实现了REST的API，只为服务于JSON，XML或其它自定义的类型内容，继承自@Controller注解，来标识当前类是一个控制器servlet，告诉Spring以字符串形式渲染结果，并直接返回给调用者；

- ```
  @Target({ElementType.TYPE})
  @Retention(RetentionPolicy.RUNTIME)
  @Documented
  @Controller
  @ResponseBody
  public @interface RestController {
      @AliasFor(
          annotation = Controller.class
      )
      String value() default "";
  }
  ```

- @RequestMapping：提供路由信息，告诉Spring任何来自"/"路径的HTTP请求都应该被映射到 home方法；



## Spring Boot

- @Value：读取application.properties里面的配置（当使用了@Value注解的类被其他类作为对象使用时，只能选择注入方式，而不能new()）；
- @SpringBootApplication相当于
  - @Configuration（@SpringBootConfiguration点开查看发现里面还是应用了@Configuration）
  - @EnableAutoConfiguration
  - @ComponentScan

# 代码相关

+ 定义两个注解

```
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface MethodAnnotationTest {

    public boolean isNull() default false;
}
```

```
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
public @interface ClassAnnotationTest {
    public int id() default 1;

    public String value() default "Hi Java";
}
```

+ 通过反射`reflect`获取注解的相关属性和value

```
@ClassAnnotationTest(id = 33, value = "this is test annotation")
public class TestAnnotation {
    private static Logger logger = LoggerFactory.getLogger(TestAnnotation.class);

    @MethodAnnotationTest(isNull = true)
    public void test() {
        logger.info("test method invoke....");
    }

    public static void main(String[] args) throws NoSuchMethodException, InvocationTargetException, IllegalAccessException {
        boolean isAnnotaion = TestAnnotation.class.isAnnotationPresent(ClassAnnotationTest.class);
        logger.info("is annotation?: {}", isAnnotaion);
        if (isAnnotaion) {
            ClassAnnotationTest annotationTest = TestAnnotation.class.getAnnotation(ClassAnnotationTest.class);
            logger.info("annotation is: {}", annotationTest);
            logger.info("id is: {}", annotationTest.id());
            logger.info("value is: {}", annotationTest.value());
        }

        Method testMethod = TestAnnotation.class.getDeclaredMethod("test");
        if (null != testMethod) {
            Annotation[] annotations = testMethod.getAnnotations();
            for (Annotation annotation : annotations) {
                testMethod.setAccessible(true);
                testMethod.invoke(new TestAnnotation());
                logger.info("method annotation: {}", annotation.annotationType().getSimpleName());
            }
        }
    }
}
```

+ 输出

```
is annotation?: true
annotation is: @com.walker.annotation.ClassAnnotationTest(value=this is test annotation, id=33)
id is: 33
value is: this is test annotation
test method invoke....
method annotation: MethodAnnotationTest
```

