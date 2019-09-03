---
title: shell-ps
date: 2019-09-03 12:01:03
tags: 
- Shell
- Linux
categories:
- Shell命令
---

> 参考：[https://explainshell.com](https://explainshell.com/)，一个神奇的工具网站

```
ps -ef | grep 'java' | grep -v grep | awk '{print $2}' | xargs kill 
```

**管道符“|”用来隔开两个命令，管道符左边命令的输出会作为管道符右边命令的输入**

说明：通过`ps`命令获取本机所有正在运行进程的列表，然后传递给`grep`命令过滤出满足条件的进程行，然后通过`awk`打印输出其进程号，最后再通过`xargs`命令将输出信息传递给`kill`命令，将进程杀死

+ `ps`：report a snapshot of the current processes（获取当前进程的快照）
+ `-ef`
  + `-e`： Select all processes（获取所有进程）
  + `-f`： Do full-format listing (显示完整格式)
+ `grep`：print lines matching a pattern (输出匹配行)
+ `'java'`：grep searches the named input FILEs (要搜索的进程名)
+ `-v`：--invert-match (反向匹配查找，如`grep -v 'java'`表示不含有`java`字段的行)
+ `awk`：pattern scanning and processing language (`awk`一种处理结构数据并输出格式化结果的编程语言，通常被用来进行格式扫描和处理)
+ `awk '{print $2}'`：以空格为分隔符，输出一行中第二个字段值
+ `xargs`：build and execute command lines from standard input (给命令传递参数的一个过滤器)