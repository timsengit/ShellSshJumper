#!/bin/bash

function color(){
    blue="\033[0;36m"
    red="\033[0;31m"
    green="\033[0;32m"
    close="\033[m"
    case $1 in
        blue)
            echo -e "$blue $2 $close"
        ;;
        red)
            echo -e "$red $2 $close"
        ;;
        green)
            echo -e "$green $2 $close"
        ;;
        *)
            echo "Input color error!!"
        ;;
    esac
}


function line() {
  echo "-----------------------------------------"
}


function logo() {
  echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++"
  color blue "               ShellSshJumper "
  color red "git https://github.com/timsengit/ShellSshJumper "
  echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++"
  echo
}
