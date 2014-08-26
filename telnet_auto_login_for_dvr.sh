#!/bin/sh

if [ -z "$1" ]; then echo "$0 ip"; return ; fi

~/scripts/telnet_auto_login.sh 192.168.1.$1 root 141388

