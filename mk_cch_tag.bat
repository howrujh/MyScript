@echo off

set _target="\.c \.h"
set _bann="~ # .o .cmd .bak .hwc .hwl .txt"


dir %cd% "c:\dev\freescale" /s/b | findstr %_target% | findstr /v %_bann% > cscope.files
rem ctags -e -L tag_list.txt
