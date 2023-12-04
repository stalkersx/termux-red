#!/bin/bash

# usage : use is same index data and path
usage="! usage: ./uninstall-termux-red.sh -c | uninstall-termux-red.sh -r"

# array
declare -a dfile dfolder path binary_file package_name

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
			echo -e "! already uninstalled"
	elif [[ $1 -eq 2 ]];then
			echo -e "! path <($2)> not found"
	fi
	exit
}

# check installed
check_in(){
	n=1
	# check install file
	for o in ${!dfile[@]};do
			if [ -f ${path[o]}/${dfile[o]} ];then
					n=0
			fi
	done
	# check install directory
	for q in ${!dfolder[@]};do
			if [ -d ${path[q]}/${dfolder[q]} ];then
					n=0
			fi
	done
	# do this if all data already installed
	if [[ $n -eq 1 ]];then
		notif 1
	fi
}

# check data
check_data(){
	loc=$(pwd)
	for i in ${path[@]};do
			if ! [ -d $i ];then 
					notif 2 $i
			fi
	done
	
	# remove data file
	for j in ${!path[@]};do
			# move to path
			if [ -d ${path[j]} ];then
					cd ${path[j]}
					if [ -f ${dfile[j]} ] && [ ${dfile[j]} ] && [[ $(pwd) == ${path[j]} ]];then
							if [[ $1 == "contents" ]];then
									echo ".${path[j]}/${dfile[j]}"
							else
									rm ${dfile[j]}
							fi
					fi
					if [ -d ${dfolder[j]} ] && [ ${dfolder[j]} ];then
								if [[ $1 == "contens" ]];then
										echo ".${path[j]}/${dfolder[j]}"
								else
										rm -rf ${dfolder[j]}
								fi
					fi
			fi
			cd $loc
	done
}

# check package needed
check_package(){
	for bp in ${!binary_file[@]};do
					if [ -f $shell/bin/${binary_file[bp]} ] && [ $binary_file[bp]} ];then
							if [[ $1 != "contents" ]];then
									apt purge ${package_name[bp]}
							fi
					fi
	done
}

# more method
heal_shell(){
	cd ${path[0]}
	td=$(cat bash.bashrc | grep stalkersx)
	if [[ $td == "#@stalkersx" ]];then
			rm bash.bashrc
			mv bash.bashrc.old bash.bashrc
	fi
}

# check shell
if [ -d $shell ] && [ ! -z $shell ];then
		check_in
		if [[ $1 == "-c" ]];then
				check_package contents
				check_data contents
				heal_shell
		elif [[ $1 == "-r" ]];then
				check_package remove
				check_data remove
				heal_shell
			else
					echo $usage
			fi
else
		notif 0 $shell
fi
