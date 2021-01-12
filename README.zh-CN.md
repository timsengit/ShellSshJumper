<h1 align="center"><a href='https://github.com/timsengit/ShellSshJumper.git' target="_blank" >ShellSshJumper</a></h1>

<p align="center">
一个使用shell编写的基于文件的跳板机ssh login tool，相比与jumpserver等专业跳板机堡垒机很小巧。
</br>
可以解决一般的小型的使用场景，适合应对不想搭建堡垒机，又有多台主机需要管理的情况。
</p>

<p align="center">
  🇬🇧 <a href="./README.md">English Introduce</a>
</p>

---

## 功能

- 主机管理：增删改查连接
- 根据连接次数排序
- 全shell,简化实现及依赖
- 简单的密码加密：盐和Base64

## 安装及使用

```bash
git clone https://github.com/timsengit/ShellSshJumper.git

cd ShellSshJumper

bash jump.sh
```

> 提示: 先安装 expect


### 截图

>recodeScreen
>>![alt text](img/recodeScreen.gif)

>addHost
>>![addHost](img/addHost.png)

>listHost
>>![listHost](img/listHost.png)

>jumpHost
>>![jumpHost](img/jumpHost.png)



### 说明
- Linux ssh 登陆工具
- 支持秘密和密钥两种格式
- 用户名和密码都是存文件（每个host一个文件）
- 使用密钥的话保存密钥，并把密码设置成密钥路径就可以了，注意密钥权限设置

## 版本规划

>1.1.1
>>re all shell ,be simple

>1.1
>>数据库加密

>1.0
>> sqlite curd jump

