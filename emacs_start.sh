#!/bin/sh

if [ ! -e "/tmp/emacs$(id -u)/server" ]
then
	emacs --daemon
	sleep 1
fi

emacsclient -t "$@"
