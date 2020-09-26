#!/bin/bash



if ! which borgbackup;then
    sudo apt install -y borgbackup
fi


config_file="/etc/server.lan/config.ini"
( 
    cd  `dirname $0`
    source scripts/function.sh

    if [ ! -e `dirname "${config_file}"` ];then
        sudo mkdir -p `dirname "${config_file}"`
    fi
    sudo cp config.ini  "${config_file}"

    source  "${config_file}"

    # /etc/crontab  <--- backup 
    ## borgbackup
    add_to_cron "TODO"


    ## rsync  --> remote
    add_to_cron "TODO"


)