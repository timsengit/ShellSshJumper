#!/bin/bash

direc=$(dirname $0)

#引入
source edithost.sh
source tools.sh

#jumpTo $id $host $port $user $passwd $logintimes
function jumpTo() {
  id=$1
  host=$2
  port=$3
  user=$4
  passwd=$5
  logintimes=$6
  newlogintimes=$logintimes+1

  #更新登录次数
  updateSql='UPDATE "host" SET "LOGIN_TIMES" = '$newlogintimes' WHERE "ID" = '$id

  echo updateSql

  updateResult=$(sqlite3 $dbName "$updateSql")
  echo 'updateResult'$updateResult

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

function main() {

  checkDb

  # shellcheck disable=SC2078
  while [ True ]; do
    color green '支持操作 : '
    color blue '            j  => jump连接host'
    color blue '             l => 展示host'
    color blue '             a => 添加host'
    color blue '             d => 删除host'
    color blue '             u => 更新host'
    read -p "请选择操作：" action

    case "$action" in
    j)
      jumpHost
      line
      ;;
    a)
      addHost
      line
      ;;
    d)
      delHost
      line
      ;;
    u)
      updateHost
      line
      ;;
    *)
      listHost
      line
      ;;
    esac
    continue
  done
}

function jumpHost() {
  listHost

  read -p '[*] 选择主机: ' keyword

  case $keyword in
  [0-9] | [0-9][0-9] | [0-9][0-9][0-9])
    #是数字，按照ID搜索
    where=' ID='$keyword
    listHost $where

    ;;
  *)
    #是字符，模糊搜索其他字段"HOST", "USER", "PASSWD", "DESC"
    where=' HOST LIKE "%'$keyword'%" OR USER LIKE "%'$keyword'%" OR PASSWD LIKE "%'$keyword'%" OR DESC LIKE "%'$keyword'%"'
    listHost "$where"

    ;;
  esac

  hostItem=$(cat listHost.tmp)

  [[ -z $hostItem ]] && echo $hostItem'empty'

  hostItemArr=(${hostItem//|/ })
  arrSize=${#hostItemArr[*]}

  #取出7个字段
  if [[ $arrSize == 7 ]]; then
    id=${hostItemArr[0]}
    host=${hostItemArr[1]}
    port=${hostItemArr[2]}
    user=${hostItemArr[3]}
    passwd=${hostItemArr[4]}
    logintimes=${hostItemArr[5]}
    desc=${hostItemArr[6]}
    jumpTo $id $host $port $user $passwd $logintimes
  fi

}

logo
main
