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
	echo "[INFO]::remote backup :: `date` "
	echo 
	echo "[INFO] backup for     ${__SERVICE_NAME__} "

    # from
	borg_repo_path="${base_dir_data_mnt}/backup.${__SERVICE_NAME__}"
    # to
	remote_="${username_}@${remote_host_}"
	remote_path="${remote}:${borg_repo_path}"
	remote_ssh_key_="/home/${username_}/.ssh/${remote_host_}_id_rsa"
	function remote_backup_func_ {
		rsync -r  -i "${remote_ssh_key_}" "${borg_repo_path}"   "${remote_path}"
	}
	# .../data.${__SERVICE_NAME__}

    # check
	## directories
	{
		if [ -z "${base_dir_data_mnt}" ];then
			echo "[Err] :: please set arg :: 'backup_base_path' -> 'base_dir_backup_mnt' "
			exit 1
		fi

		if  ! mountpoint ${base_dir_data_mnt} ;then
			echo "[Err] disk::backup is not mounted"
			exit 1
		fi
	}
	## ssh
	{
		if [ -z "${remote_host_}" ];then
			# default ->  backup.lan
			# set ssh rsa key => ssh/id_rsa
			echo "[Warning] :: rsync exit:: `date` :: remote host did not set"
			exit 0
		fi
		
		if [ ! -e "${remote_ssh_key_}" ];then
			echo "[Err] ssh private key not exists :: ${remote_ssh_key_}"
			exit 1
		fi
	}
	

	echo "[Info] starting rsync ...:: ${borg_repo_path} -> ${remote_path}"
	echo " - - - - - - - - - - - - - - - - - - - - - - "
	remote_backup_func_


	echo ""
	echo "[Info] DONE"
	echo " _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ "

)  2>&1 | tee "${base_dir_log}/backup.${__SERVICE_NAME__}.remote.$((`date "+%d"`%10)).log" | tee  "${logs__}/backup.${__SERVICE_NAME__}.remote.log"
