#!/bin/bash

# (user != root) cron entry

# TODO :: add to cron shells 
# user == runner == 2000:2000


_configfile="/etc/server.lan/config.ini"
if [ -e "${_configfile}" ];then
	source  "${_configfile}"
fi


(
	cd `dirname $0`

	borg_backup_func="./backup.borg.sh"
    remote_backup_func="./backup.remote.sh"

	if [ ! -f "${STARTLOGFILE}" ];then
		echo "[ERR] service not started"
		exit 1
	fi

    # backup
    # needBackupList=(gitea	seafile	bitwarden)

	for serviceName in ${needBackupList[*]}; do
            # 1#.backup to backup disk :: borg
			echo "[INFO] backup for ${serviceName} "
			bash "${borg_backup_func}" "${serviceName}"
            # 2#.backup to remote :: rsync ....  &
            bash "${remote_backup_func}" "${serviceName}" & 
	done
	
	

)  &> "${base_dir_log}/backup._start.$((`date "+%d"`%10)).log"

