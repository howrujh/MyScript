#!/bin/sh

FILE="$HOME/bin/tmp/tmux_display_value.txt"

if [ -f $FILE ]
then
	while read line
	do
		if [ ! -z $line ]
		then
			export DISPLAY=$line
		fi
	done < $FILE
fi
