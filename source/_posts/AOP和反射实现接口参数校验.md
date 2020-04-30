---
title: AOP和反射实现接口参数校验
date: 2020-04-30 15:25:34
tags:
- AOP
- 反射
categories:
- Java基础
---

> 通过AOP和反射实现接口的参数校验，接口中无需写冗余繁杂的参数校验

# 定义参数校验类型注解

## NotNull

```java
@Target({PARAMETER})
@Retention(RUNTIME)
@Documented
public @interface NotNull {
    String value() default "参数不能为空";
}   			
```



## NotEmpty

```java
@Target(ElementType.PARAMETER)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface NotEmpty {
    String value() default "参数不能为空";
}
```



# 定义AOP切入点标识

```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface MethodParamValidate {
}
```



# 方法入参校验AOP实现

```java
@Aspect
@Component
public class ParamValidateAspect {

    @Around(value = "@annotation(xx.xx.annotation.MethodParamValidate)")
    public Object valid(ProceedingJoinPoint pjp) throws Throwable {
        // 获取方法入参
        Object[] args = pjp.getArgs();
        Signature signature = pjp.getSignature();
        MethodSignature methodSignature = (MethodSignature) signature;
        Method method = methodSignature.getMethod();
        // 获取方法参数注解
        Annotation[][] annotations = method.getParameterAnnotations();
        // 获取方法参数名
        String[] paramNames = methodSignature.getParameterNames();
        // 获取方法返回类型
        Class<?> returnTypeClass = method.getReturnType();
        int index = 0;
        for (Annotation[] annotation : annotations) {
            String dealRes = deal(annotation, paramNames[index], args[index]);
            // 有参数为空
            if (StringUtils.isNotEmpty(dealRes)) {
                if (returnTypeClass.equals(RpcResponse.class)) {
                    RpcResponse<?> response = new RpcResponse<>();
                    response.setData(null);
                    // 设置参数为空code码
                    response.setCode(88888);
                    response.setMsg(dealRes);
                    return response;
                }
                return returnTypeClass.newInstance();
            }
            ++index;
        }
        return pjp.proceed();
    }

    private String deal(Annotation[] annotations, String paramName, Object arg) {
        for (Annotation annotation : annotations) {
            // 获取方法参数注解名
            String paramAnnotationName = annotation.annotationType().getSimpleName();
            switch (paramAnnotationName) {
                case "NotNull":
                    NotNull notNull = (NotNull) annotation;
                    if (isNull(arg)) {
                        return paramName + notNull.value();
                    }
                    break;
                case "NotEmpty":
                    NotEmpty notEmpty = (NotEmpty) annotation;
                    if (isEmpty(arg)) {
                        return paramName + notEmpty.value();
                    }
                    break;
                default:
                    break;

            }
        }
        return null;
    }

    private boolean isNull(Object arg) {
        return arg == null;
    }

    private boolean isEmpty(Object arg) {
        if (null == arg) {
            return true;
        }
        if (arg instanceof String) {
            StringUtils.isEmpty((String) arg);
        }
        if (arg instanceof List<?>) {
            return ((List<?>) arg).isEmpty();
        }
        if (arg instanceof Map<?, ?>) {
            return ((Map<?, ?>) arg).isEmpty();
        }
        if (arg instanceof Object[]) {
            return ((Object[]) arg).length == 0;
        }
        return false;
    }

}
```



# 测试

## Demo

```java
@PostMapping("/test")
    @MethodParamValidate
    public RpcResponse<String> test(@NotNull Long doctorId, @NotNull Long diseaseId, @NotEmpty @RequestParam  List<Long> ids) {
        System.out.println(1);
        return null;
    }
```



## 请求和结果

- 第一个参数为空

```java
curl -v -X POST http://127.0.0.1:8080/comment/test\?doctorId\&diseaseId=1\&ids=1,2

{
    "code": 88888,
    "msg": "doctorId参数不能为空",
    "data": null
}
```



- 第三个参数为空

```java
curl -v -X POST http://127.0.0.1:8080/comment/test\?doctorId=1\&diseaseId=1\&ids

{
    "code": 88888,
    "msg": "ids参数不能为空",
    "data": null
}
```