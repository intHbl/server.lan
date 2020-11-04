#!/bin/bash


apt_updated=false

function _check_and_apt_install {
    if [ -z "$1" ];then
        return
    fi
    
    if ! which $1;then
        if ! ${apt_updated};then
            apt update 
            apt_updated=true
        fi
        echo "[INFO] atp install   $1  ######################## "
        apt install -y $1
        echo 
        echo 
    fi
}




function server_lan_ {
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
        sudo chown ${uid_}:${gid_}   "${id_rsa_key}"  "${id_rsa_key}.pub" "/home/${username_}/.ssh/"
        

        read -p "[Input] input the backup.lan's ip "  backup_ip
        {
            echo 
            echo "${backup_ip}  backup.lan "  
        } | tee -a /etc/hosts

        echo "[INFO]  IP=${backup_ip} "
        echo 
        echo "[WARN]  sudo vi /etc/hosts"
        echo 
    )
}

##########################################################################
function backup_lan_ {
    echo "[INFO]::"
    echo "          groupadd , useradd "
    echo "          mountpoint_ :: mkdir && mount && chown :: disk_label=disk_backupX "
    echo "          mount disk :: /etc/fstab"
    echo "          server.lan_ssh pub key --> "
    
    echo "          "
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

        mnt_="/mnt/server.lan/backupX"
        if [ ! -e "${mnt_}" ];then
            mkdir -p "${mnt_}"
        fi
        mount /dev/disk/by_label/disk_backupX  "${mnt_}"
        chown "${uid_}:${gid_}" "${mnt_}"

        echo "[WARN] #   sudo vi /etc/fstab" 
        {
            echo ""
            echo "#LABEL=disk_backupX   /mnt/server.lan/backupX    ext4  defaults,nofail  0  2" 
        } | tee -a /etc/fstab
        

        ## pub key >> authorized_keys
        echo "[INFO] sshkey.pub -->> authorized_keys"
        echo "    sudo vi /root/.ssh/authorized_keys"
        server_id_rsa_key="/home/${username_}/.ssh/${remote_host_}.id_rsa"
        backup_id_rsa_key="/home/${username_}/.ssh/server.lan.id_rsa"

        server_id_rsa_key_pub_="${server_id_rsa_key}.pub"
        backup_id_rsa_key_pub_="${backup_id_rsa_key}.pub"

        scp   ${username_}@server.lan:${server_id_rsa_key_pub_}  "${backup_id_rsa_key_pub_}"
        if [ -e "${backup_id_rsa_key_pub_}" ];then
            tmp_="`dirname ${backup_id_rsa_key_pub_}`"
            if [ ! -e "${tmp_}" ];then
                mkdir -p  "${tmp_}"
                chown "${uid_}:${gid_}" "${tmp_}"
            fi
            cat "${backup_id_rsa_key_pub_}" | tee -a  /home/${username_}/.ssh/authorized_keys
        else
            echo "[Err] ::file not exists:: /home/${username_}/.ssh/${remote_host_}.id_rsa.pub"
        fi

    )
}

#####################

function print_help_ {
    echo "arg1 = server.lan | backup.lan "
    echo "    server side || remote_backup side"
    echo 
    exit 1
}

############

if [ -z "$1" ];then
    print_help_    
elif [ "$1" == "server.lan" ];then
    server_lan_
elif [ "$1" == "backup.lan" ];then
    backup_lan_
else
    print_help_
fi

_check_and_apt_install borgbackup
_check_and_apt_install rsync



