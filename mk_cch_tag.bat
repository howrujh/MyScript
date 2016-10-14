@echo off

set _target="\.c \.h"
set _bann="~ # .o .cmd .bak .hwc .hwl .txt"


dir "c:\Program Files (x86)\Freescale\CWS12v5.1\lib\hc12c" %cd% /s/b | findstr %_target% | findstr /v %_bann% > tag_list.txt
ctags -e -L tag_list.txt
