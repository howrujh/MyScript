#!/bin/sh

if [ -z "$1" ]; then echo "`basename $0` ip"; exit 0; fi

#~/scripts/telnet_auto_login.sh 192.168.1.$1 root 141388
telnet_auto_login.sh 192.168.1.$1 root 141388

