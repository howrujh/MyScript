#!/bin/sh

cscope_files="cscope.files"

echo "Cscope making script."

rm -rf $cscope_files
touch $cscope_files

echo "Find subdirectory files.."

#find $PWD \( -name '*.c' -o -name '*.cpp' -o -name '*.cc' -o -name '*.h' -o -name '*.hh' -o -name '*.s' -o -name '*.S' \) -print > $cscope_files


if [ -z $1 ]; then
	cscope_out="cscope.out"
	ctag_out="tags"
	find $PWD \( -name '*.c' -o -name '*.cpp' -o -name '*.cc' -o -name '*.h' -o -name '*.hh' -o -name '*.s' -o -name '*.S' \) -print > $cscope_files
else
	cscope_out="$1_cscope.out"
	ctag_out="$1_tags"
	pdr_project_file="$PWD/config/project.$1"

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

		done

	done < $pdr_project_file

	if [ ! "$bios_dir" = "empty_directory" ]; then
		echo "Searching $bios_dir directory"
		find $PWD$bios_dir \( -name '*.c' -o -name '*.cpp' -o -name '*.cc' -o -name '*.h' -o -name '*.hh' -o -name '*.s' -o -name '*.S' \) -print >> $cscope_files
	fi

	if [ ! "$board_dir" = "empty_directory" ]; then
		echo "Searching $board_dir directory"
		find $PWD$board_dir \( -name '*.c' -o -name '*.cpp' -o -name '*.cc' -o -name '*.h' -o -name '*.hh' -o -name '*.s' -o -name '*.S' \) -print >> $cscope_files
		find $PWD$board_dir/../common \( -name '*.c' -o -name '*.cpp' -o -name '*.cc' -o -name '*.h' -o -name '*.hh' -o -name '*.s' -o -name '*.S' \) -print >> $cscope_files
	fi

	if [ ! "$kernel_dir" = "empty_directory" ]; then
		echo "Searching $kernel_dir directory"
		find $PWD$kernel_dir \( -name '*.c' -o -name '*.cpp' -o -name '*.cc' -o -name '*.h' -o -name '*.hh' -o -name '*.s' -o -name '*.S' \) -print >> $cscope_files
	fi

	if [ ! "$driver_dir" = "empty_directory" ]; then
		echo "Searching $driver_dir directory"
		find $PWD$driver_dir \( -name '*.c' -o -name '*.cpp' -o -name '*.cc' -o -name '*.h' -o -name '*.hh' -o -name '*.s' -o -name '*.S' \) -print >> $cscope_files
	fi

	if [ ! "$app_dir" = "empty_directory" ]; then
		echo "Searching $app_dir directory"
		find $PWD$app_dir \( -name '*.c' -o -name '*.cpp' -o -name '*.cc' -o -name '*.h' -o -name '*.hh' -o -name '*.s' -o -name '*.S' \) -print >> $cscope_files
	fi

	if [ ! "$sdk_dir" = "empty_directory" ]; then
		echo "Searching $sdk_dir directory"
		find $PWD$sdk_dir \( -name '*.c' -o -name '*.cpp' -o -name '*.cc' -o -name '*.h' -o -name '*.hh' -o -name '*.s' -o -name '*.S' \) -print >> $cscope_files
	fi

	if [ ! "$micom_dir" = "empty_directory" ]; then
		echo "Searching $micom_dir directory"
		find $PWD$micom_dir \( -name '*.c' -o -name '*.cpp' -o -name '*.cc' -o -name '*.h' -o -name '*.hh' -o -name '*.s' -o -name '*.S' \) -print >> $cscope_files
	fi

	if [ ! "$font_dir" = "empty_directory" ]; then
		echo "Searching $font_dir directory"
		find $PWD$font_dir \( -name '*.c' -o -name '*.cpp' -o -name '*.cc' -o -name '*.h' -o -name '*.hh' -o -name '*.s' -o -name '*.S' \) -print >> $cscope_files
	fi
	
fi


echo "Delete old $cscope_out.."
rm -rf $cscope_out

echo "Make new $cscope_out.."

cscope -f $cscope_out -i $cscope_files
echo "Delete old $ctag_out.."
rm -rf $ctag_out
echo "Make new $ctag_out.."

ctags -f $ctag_out -L $cscope_files --c++-kinds=+p --fields=+iaS --extra=+q
rm -rf $cscope_files

echo "Done."
