#!/bin/sh

VIM_CURRENT_PROJECT='NULL'

IFS='/'

for word in $PWD
do

	if [ "$word" = "tp1k" ]
	then
		VIM_CURRENT_PROJECT='TP1K'
	fi

	if [ "$word" = "abr" ]
	then
		VIM_CURRENT_PROJECT='ABR'
	fi
	if [ "$word" = "xm4k" ]
	then
		VIM_CURRENT_PROJECT='XM4K'
	fi

done
export VIM_CURRENT_PROJECT
IFS=''
