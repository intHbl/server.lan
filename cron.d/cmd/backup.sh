#!/bin/bash

# (user != root) cron entry

# TODO :: add to cron shells 
# user == runner == 2000:2000


_configfile="/etc/server.lan/config.ini"
if [ -e "${_configfile}" ];then
	source  "${_configfile}"
fi

logs__="${base_dir_data}/data.static_file/logs__"
log_n_=$((`date "+%d"`%10))
log_tmp_="${base_dir_log}/backup.ENTRY.${log_n_}.log" 
log_static_="${logs__}/backup.ENTRY.${log_n_}.log"

(
	cd `dirname $0`

	borg_backup_func="./backup.borg.sh"
    remote_backup_func="./backup.remote.sh"

	if [ ! -f "${STARTLOGFILE}" ];then
		echo "[ERR] service not started"
		echo "##########################"
		echo "  please run  ' sudo bash /usr/lib/server.lan/services/start.sh ' "
		echo "##############################"
		exit 1
	fi

    # backup
    # needBackupList=(gitea	seafile	bitwarden)

	## install borg_backup
	if ! which borg || ! which rsync ; then
		echo "[Warning] need install borgbackup|rsync, installing"
		apt update

		apt install borgbackup -y
		apt install rsync -y
	fi

	for serviceName in ${needBackupList[*]}; do
            # 1#.backup to backup disk :: borg
			echo 
			echo 
			echo "#############"
			echo "############## Borg Backup ##################"
			echo "[INFO] backup for ${serviceName} "
			bash "${borg_backup_func}" "${serviceName}"
			echo "############## rsync backup ###################  #"
            # 2#.backup to remote :: rsync ....  &
            bash "${remote_backup_func}" "${serviceName}" & 
	done
	
	

)  2>&1 | tee  "${log_tmp_}" | tee "${log_static_}" 
