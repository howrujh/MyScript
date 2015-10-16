#!/bin/sh



find_opt_exclude_dir="\( -type d -path './*.bak' -o -type d -path './*.tmp' -o -type d -path './.build' \) -prune"
find_opt_target_file="\( -name '*.c' -o -name '*.cpp' -o -name '*.cc' -o -name '*.h' -o -name '*.hh' -o -name '*.s' -o -name '*.S' \)"



find_dir() {

	# $1 : path , $2: cscope_file name
#	find $1 ! \($find_opt_exclude_dir\)\) $find_opt_target_file -print >> $2
	find $1 ! \( \( -type d -name '*.bak' -o -type d -name '*.tmp' -o -type d -name '.*' -o -type d -name 'build.*' -o -name '#*' -o -name '.*' \) -prune \) \( -name '*.c' -o -name '*.cpp' -o -name '*.cc' -o -name '*.h' -o -name '*.hh' -o -name '*.s' -o -name '*.S' -o -name 'Makefile' \) -print >> $2
}

echo "Cscope making script."


echo "Finding subdirectory files.."

#find $PWD \( -name '*.c' -o -name '*.cpp' -o -name '*.cc' -o -name '*.h' -o -name '*.hh' -o -name '*.s' -o -name '*.S' \) -print > $cscope_files


if [ -z $1 ]; then
	cscope_files="cscope.files"
	cscope_out="cscope.out"
	ctag_out="tags"
	#find $PWD  \( -name '*.c' -o -name '*.cpp' -o -name '*.cc' -o -name '*.h' -o -name '*.hh' -o -name '*.s' -o -name '*.S' \) -print > $cscope_files
	#find $PWD $find_opt_exclude_dir $find_opt_target_file -print > $cscope_files

	rm -rf $cscope_files
	touch $cscope_files

	find_dir $PWD $cscope_files
