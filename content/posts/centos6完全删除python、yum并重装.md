---
title: "Centos6完全删除python、yum并重装"
date: 2022-04-19T16:42:41+08:00
draft: false
isCJKLanguage: true
categories: ["Linux"]
tags: ["yum", "python", "centos6"]
---
## 删除Python
```
rpm -qa|grep python|xargs rpm -ev --allmatches --nodeps ##强制删除已安装程序及其关联
whereis python |xargs rm -frv ##删除所有残余文件 ##xargs，允许你对输出执行其他某些命令
whereis python ##验证删除，返回无结果
```
## 删除yum
```
rpm -qa|grep yum|xargs rpm -ev --allmatches --nodeps
whereis yum |xargs rm -frv
```
## 创建目录存放rpm包
```
mkdir /usr/local/src/python
mkdir /usr/local/src/yum
```
## install
> 地址：https://vault.centos.org/centos/6.8/os/x86_64/Packages/
### install python
#### download python rpm
```
python-2.6.6-64.el6.x86_64.rpm
python-devel-2.6.6-64.el6.x86_64.rpm
python-iniparse-0.3.1-2.1.el6.noarch.rpm
python-libs-2.6.6-64.el6.x86_64.rpm
python-pycurl-7.19.0-9.el6.x86_64.rpm
python-urlgrabber-3.9.1-11.el6.noarch.rpm
rpm-python-4.8.0-55.el6.x86_64.rpm
```
#### install python
```
rpm -ivh python-* rpm-python-*
# 或
rpm -ivh python-* rpm-python-* --nodeps --force  ## --nodeps --force为不考虑依赖包，强制安装
```
#### check
```
python
python --version
```
### install yum
#### download rpm
```
python-iniparse-0.3.1-2.1.el6.noarch.rpm
yum-3.2.29-73.el6.centos.noarch.rpm
yum-metadata-parser-1.1.2-16.el6.x86_64.rpm
yum-plugin-fastestmirror-1.1.30-37.el6.noarch.rpm
```
#### install
```
rpm -ivh yum-*
```
#### check
```
yum version
```
