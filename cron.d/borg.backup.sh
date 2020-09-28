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

	backup_func="./backup_func.sh"

	if [ ! -f "/tmp/server.lan_serviceStarting.log" ];then
		echo "[ERR] service not started"
		exit 1
	fi


	for serviceName in ${needBackupList[*]}; do
			echo "[INFO] backup for ${serviceName} "
			bash "${backup_func}" "${serviceName}";
	done
	
	

)  &> "${base_dir_log}/backup._start.$((`date "+%d"`%10)).log"

