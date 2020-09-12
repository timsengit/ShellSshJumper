#!/bin/bash

direc=$(dirname $0)

#引入
source hostfile.sh
source tools.sh


function main() {

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
      listHost 0
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
    listHost $keyword ''

    ;;
  *)
    #是字符，模糊搜索其他字段"HOST", "USER", "PASSWD", "DESC"
    listHost 0 $keyword

    ;;
  esac

  hostItemCount=$(cat host.tmp|wc -l)

  if [[ $hostItemCount == 1 ]];then
    hostItem=$(cat host.tmp)
    echo 'got it'$hostItem
    jumpTo $hostItem
  fi

}

logo
main
