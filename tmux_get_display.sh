#!/bin/sh

FILE="$HOME/bin/tmp/tmux_display_value.txt"

if [ -f "$FILE" ]
then
	rm $FILE	
fi

echo $DISPLAY > $FILE
