#!/bin/bash

OS=$(grep -w "^ID" /etc/os-release | cut -d= -f2 | tr -d '"')

case $OS in
    arch)        echo "" ;;
    ubuntu)      echo "" ;;
    debian)      echo "" ;;
    fedora)      echo "" ;;
    nixos)       echo "" ;;
    opensuse*)   echo "" ;;
    manjaro)     echo "" ;;
    linuxmint)   echo "󰣭" ;;
    endeavouros) echo "" ;;
    *)           echo "" ;;
esac