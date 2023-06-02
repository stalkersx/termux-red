#!/data/data/com.termux/files/usr/bin/bash

# show notification about command
notif(){
	if [[ $1 -eq 0 ]]; then
		echo -e "$3[#] Installation Complete ... done"; exit
	elif [[ $1 -eq 1 ]]; then
		echo -e "$3[#] notification ... file <$2> found"
	elif [[ $1 -eq 2 ]]; then
		echo -e "$3[!] error ... file <$2> not found"; exit
	elif [[ $1 -eq 3 ]]; then
		echo -e "$3[#] notification ... directory <$2> found"
	elif [[ $1 -eq 4 ]]; then
		echo -e "$3[!] error ... directory <$2> not found"; exit
	elif [[ $1 -eq 5 ]]; then
		echo -e "$3[#] notification ... already installation <$2>"
	fi
}

# method check data
check_file(){
	if [ -f $1 ]; then $2; else $3; $4; $5; fi
}

check_directory(){
	if [ -d $1 ]; then $2; else $3; $4; fi
}

# variabel your data
user_data=/data/data/com.termux/files/usr
data1=$user_data/etc/bash.bashrc
data2=$user_data/bin/termux-proot
data3="bash.bashrc"
data4="termux-proot"
data5="logo-tengkorak.ascii"

# color
red="\e[0;31m"
green="\e[0;32m"

# command shell
command="[#] command ..."
command1="mv $data1 $data1.old"
command2="cp $data3 $user_data/etc"
command3="cp $data4 $user_data/bin"
command4="cp $data5 $user_data/etc"

# package more
binary_command=("proot")
package_name=("proot")

# check package install or not
check_package(){
        if [ ${binary_command[@]} ] && [ ${package_name[@]} ]; then
                for i in ${!binary_command[@]}; do
                        check_file "$user_data/bin/${binary_command[i]}" "notif 5 ${binary_command[i]} $green" "apt install ${package_name[i]}"
                done
        else
                echo -e "$green[#] notification ... no need package more"
        fi
}

# method more

# check shell
if [[ $SHELL == $user_data/bin/bash ]]; then check_package
	# running method command
	check_directory "Data-tr" "cd Data-tr" "echo -e $red[!] error ... just running in directory termux-red" "exit"

	# move file bash.bashrc
	check_file $data3 "notif 1 $data3 $green" "notif 2 $data3 $red"
	gindex=$(grep @stalkersx $data1)
        if [[ $gindex == "#@stalkersx" ]]; then
		notif 5 $data3 $green
	else
		check_file $data1 "$command1; $command2" "$command2" "echo -e $command $command1\n$command $command2"
	fi

	# move file termux-proot
	check_file $data4 "notif 1 $data4 $green" "notif 2 $data4 $red"
	check_file $data2 "notif 5 $data4 $green" "$command3" "echo $command $command3" "chmod 755 $data2"

	# move logo
	check_file $data5 "notif 1 $data5 $green" "notif 2 $data5 $red"
	check_file "$user_data/etc/$data5" "notif 5 $data5" "$command4" "echo $command $command4"

	notif 0 "null" $green
elif [[ $SHELL == /bin/bash ]]; then exit
else
	echo -e "$red[!] unknown variabel shell"
fi