else
	cscope_files="$1_cscope.files"
	cscope_out="$1_cscope.out"
	ctag_out="$1_tags"
	pdr_project_file="$PWD/config/project.$1"

	rm -rf $cscope_files
	touch $cscope_files


	if [ ! -e "$pdr_project_file" ]; then
		echo "can not fid project.$1 file :" 
		echo " 1)  execute in the project root directory"
		echo " 2)  checking \"config/project.$1\" file is exist"
		return
	fi

	echo "project.$1 file loaded"

	bios_dir="empty_directory"
	board_dir="empty_directory"
	kernel_dir="empty_directory"
	driver_dir="empty_directory"
	app_dir="empty_directory"
	micom_dir="empty_directory"
	sdk_dir="empty_directory"
	font_dir="empty_directory"
	util_dir="empty_directory"
	onvif_dir="empty_directory"

	while read line
	do
		for word in $line
		do
		
		bios_dir_tmp=`echo $line | grep "BIOS_SRC_DIR"`
		board_dir_tmp=`echo $line | grep "BOARD_SRC_DIR"`
		kernel_dir_tmp=`echo $line | grep "KERNEL_SRC_DIR"`
		driver_dir_tmp=`echo $line | grep "DRIVER_SRC_DIR"`
		app_dir_tmp=`echo $line | grep "APP_SRC_DIR"`
		micom_dir_tmp=`echo $line | grep "MCU_SRC_DIR"`
		sdk_dir_tmp=`echo $line | grep "SDK_SRC_DIR"`
		font_dir_tmp=`echo $line | grep "FONT_SRC_DIR"`
		util_dir_tmp=`echo $line | grep "UTIL_DIR"`
		onvif_dir_tmp=`echo $line | grep "ONVIF_SRC_DIR"`

		if [ ! -z "$bios_dir_tmp" ]; then
			if [ ! -z "`echo $line | grep "(PROJECT_BASE)"`" ]; then
				bios_dir=${bios_dir_tmp#*(PROJECT_BASE)}
			fi
		fi

		if [ ! -z "$board_dir_tmp" ]; then
			if [ ! -z "`echo $line | grep "(PROJECT_BASE)"`" ]; then
				board_dir=${board_dir_tmp#*(PROJECT_BASE)}
			elif [ ! -z "`echo $line | grep "(BIOS_SRC_DIR)"`" ]; then
				board_dir=$bios_dir${board_dir_tmp#*(BIOS_SRC_DIR)}
			fi
		fi

		if [ ! -z "$kernel_dir_tmp" ]; then
			if [ ! -z "`echo $line | grep "(PROJECT_BASE)"`" ]; then
				kernel_dir=${kernel_dir_tmp#*(PROJECT_BASE)}
			fi
		fi

		if [ ! -z "$driver_dir_tmp" ]; then
			if [ ! -z "`echo $line | grep "(PROJECT_BASE)"`" ]; then
				driver_dir=${driver_dir_tmp#*(PROJECT_BASE)}
			fi
		fi

		if [ ! -z "$app_dir_tmp" ]; then
			if [ ! -z "`echo $line | grep "(PROJECT_BASE)"`" ]; then
				app_dir=${app_dir_tmp#*(PROJECT_BASE)}
			fi
		fi

		if [ ! -z "$micom_dir_tmp" ]; then
			if [ ! -z "`echo $line | grep "(PROJECT_BASE)"`" ]; then
				micom_dir=${micom_dir_tmp#*(PROJECT_BASE)}
			fi
		fi

		if [ ! -z "$sdk_dir_tmp" ]; then
			if [ ! -z "`echo $line | grep "(PROJECT_BASE)"`" ]; then
				sdk_dir=${sdk_dir_tmp#*(PROJECT_BASE)}
			fi
		fi

		if [ ! -z "$font_dir_tmp" ]; then
			if [ ! -z "`echo $line | grep "(PROJECT_BASE)"`" ]; then
				font_dir=${font_dir_tmp#*(PROJECT_BASE)}
			fi
		fi

		if [ ! -z "$util_dir_tmp" ]; then
			if [ ! -z "`echo $line | grep "(PROJECT_BASE)"`" ]; then
				util_dir=${util_dir_tmp#*(PROJECT_BASE)}
			fi
		fi
		if [ ! -z "$onvif_dir_tmp" ]; then
			if [ ! -z "`echo $line | grep "(PROJECT_BASE)"`" ]; then
				onvif_dir=${onvif_dir_tmp#*(PROJECT_BASE)}
			fi
		fi



		done

	done < $pdr_project_file

	if [ ! "$bios_dir" = "empty_directory" ]; then
		echo "Searching $bios_dir directory"
#		find $PWD$bios_dir \( -name '*.c' -o -name '*.cpp' -o -name '*.cc' -o -name '*.h' -o -name '*.hh' -o -name '*.s' -o -name '*.S' \) -print >> $cscope_files
		find_dir $PWD$bios_dir  $cscope_files
	fi

	if [ ! "$board_dir" = "empty_directory" ]; then
		echo "Searching $board_dir directory"
#		find $PWD$board_dir \( -name '*.c' -o -name '*.cpp' -o -name '*.cc' -o -name '*.h' -o -name '*.hh' -o -name '*.s' -o -name '*.S' \) -print >> $cscope_files
#		find $PWD$board_dir/../common \( -name '*.c' -o -name '*.cpp' -o -name '*.cc' -o -name '*.h' -o -name '*.hh' -o -name '*.s' -o -name '*.S' \) -print >> $cscope_files
		find_dir $PWD$board_dir $cscope_files
		find_dir $PWD$board_dir/../common $cscope_files

	fi

	if [ ! "$kernel_dir" = "empty_directory" ]; then
		echo "Searching $kernel_dir directory"
		#find $PWD$kernel_dir \( -name '*.c' -o -name '*.cpp' -o -name '*.cc' -o -name '*.h' -o -name '*.hh' -o -name '*.s' -o -name '*.S' \) -print >> $cscope_files
		find_dir $PWD$kernel_dir $cscope_files
	fi

	if [ ! "$driver_dir" = "empty_directory" ]; then
		echo "Searching $driver_dir directory"
		#find $PWD$driver_dir \( -name '*.c' -o -name '*.cpp' -o -name '*.cc' -o -name '*.h' -o -name '*.hh' -o -name '*.s' -o -name '*.S' \) -print >> $cscope_files
		find_dir $PWD$driver_dir $cscope_files
	fi

	if [ ! "$app_dir" = "empty_directory" ]; then
		echo "Searching $app_dir directory"
		#find $PWD$app_dir \( -name '*.c' -o -name '*.cpp' -o -name '*.cc' -o -name '*.h' -o -name '*.hh' -o -name '*.s' -o -name '*.S' \) -print >> $cscope_files
		find_dir $PWD$app_dir $cscope_files
	fi

	if [ ! "$sdk_dir" = "empty_directory" ]; then
		echo "Searching $sdk_dir directory"
		#find $PWD$sdk_dir \( -name '*.c' -o -name '*.cpp' -o -name '*.cc' -o -name '*.h' -o -name '*.hh' -o -name '*.s' -o -name '*.S' \) -print >> $cscope_files
		find_dir $PWD$sdk_dir $cscope_files
	fi

	if [ ! "$micom_dir" = "empty_directory" ]; then
		echo "Searching $micom_dir directory"
		#find $PWD$micom_dir \( -name '*.c' -o -name '*.cpp' -o -name '*.cc' -o -name '*.h' -o -name '*.hh' -o -name '*.s' -o -name '*.S' \) -print >> $cscope_files
		find_dir $PWD$micom_dir $cscope_files
	fi

	if [ ! "$font_dir" = "empty_directory" ]; then
		echo "Searching $font_dir directory"
		#find $PWD$font_dir \( -name '*.c' -o -name '*.cpp' -o -name '*.cc' -o -name '*.h' -o -name '*.hh' -o -name '*.s' -o -name '*.S' \) -print >> $cscope_files
		find_dir $PWD$font_dir $cscope_files
	fi

	if [ ! "$util_dir" = "empty_directory" ]; then
		echo "Searching $util_dir directory"
		#find $PWD$font_dir \( -name '*.c' -o -name '*.cpp' -o -name '*.cc' -o -name '*.h' -o -name '*.hh' -o -name '*.s' -o -name '*.S' \) -print >> $cscope_files
		find_dir $PWD$util_dir $cscope_files
	fi

	if [ ! "$onvif_dir" = "empty_directory" ]; then
		echo "Searching $onvif_dir directory"
		#find $PWD$font_dir \( -name '*.c' -o -name '*.cpp' -o -name '*.cc' -o -name '*.h' -o -name '*.hh' -o -name '*.s' -o -name '*.S' \) -print >> $cscope_files
		find_dir $PWD$onvif_dir $cscope_files
	fi

	
fi


echo "Delete old $cscope_out.."
if [ -e "$cscope_out" ]; then
	rm -rf $cscope_out
fi

echo "Make new $cscope_out.."

#cscope -f $cscope_out -i $cscope_files
echo "Delete old $ctag_out.."
if [ -e "$ctag_out" ]; then
	rm -rf $ctag_out
fi
echo "Make new $ctag_out.."

#/usr/bin/ctags -f $ctag_out -L $cscope_files --c++-kinds=+p --fields=+iaS --extra=+q
#rm -rf $cscope_files

echo "Done."
