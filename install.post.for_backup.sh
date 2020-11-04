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
        source  "./config.ini"
        source  "/etc/server.lan/config.ini"
        
        echo ''

        # {
            # backup rsync  --> remote
            ## ./cron.d/backup.sh  -> backup.{borg,remote}.sh
            ### ....

            ## /etc/crontab  <--- backup.sh   (run by root)
            ### 0 * * * *  root  /usr/lib/server.lan/cron.d/borg.backup.sh
        # }

        # #@ sever.lan side
        echo "[INFO] gen ssh key , type=rsa "
        id_rsa_key="/home/${username_}/.ssh/id_rsa"
        echo "   ssh-key -> ${id_rsa_key} "
        echo "   ssh-key.pub -> ${id_rsa_key}.pub "
        sudo -u ${username_} ssh-keygen -t rsa  -f  "${id_rsa_key}"
        sudo chown ${uid_}:${gid_}   "${id_rsa_key}"  "${id_rsa_key}.pub" "/home/${username_}/.ssh/"        

        read -p "[Input] input the backup.lan's ip "  backup_ip
        cp /etc/hosts /etc/hosts.backup
        {
            echo "${backup_ip}  backup.lan "  

            grep -v "backup.lan" /etc/hosts.backup
            
        } | tee -a /etc/hosts

        echo "[INFO]  IP=${backup_ip} "
        echo 

        echo "[INFO] ssh-copy-id "
        ssh-copy-id -i "${id_rsa_key}.pub"   ${username_}@backup.lan  
    )
    echo "[DONE] !!! "
}

##########################################################################
function backup_lan_gen_ {
    echo "[INFO]::"
    echo "          groupadd , useradd "
    echo "          mountpoint_ :: mkdir && mount && chown :: disk_label=disk_backupX "
    echo "          mount disk :: /etc/fstab"
    echo "          server.lan_ssh pub key --> "
    
    echo "          "
    (
        # #@ backup.lan  side 

        cd  "`dirname $0`"
        source  "./config.ini"
        source  "/etc/server.lan/config.ini"

        ## add user
        echo "[...] backup.lan side.  ENTER to continue, CTR-C to exit"
        read 

        cat << EOF

echo "[INFO]::"
echo "          groupadd , useradd "
echo "          mountpoint_ :: mkdir && mount && chown :: disk_label=disk_backupX "
echo "          mount disk :: /etc/fstab"
echo "          server.lan_ssh pub key --> "


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
### server.lan :: ssh-copy-id  -i  ${username_}@backup.lan

EOF

    )
}

#####################

function print_help_ {
    echo "arg1 = server.lan | backup.lan "
    
    echo "    1. remote_backup side "
    echo "    2. server side "

    echo 
    exit 1
}

############

if [ -z "$1" ];then
    _check_and_apt_install borgbackup
    _check_and_apt_install rsync
    server_lan_
    backup_lan_gen_    
elif [ "$1" == "--help" -o "$1" == "-h" ];then
    print_help_
fi






