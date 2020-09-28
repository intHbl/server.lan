#!/bin/bash



function _check_and_apt_install {
    if [ -z "$1" ];then
        return
    fi
    if ! which $1;then
        apt install -y $1
    fi
}

_check_and_apt_install borgbackup
_check_and_apt_install rsync



config_file="/etc/server.lan/config.ini"
( 
    cd  "`dirname $0`"

    if [ ! -e `dirname "${config_file}"` ];then
        mkdir -p `dirname "${config_file}"`
    fi

    if [ ! -e "${config_file}" ];then
        cp config.ini  "${config_file}"
    fi

    source  "${config_file}"

    # /etc/crontab  <--- backup 
    ## borgbackup # run by ${uid_} ${username_}
    # "TODO" add_to_cron   /usr/lib/server.lan/cron.d/borg.backup.sh

    ## rsync  --> remote
    #"TODO" add_to_cron    /usr/lib/server.lan/cron.d/rsync.backup.sh

)
