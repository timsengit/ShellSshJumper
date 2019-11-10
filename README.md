# ShellSshJumper
一个使用shell编写的基于sqlte的跳板机，很小巧对比与jumpserver,不需要堡垒机

适合应对不想搭建堡垒机，又有多台主机需要管理的情况

>require:expect,sqlite3

使用方法：

` bash jump.sh  `

### 截图

>recodeScreen
>>![alt text](img/recodeScreen.gif)

>addHost
>>![addHost](img/addHost.png)

>listHost
>>![listHost](img/listHost.png)

>jumpHost
>>![jumpHost](img/jumpHost.png)


## Linux ssh 登陆工具:

###　一.说明
- 支持秘密和密钥两种格式
- 用户名和密码都是存sqlite
- 使用密钥的话保存密钥，并把密码设置成密钥路径就可以了，注意密钥权限设置

## 版本规划
>1.0
>> sqlite curd jump

>1.1
>>数据库加密
