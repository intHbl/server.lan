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
    {
        echo 
        echo "#${backup_ip}  backup.lan "  
    } | tee -a /etc/hosts

    echo "[INFO]  IP=${backup_ip} "
    echo 
    echo "[WARN]  sudo vi /etc/hosts"
    echo 
    exit 0
)

exit 0

##########################################################################
(
    # #@ backup.lan  side 

    cd  "`dirname $0`"
    source  "scripts/source_config.rc"

    ## add user
    echo "[...] backup.lan side.  ENTER to continue, CTR-C to exit"
    read 
    echo "[INFO] add group user" 
    groupadd -g ${gid_} ${username_}
    useradd -u ${uid_} -g ${gid_} -m  "${username_}"
    usermod  -G docker ${username_}
    ## /etc/fstab
    echo "[INFO] mount"
    echo "[WARN] #   sudo vi /etc/fstab" 
    {
        echo ""
        echo "#LABEL=disk_backupX   /mnt/server.lan/backupX    ext4  defaults,nofail  0  2" 
    } | tee -a /etc/fstab
    
    mnt_="/mnt/server.lan/backupX"
    if [ ! -e "${mnt_}" ];then
        mkdir -p "${mnt_}"
    fi
    mount /dev/disk/by_label/disk_backupX  "${mnt_}"
    chown "${uid_}:${gid_}" "${mnt_}"


    ## pub key >> authorized_keys
    echo "[INFO] sshkey.pub -->> authorized_keys"
    echo "    sudo vi /root/.ssh/authorized_keys"
    id_rsa_key="/home/${username_}/.ssh/${remote_host_}.id_rsa"
    id_rsa_key_pub_="${id_rsa_key}.pub"

    scp   ${username_}@server.lan:${id_rsa_key_pub_}  "${id_rsa_key_pub_}"
    if [ -e "${id_rsa_key_pub_}" ];then
        tmp_="`dirname ${id_rsa_key_pub_}`"
        if [ ! -e "${tmp_}" ];then
            mkdir -p  "${tmp_}"
            chown "${uid_}:${gid_}" "${tmp_}"
        fi
        cat "${id_rsa_key_pub_}" | tee -a  /home/${username_}/.ssh/authorized_keys
    else
        echo "[Err] ::file not exists:: /home/${username_}/.ssh/${remote_host_}.id_rsa.pub"
    fi

)
