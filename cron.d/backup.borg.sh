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
log_n_=$((`date "+%d"`%10))
log_tmp_="${base_dir_log}/backup.${__service_name__}.borg.${log_n_}.log" 
log_static_="${logs__}/backup.${__service_name__}.borg.${log_n_}.log"

(
	echo "[INFO]::borg backup :: `date` "
	echo 
	echo "[INFO] backup for     ${__service_name__} "
	
	## from
	data_path_base="${base_dir_data_mnt}"
	## to
	backup_path_base="${base_dir_backup_mnt}"

	# docker container :: .../${__service_name__}_server.lan
	# dir :: .../data.${__service_name__}  ->  .../backup.${__service_name__}

	function check_ {
		if [ -z "${backup_path_base}" ];then
			echo "[Err] :: please set arg :: 'backup_path_base' <- 'base_dir_backup_mnt' "
			exit 1
		fi
		if [ -z "${data_path_base}" ];then
			echo "[Err] :: please set arg :: 'data_path_base' <- 'base_dir_data_mnt' "
			exit 1
		fi

		if  ! mountpoint ${backup_path_base} ;then
			echo "[Err] `date`     ::disk::backup is not mounted" 
			# send message to --> TODO
			exit 1
		fi

		if  ! mountpoint ${data_path_base} ;then
			echo "[Err] disk::data is not mounted"
			exit 1
		fi
	}

	check_ 
	

	###############
	_repo_path=${backup_path_base}/backup.${__service_name__}
	export BORG_PASSPHRASE=mima123456

	if [ ! -e ${_repo_path} ];then
			borg  init -e repokey     ${_repo_path}
	fi

	# do backup and write logs
	## borg  create  --stats -p  <_repo_path>::<tag>  </path/of/need/packup>  </path/of/need/packup…>
	{
		echo "[INFO] stop docker container :: ${_containername} "
		docker stop "${_containername}"
		(
			arg_exclude_=""
			case "${__service_name__}" in
			"gitea" )
				arg_exclude_=" -e ${data_path_base}/data.${__service_name__}/ssh "
				;;
			"seafile" )

				true
				;;
			*)
				arg_exclude_=""
			esac

			tag=`date +%Y%m%d_%H%M%S`
			if  borg  create  --stats ${arg_exclude_} -p  ${_repo_path}::${tag}  ${data_path_base}/data.${__service_name__};then
				echo -e "\n\n\n\n #### \n"
				echo "[OK]::`date`   :${__service_name__}:: borg backup DONE"
				echo "[OK]"
				echo "[OK]"
				echo "[OK]"
			else 
				echo -e "\n\n\n\n #### \n"
				echo "[Err]::`date`   ::${__service_name__}:: borg backup err."
				echo "[Err]"
				echo "[Err]"
				echo "[Err]"
				# send message to --> TODO
			fi
		)
		echo -e "\n\n\n\n"
		echo "[INFO] start docker container :: ${_containername} "
		docker start "${_containername}"

		echo "---- ---- ----"
		echo

	}  


	unset BORG_PASSPHRASE

)  2>&1 | tee "${log_tmp_}" | tee  "${log_static_}"
