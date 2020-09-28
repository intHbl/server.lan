#!/bin/bash

# (user == root) cron entry



_configfile="/etc/server.lan/config.ini"
if [ -e "${_configfile}" ];then
	source  "${_configfile}"
fi


(
    # information
    echo "---- ____ ---- ____"
    date
    echo cpu temperature
    for tt in `cat /sys/class/thermal/thermal_zone*/temp` ;do 
        echo $(($tt/1000));
    done

    echo "[...]disk information"
    echo
    df -h /dev/disk/by-label/*
    echo
    du -sh ${base_dir_data}/data.*
    du -sh ${base_dir_backup}/backup.*
    du -sh ${base_dir_download}/data.*
    du -sh ${base_dir_download}/download.*

) > " ${base_dir_log}/information.log" 2> /dev/null 
