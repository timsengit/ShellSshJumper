#!/bin/bash

source tools.sh

function getIniFilePath() {
  id=$1
  echo "data/$1.ini"
}

function showConfigN() {
  id=$1
  inifile=$(getIniFilePath $id)
  host=$(sed '/^host=/!d;s/^host=//' $inifile)
  port=$(sed '/^port=/!d;s/^port=//' $inifile)
  user=$(sed '/^user=/!d;s/^user=//' $inifile)
  passwd=$(sed '/^passwd=/!d;s/^passwd=//' $inifile)
  logintimes=$(sed '/^logintimes=/!d;s/^logintimes=//' $inifile)
  desc=$(sed '/^desc=/!d;s/^desc=//' $inifile)
  create_time=$(sed '/^create_time=/!d;s/^create_time=//' $inifile)
  update_time=$(sed '/^update_time=/!d;s/^update_time=//' $inifile)
  log "$id' '$host' '$port' '$user' '$passwd' '$logintimes' '$desc' '$create_time' '$update_time"
  printf "\033[0;31m% 3s \033[m | %16s | %9s| %s\n" $id $host $logintimes $desc

}

#

direc=$(dirname $0)

function addHost() {

  read -p '请输入主机Host: ' host
  [[ -z $host ]] && echo '主机Host不能为空'

  read -p '请输入主机端口: ' port
  [[ -z $port ]] && echo '主机端口不能为空'

  read -p '请输入登录用户名: ' user
  [[ -z $user ]] && echo '登录用户不能为空'

  read -s -p '请输入登录密码: ' passwd
  [[ -z $passwd ]] && echo '登录密码不能为空'
  echo

  read -p '请输入主机描述: ' desc
  [[ -z $host ]] && desc=$host

  create_time=$(date '+%Y-%m-%d %H:%M:%S')
  update_time=$(date '+%Y-%m-%d %H:%M:%S')

  color blue '新增登录主机 '$user':'$passwd'@'$host':'$port' '$desc
  read -p '是否新增登录主机?  [y/n]' confirm
  [[ $confirm != 'y' ]] && return

  maxid=$(ls data/*.ini | cut -d/ -f2 | cut -d. -f1 | sort -r | head -n1)

  newId=$(($maxid + 1))
  inifile=$(getIniFilePath $newId)

  echo 'host='$host >$inifile
  echo 'port='$port >>$inifile
  echo 'user='$user >>$inifile
  echo 'passwd='$passwd >>$inifile
  echo 'logintimes=0' >>$inifile
  echo 'desc='$desc >>$inifile
  echo 'create_time='$create_time >>$inifile
  echo 'update_time='$update_time >>$inifile
}

function delHost() {

  read -p '请输入主机ID: ' id
  [[ -z $id ]] && echo '要删除主机id不能为空' && return
  echo $id | grep -q '[^0-9]' >/dev/null && echo 'ID 必须是数字' && return

  inifile=$(getIniFilePath $id)

  mv $inifile $inifile'bk'

  return
}
#$1 id
#$2 key
function listHost() {

  echo "序号 |       主机       | 连接次数 | 说明"
  id=$1
  key=$2
  #清空tmp
  rm -f host.tmp

  log 'id'$id
  log 'key'$key

  if [[ -n $id && $id > 0 ]]; then
    log 'just to '$id
    showConfigN $id
    echo $id >>host.tmp

  else
    inifile=$(getIniFilePath '*')
    if [[ -n $key ]]; then
      log 'search'

      for hostid in $(grep $key $inifile | cut -d/ -f2 | cut -d. -f1); do
        showConfigN $hostid
        echo $hostid >>host.tmp

      done
    else
      log 'list all'$inifile
      for hostitem in $(grep 'logintimes=' $inifile | sort -t '=' -k 2 -r | cut -d/ -f2 | cut -d. -f1); do
        showConfigN $hostitem
        echo $hostitem >>host.tmp
      done
    fi
  fi

}

function updateHost() {

  read -p '请输入主机ID: ' id
  [[ -z $id ]] && echo '主机id不能为空' && return
  echo $id | grep -q '[^0-9]' >/dev/null && echo 'ID 必须是数字' && return

  inifile=$(getIniFilePath $id)
  [[ ! -f $inifile ]] && echo "主机ID不存在" && return

  update_time=$(date '+%Y-%m-%d %H:%M:%S')
  #更新
  sed -i "/^update_time=/cupdate_time=$update_time" $inifile

  read -p '请输入主机Host: ' host
  #不为空更新
  if [[ -n "$host" ]]; then
    #更新
    sed -i '/^host=/chost='$host $inifile
  fi

  read -p '请输入主机端口: ' port
  if [[ -n "$port" ]]; then
    #更新
    sed -i '/^port=/cport='$port $inifile
  fi

  read -p '请输入登录用户名: ' user
  if [[ -n "$user" ]]; then
    #更新
    sed -i '/^user=/cuser='$user $inifile
  fi

  read -p '请输入登录密码: ' passwd
  if [[ -n "$passwd" ]]; then
    #更新
    sed -i '/^passwd=/cpasswd='$passwd $inifile
  fi

  read -p '请输入主机描述: ' desc
  if [[ -n "$desc" ]]; then
    #更新
    sed -i "/^desc=/cdesc=$desc" $inifile
  fi

}

#jumpTo $id $host $port $user $passwd $logintimes
function jumpTo() {
  id=$1
  inifile=$(getIniFilePath $id)

  host=$(sed '/^host=/!d;s/^host=//' $inifile)
  port=$(sed '/^port=/!d;s/^port=//' $inifile)
  user=$(sed '/^user=/!d;s/^user=//' $inifile)
  passwd=$(sed '/^passwd=/!d;s/^passwd=//' $inifile)
  logintimes=$(sed '/^logintimes=/!d;s/^logintimes=//' $inifile)
  desc=$(sed '/^desc=/!d;s/^desc=//' $inifile)
  create_time=$(sed '/^create_time=/!d;s/^create_time=//' $inifile)
  update_time=$(sed '/^update_time=/!d;s/^update_time=//' $inifile)
  log "$id' '$host' '$port' '$user' '$passwd' '$logintimes' '$desc' '$create_time' '$update_time"

  newlogintimes=$(($logintimes + 1))

  #更新登录次数
  sed -i 's/logintimes='$logintimes'/logintimes='$newlogintimes'/' $inifile

  #看passwd是不是pem文件，如果是直接使用pem登录，否则当做字符串密码登录
  echo $passwd | grep -q ".pem$"
  RETURN=$?
  if [[ $RETURN == 0 ]]; then
    echo "ssh -i $direc/$passwd $user@$host -p $port"
    ssh -i $direc/keys/$passwd $user@$host -p $port
  else
    echo "expect -f $direc/ssh_login.exp $host $user $passwd $port"
    expect -f $direc/ssh_login.exp $host $user $passwd $port
  fi

}
