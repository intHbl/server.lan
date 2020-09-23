#!/bin/bash


# setting

name="$1"

if [ -z "${name}" ] || [ ${name} == "TODO" ];then
	echo [ERR] need a service name;
	exit 1
fi

# .../${name}_server
backup_base_path="/mnt/hb.mountpoint/backupX"
repo_path=${backup_base_path}/backup.${name}
# .../data.${name}
data_base_path="/mnt/hb.mountpoint/dataX"


if  ! mountpoint ${backup_base_path} ;then
	echo [ERR] disk is not mounted;
	exit 1
fi

###############
export BORG_PASSPHRASE=mima123456

if [ ! -e ${repo_path} ];then
        borg  init -e repokey     ${repo_path}
fi

# do backup and write logs
## borg  create  --stats -p  <repo_path>::<tag>  </path/of/need/packup>  </path/of/need/packup…>
{
	date
	docker stop ${name}_server

	tag=`date +%Y%m%d_%H%M%S`
	borg  create  --stats -p  ${repo_path}::${tag}  ${data_base_path}/data.${name}

	docker start ${name}_server

	echo "---- ---- ----"
	echo

}  &> /tmp/server.lan_backup.${name}.log




unset BORG_PASSPHRASE


