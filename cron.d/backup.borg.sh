#!/bin/bash


# backup
# needBackupList=(gitea	seafile	bitwarden)
# setting

__SERVICE_NAME__="$1"
if [ -z "${__SERVICE_NAME__}" ] || [ ${__SERVICE_NAME__} == "TODO" ];then
	echo [ERR] need a service name;
	exit 1
fi
_containername="${__SERVICE_NAME__}_server.lan"

_configfile="/etc/server.lan/config.ini"
source  "${_configfile}"

logs__="${base_dir_data}/data.static_file/logs__"


(
	echo "[INFO]::borg backup :: `date` "
	echo "[INFO] backup for     ${__SERVICE_NAME__} "
	# .../${__SERVICE_NAME__}_server
	backup_base_path="${base_dir_backup}"
	data_base_path="${base_dir_data}"
	# .../data.${__SERVICE_NAME__}

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
			echo "[Err] `date`     ::disk::backup is not mounted" 
			# send message to --> TODO
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
	_repo_path=${backup_base_path}/backup.${__SERVICE_NAME__}
	export BORG_PASSPHRASE=mima123456

	if [ ! -e ${_repo_path} ];then
			borg  init -e repokey     ${_repo_path}
	fi

	# do backup and write logs
	## borg  create  --stats -p  <_repo_path>::<tag>  </path/of/need/packup>  </path/of/need/packup…>
	{
		date
		docker stop "${_containername}"

		tag=`date +%Y%m%d_%H%M%S`
		if ! borg  create  --stats -p  ${_repo_path}::${tag}  ${data_base_path}/data.${__SERVICE_NAME__};then
			echo "[Err]::`date`   :: borg backup err."
			# send message to --> TODO
		fi

		docker start "${_containername}"

		echo "---- ---- ----"
		echo

	}  


	unset BORG_PASSPHRASE

)  2>&1 | tee "${base_dir_log}/backup.${__SERVICE_NAME__}.borg.$((`date "+%d"`%10)).log" | tee  "${logs__}/backup.${__SERVICE_NAME__}.borg.log"
