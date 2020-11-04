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



( 
    cd  "`dirname $0`"
    source  "scripts/source_config.rc"
    
    echo '

    # backup rsync  --> remote
    ## ./cron.d/backup.sh  -> backup.{borg,remote}.sh
    ### ....

    ## /etc/crontab  <--- backup.sh   (run by root)
    ### 0 * * * *  root  /usr/lib/server.lan/cron.d/borg.backup.sh

    # remote  , run @ backup.lan
    ## add user :: useradd -m  ${uid_}  -g ${gid_}  ${username_}
    ## scp ${username_}@server.lan:~/.ssh/backup.lan.id_rsa.pub  ~/.ssh/backup.lan.id_rsa.pub
    ## 
    '

)
