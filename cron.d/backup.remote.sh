#!/bin/bash


# TODO
exit 0

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

	echo "[INFO] backup for     ${__SERVICE_NAME__} "
	# .../${__SERVICE_NAME__}_server
    # from
	borg_base_path="${base_dir_backup}"
	borg_repo_path=${borg_base_path}/backup.${__SERVICE_NAME__}
    # to
	remote_base_path="TODO"
	# .../data.${__SERVICE_NAME__}

    # check directories! TODO
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

	

	## rsync -r 
	# TODO :: rsync
	if [ -z "${remote_host_}" ];then
		echo "[Warning] :: rsync exit:: `date` :: remote host did not set"
		exit 0
	fi
	remote_dir="${username_}@${remote_host_}:/${base_dir_backup}/backup.${__SERVICE_NAME__}"
	## rync -r  "${_repo_path}"   "${remote_dir}"
	#TODO

)  2>&1 | tee "${base_dir_log}/backup.${__SERVICE_NAME__}.remote.$((`date "+%d"`%10)).log" | tee  "${logs__}/backup.${__SERVICE_NAME__}.remote.log"
