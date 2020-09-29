#!/bin/bash


# setting

_name__="$1"
if [ -z "${_name__}" ] || [ ${_name__} == "TODO" ];then
	echo [ERR] need a service name;
	exit 1
fi

_configfile="/etc/server.lan/config.ini"
source  "${_configfile}"

(

	echo "[INFO] backup for     ${_name__} "
	# .../${_name__}_server
	backup_base_path="${base_dir_backup}"
	data_base_path="${base_dir_data}"
	# .../data.${_name__}

	{
		if [ -z "${backup_base_path}" ];then
			echo "[Err] :: please set arg :: 'backup_base_path' "
			exit 1
		fi

		if [ ! -d "${backup_base_path}" ];then
			echo "[Err] :: is not a dir :: ${backup_base_path} "
			exit 1
		fi

		if  ! mountpoint ${backup_base_path} ;then
			echo "[Err] disk::backup is not mounted"
			exit 1
		fi


		if [ -z "${data_base_path}" ];then
			echo "[Err] :: please set arg :: 'data_base_path' "
			exit 1
		fi

		if [ ! -d "${data_base_path}" ];then
			echo "[Err] :: is not a dir :: ${data_base_path} "
			exit 1
		fi

		if  ! mountpoint ${data_base_path} ;then
			echo "[Err] disk::data is not mounted"
			exit 1
		fi
	}

	

	###############
	_repo_path=${backup_base_path}/backup.${_name__}
	export BORG_PASSPHRASE=mima123456

	if [ ! -e ${_repo_path} ];then
			borg  init -e repokey     ${_repo_path}
	fi

	# do backup and write logs
	## borg  create  --stats -p  <_repo_path>::<tag>  </path/of/need/packup>  </path/of/need/packup…>
	{
		date
		docker stop ${_name__}_server

		tag=`date +%Y%m%d_%H%M%S`
		borg  create  --stats -p  ${_repo_path}::${tag}  ${data_base_path}/data.${_name__}

		docker start ${_name__}_server

		echo "---- ---- ----"
		echo

	}  


	unset BORG_PASSPHRASE

	## rsync -r 
	# TODO :: rsync
	if [ -z "${remote_host_}" ];then
		echo "[Warning] :: rsync exit:: `date` :: remote host did not set"
		exit 0
	fi
	remote_dir="${username_}@${remote_host_}:/${base_dir_backup}/backup.${_name__}"
	## rync -r  "${_repo_path}"   "${remote_dir}"
	#TODO

)  &> "${base_dir_log}/backup.${_name__}.$((`date "+%d"`%10)).log"