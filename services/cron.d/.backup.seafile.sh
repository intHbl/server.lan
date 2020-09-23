#!/bin/bash


# setting

name="seafile"


##
backup_base_path="/mnt/hb.mountpoint/backupX"
data_base_path="/mnt/hb.mountpoint/dataX"

###############
###############

if [ -z "${name}" ] || [ ${name} == "TODO" ];then
	echo [ERR] need a service name;
	exit 1
fi

###
repo_path=${backup_base_path}/backup.${name}
export BORG_PASSPHRASE=mima123456

if [ ! -e ${repo_path} ];then
        borg  init -e repokey     ${repo_path}
fi

{
docker stop ${name}_server

tag=`date +%Y%m%d_%H%M%S`
borg  create  --stats -p  ${repo_path}::${tag}  ${data_base_path}/data.${name}

docker start ${name}_server
}  &> /tmp/hb.backup.${name}.log




unset BORG_PASSPHRASE


