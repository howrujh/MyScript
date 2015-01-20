#!/bin/sh


if [ -z "$1" ]; then echo "`basename $0` pattern"; exit 0; fi

	find . ! -wholename '*.svn*' ! -wholename '*.git*' ! -wholename '*.swp' ! -wholename '*.cmd' ! -wholename '*.bak' ! -wholename '*.o' ! -wholename '*cscope.*' ! -wholename '*#*#' -exec grep --color=always -H -n -e "$*" {} \;
#grep -n -r "$*" ./ | sed -r "/.svn/d" | sed -r "/.o.cmd/d" | sed -r "/.bak/d" | sed -r "/.swp/d"

