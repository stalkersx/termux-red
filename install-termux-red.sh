#!/bin/bash

# usage : use is same index data and path
usage="! usage : ./install-termux-red.sh -c | ./install-termux-red.sh -i"

# array
declare -a dfile dfolder path binary_file package_name

# input from move work directory to even package_name
# move work directory
workdir="Data-tr"

# data file
shell="/data/data/com.termux/files/usr"
dfile[0]="bash.bashrc.red"
dfile[1]="logo-tengkorak.ascii"
dfile[2]="termux-red"
dfile[3]="TermuxRed.desktop"

# data directory
#dfolder[0]=

# path
path[0]="$shell/etc"
path[1]="$shell/etc"
path[2]="$shell/bin"
path[3]="$HOME/Desktop"

# binary package
binary_file[0]="proot"

# package name
package_name[0]="proot"

# notif error
notif(){
	if [[ $1 -eq 0 ]];then
			echo -e "! shell <($2)> unknown"
	elif [[ $1 -eq 1 ]];then
			echo -e "! file <($2)> not found"
	elif [[ $1 -eq 2 ]];then
			echo -e "! directory <($2)> not found"
	elif [[ $1 -eq 3 ]];then
			echo -e "! empty data"
	elif [[ $1 -eq 4 ]];then
			echo -e "! if file empty is delete <($2)> for continue"
	elif [[ $1 -eq 5 ]];then
			echo -e "! if directory empty is delete <($2)> for continue"
	elif [[ $1 -eq 6 ]];then
			echo -e "! copy directory <($2)> cannot to path <($3)> data is same"
	elif [[ $1 -eq 7 ]];then
			echo -e "! already installed"
	fi
	exit
}

# check installed
check_in(){
	n=1
	# check install file
	for o in ${!dfile[@]};do
			if ! [ -f ${path[o]}/${dfile[o]} ];then
					n=0
			fi
	done
	# check install directory
	for q in ${!dfolder[@]};do
			if ! [ -d ${path[q]}/${dfolder[q]} ];then
					n=0
			fi
	done
	# do this if all data already installed
	if [[ $n -eq 1 ]];then
		notif 7
	fi
}
# check data
check_data(){
	# check data file
	for i in ${dfile[@]};do
			if ! [ -f $i ];then
					notif 1 $i
			fi
	done
	
	# check data directory
	for k in ${dfolder[@]};do
			if ! [ -d $k ];then
					notif 2 $k
			fi
	done
	
	# check path for copy
	for p in ${!path[@]};do
			# check path
			if ! [ -d ${path[p]} ];then
					notif 2 ${path[p]}
			fi
			# check data fd on path
			if [ -f ${path[p]}/${dfile[p]} ] && [ ${dfile[p]} ];then
					notif 4 ${path[p]}/${dfile[p]}
			elif [ -d ${path[p]}/${dfolder[p]} ] && [ ${dfolder[p]} ];then
					notif 5 ${path[p]}/${dfolder[p]}
			fi
			# check data directory != path
			if [[ ${path[p]} == ${dfolder[p]} ]];then
					notif 6 ${dfolder[p]} ${path[p]}
			fi
	done
	
	# move data file
	for j in ${!dfile[@]};do
			if ! [ -f ${path[j]}/${dfile[j]} ];then
					if [[ $1 == "contents" ]];then
							echo "./${dfile[j]} >>> ${path[j]}"
					else
							cp ${dfile[j]} ${path[j]}
					fi
			fi
	done
	# move data directory
	for m in ${!dfolder[@]};do
			if ! [ -d ${path[m]}/${dfolder[m]} ];then
					if [[ $1 == "contents" ]];then
							echo "./${dfolder[m]} >>> ${path[m]}"
					else
							cp -rf ${dfolder[m]} ${path[m]}
					fi
			fi
	done
}

# check package needed
check_package(){
	for bp in ${!binary_file[@]};do
					if ! [ -f $shell/bin/${binary_file[bp]} ] && [ $binary_file[bp]} ];then
							if [[ $1 != "contents" ]];then
									apt install ${package_name[bp]}
							fi
					fi
	done
}

# check permissions
check_p(){
	if ! [ -x $1 ] && [ -f $1 ];then
			chmod +x $1
	fi
}

# more method
change_term(){
	cd ${path[0]}
	td=$(cat bash.bashrc | grep stalkersx)
	if [ -z $td ];then
			mv bash.bashrc bash.bashrc.old
			mv ${dfile[0]} bash.bashrc
	fi
}

# move work directory
if [ -d $workdir ];then
		cd $workdir
else
		notif 2 $workdir
fi

# check shell
if [ -d $shell ] && [ ! -z $shell ];then
		# get permissions
		check_p ${dfile[2]}
		check_p ${dfile[3]}
		check_in
		if [[ $1 == "-c" ]] && [ -z $2 ];then
				check_package contents
				check_data contents
				change_term
		elif [[ $1 == "-i" ]] && [ -z $2 ];then
				check_package install
				check_data install
				change_term
		else
				echo $usage
		fi
else
		notif 0 $shell
fi
