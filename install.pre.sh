#!/bin/bash


## 1/3 disk mount && `ln -s  <mnt> <target> `
## 2/3 docker install :: {x,y,z}.deb

## 3/3 docker image :: pull ; (build if necessary).




( 
    cd  "`dirname $0`"      
    source  "scripts/source_config.rc"


    
    # 1# disk , mount , ln -s ....

    ## mount
    function _mkdir_mnt_point {
        if [ -z "$1" ];then
            return
        fi
        _mnt="${1}"

        if [ ! -e "${_mnt}" ]; then
            mkdir -p "${_mnt}"
        elif  [ ! -d "${_mnt}" ]; then
            echo err
            return
        fi
        chown ${uid_}:${gid_}  "${_mnt}"

    }
    ### mnt.dir
    _mkdir_mnt_point  "${base_dir_data_mnt}"
    _mkdir_mnt_point  "${base_dir_backup_mnt}"
    _mkdir_mnt_point  "${base_dir_download_mnt}"
    ### mnt.fstab


    function __fstab {
        echo 
        echo "[INFO] please eidt <</etc/fstab>> later; mount -a"
        echo
        ls -l /dev/disk/by-label/*
        echo "------------------------------------------------"
        echo "[WARN]::YOU CAN/MUST EDIT THE LABEL='xxx' "
        # /etc/fstab 
        #  LABEL=disk_dataX     ${base_dir_data_mnt}      ext4  defaults,nofail  0  2
        {
        echo "#LABEL=disk_dataX     ${base_dir_data_mnt}      ext4  defaults,nofail  0  2"  
        echo "#LABEL=disk_backupX   ${base_dir_backup_mnt}    ext4  defaults,nofail  0  2" 
        echo "#LABEL=disk_downloadX ${base_dir_download_mnt}  ext4  defaults,nofail  0  2"
        } | tee -a /etc/fstab
        echo "-----------------------------------------------"
        echo

    }

    __fstab


    ## soft link
    function _soft_ln {
        if [ -z "$2" ];then
            return
        fi
        echo "[INFO] ln -s  ${1}  --->  ${2} "

        _tmp="`dirname "${2}"`"

        chown ${uid_}:${gid_}  "${_tmp}"

        ln -s "${1}" "${2}"

    }

    echo
    sleep 1
    echo "[INFO] ln -s "

    _soft_ln  "${base_dir_data_mnt}"     "${base_dir_data}"
    _soft_ln  "${base_dir_backup_mnt}"   "${base_dir_backup}"
    _soft_ln  "${base_dir_download_mnt}" "${base_dir_download}"
    
    echo


################################
    # 2# install docker
    function _check_and_install_deb {
        if ls $1;then
            dpkg -i "$1"
            echo "[INFO]::install DONE::$1"
        fi
    }

    if ! which docker ;then
        ## download  docker deb armhf
        echo "[INFO] install docker"
        echo "     [1/2 downloading....."
        wget -c  https://download.docker.com/linux/debian/dists/buster/pool/stable/armhf/containerd.io_1.2.13-2_armhf.deb
        wget -c  https://download.docker.com/linux/debian/dists/buster/pool/stable/armhf/docker-ce-cli_19.03.12~3-0~debian-buster_armhf.deb
        wget -c  https://download.docker.com/linux/debian/dists/buster/pool/stable/armhf/docker-ce_19.03.12~3-0~debian-buster_armhf.deb

        ## install
        echo "     [2/2 installing....."
        _check_and_install_deb  containerd.io_*.deb  
        _check_and_install_deb  docker-ce-cli_*.deb  
        _check_and_install_deb  docker-ce_*.deb
        echo "     [DONE] docker is installed" 
    fi





#     ## 3. docker config ; turn off  docker log.
    echo "[INFO] docker config :: /etc/docker/daemon.json"
    {
        echo '{'
        echo '    "data-root":"'${base_dir_data}'/docker",'
        if [ "${DEBUG}x" == "DEBUGx" ];then
        echo '    "log-driver": "none",'
        fi
        echo '    "log-opts": {'
        echo '         "max-size": "10m",'
        echo '         "max-file": "2"'
        echo '    }'
        echo '}'
    } | tee /etc/docker/daemon.json

    echo "____________________________________"
####################################
    # 3# build docker image  if not exists in `hub.docker.com`
    echo '[WARN] build docker image if not exists in <hub.docker.com>'
    echo "   [image] ./pull.sh"
    echo "   [image] optional :: ./build.sh"
    
)




