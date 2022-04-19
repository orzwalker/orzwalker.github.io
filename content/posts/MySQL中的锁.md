---
title: "MySQL中的锁"
date: 2022-04-19T23:38:12+08:00
draft: false
isCJKLanguage: true
categories: ["MySQL"]
tags: ["MySQL", "锁", "乐观锁", "悲观锁", "读锁", "写锁"]
---
> 乐观锁、悲观锁、共享锁、排它锁、读锁、写锁……，这么多锁，这些锁之间有什么关系？如何理解？本文正确说明白这些概念
# 1、乐观锁
> 自己实现，比如版本号version
> 框架实现，比如hibernate的乐观锁
# 2、悲观锁
> 数据库自己实现，直接调用相关语句即可
## 2.1、共享锁
> lock in share mode;
## 2.2、排它锁
> for update;
# 3、行锁




# 参考
* https://blog.csdn.net/puhaiyang/article/details/72284702 一些概念说清楚了，但说的很浅，行锁没有说明白，可以看