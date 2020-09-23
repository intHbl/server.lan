#!/bin/bash

# TODO :: add to cron shells 
# user == runner == 2000:2000

serviceNames=(
	gitea
	seafile
	bitwarden
)



(
	cd `dirname $0`

	backup_func="./backup_func.sh"

	if [ ! -f "/tmp/server.lan_serviceStarting.log" ];then
		echo "[ERR] service not started"
		exit 1
	fi

	for serviceName in ${serviceNames[*]}; do
			echo "[INFO] backup for ${serviceName} "
			bash "${backup_func}" "${serviceName}";
	done

)
