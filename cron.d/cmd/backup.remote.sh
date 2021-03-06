#!/bin/bash

# backup
# needBackupList=(gitea	seafile	bitwarden)
# setting

__service_name__="$1"
if [ -z "${__service_name__}" ] || [ ${__service_name__} == "TODO" ];then
	echo [ERR] need a service name;
	exit 1
fi
_containername="${__service_name__}_server.lan"

_configfile="/etc/server.lan/config.ini"
source  "${_configfile}"

logs__="${base_dir_data}/data.static_file/logs__"
log_n_=$((`date "+%-d"`%10))
log_tmp_="${base_dir_log}/backup.${__service_name__}.remote.${log_n_}.log" 
log_static_="${logs__}/backup.${__service_name__}.remote.${log_n_}.log"

(
	echo "[INFO]::remote backup :: `date` "
	echo 
	echo "[INFO] backup for     ${__service_name__} "

    # from
	borg_repo_path="${base_dir_backup_mnt}/backup.${__service_name__}"
    # to
	remote_="${username_}@${remote_host_}"
	remote_path="${remote_}:${borg_repo_path}"

	ssh_pubkey_="/home/${username_}/.ssh/id_rsa.pub"
	# id_rsa_key="/home/${username_}/.ssh/${remote_host_}.id_rsa"
	


	function remote_backup_func_ {

		# rsync -r  -i "${ssh_pubkey_}" "${borg_repo_path}"   "${remote_path}"
		rsync -av -e ssh "${borg_repo_path}"   "${remote_path}"
	}
	# .../data.${__service_name__}

    # check
	## directories
	{
		if [ -z "${base_dir_backup_mnt}" ];then
			echo "[Err] :: please set arg :: 'backup_base_path' -> 'base_dir_backup_mnt' "
			exit 1
		fi

		if  ! mountpoint ${base_dir_backup_mnt} ;then
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
		
		if [ ! -e "${ssh_pubkey_}" ];then
			echo "[Err] ssh private key not exists :: ${ssh_pubkey_}"
			exit 1
		fi
	}
	

	echo "[Info] starting rsync ...:: ${borg_repo_path} -> ${remote_path}"
	echo " - - - - - - - - - - - - - - - - - - - - - - "
	remote_backup_func_


	echo ""
	echo "[Info] DONE"
	echo " _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ "

)  2>&1 | tee "${log_tmp_}" | tee  "${log_static_}"
