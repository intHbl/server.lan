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
    
    echo ''

    {
        # backup rsync  --> remote
        ## ./cron.d/backup.sh  -> backup.{borg,remote}.sh
        ### ....

        ## /etc/crontab  <--- backup.sh   (run by root)
        ### 0 * * * *  root  /usr/lib/server.lan/cron.d/borg.backup.sh
    }

    # #@ sever.lan side
    echo "[INFO] gen ssh key , type=rsa "
    id_rsa_key="/home/${username_}/.ssh/${remote_host_}.id_rsa"
    echo "   ssh-key -> ${id_rsa_key} "
    echo "   ssh-key.pub -> ${id_rsa_key}.pub "
    sudo -u ${username_} ssh-keygen -t rsa  -f  "${id_rsa_key}"
    

    read -p "[Input] input the backup.lan's ip "  backup_ip
    echo "#${backup_ip}  backup.lan"  | tee -a /etc/hosts

    echo "  IP=${backup_ip} , press <ENTER> to continue, CTR-C to exit "
    read 

    # #@ backup.lan  side 
    # , remote  (run @ backup.lan)
    ## add user :: useradd -m  ${uid_}  -g ${gid_}  ${username_}
    ## scp ${username_}@server.lan:~/.ssh/backup.lan.id_rsa.pub  ~/.ssh/backup.lan.id_rsa.pub
    ## 

    scp   ${username_}@server.lan:/home/${username_}/.ssh/  "/home/${username_}/.ssh/${remote_host_}.id_rsa.pub"
    if [ -e "" ];then
        cat "/home/${username_}/.ssh/${remote_host_}.id_rsa.pub" | tee -a  /home/${username_}/.ssh/authorized_keys
    else
        echo "[Err] ::file not exists:: /home/${username_}/.ssh/${remote_host_}.id_rsa.pub""
    fi
)
