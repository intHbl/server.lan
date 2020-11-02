#!/bin/bash

# (user == root) cron entry
# crontab :: run @ 03:55  by  root



_configfile="/etc/server.lan/config.ini"
if [ -e "${_configfile}" ];then
	source  "${_configfile}"
fi

logs__="${base_dir_data}/data.static_file/logs__"
if [ ! -e "${logs__}/" ];then
    mkdir "${logs__}"
fi

(
    # information
    echo "---- ____ ---- ____"
    date
    echo "[cpu] temperature"
    for tt in `cat /sys/class/thermal/thermal_zone*/temp` ;do 
        echo $(($tt/1000));
    done

    echo "[disk]information"
    echo
    df -h /dev/disk/by-label/*
    echo
    du -sh ${base_dir_data}/data.*
    du -sh ${base_dir_backup}/backup.*
    du -sh ${base_dir_download}/data.*
    du -sh ${base_dir_download}/download.*
    echo
    lsblk
    echo 
    mount | grep -E "^/dev"

) > "${logs__}/info_cpuTemp_disk.log" 2> /dev/null 

exit 0

(

    true

) > "${logs__}/info_xxxx.log" 2> /dev/null 
