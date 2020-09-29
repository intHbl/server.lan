#!/bin/bash

## 3/3 disk mount && ln -s 
## 2/3 build docker image
## 1/3 install docker



( 
    cd  "`dirname $0`"      
    source  "scripts/source_config.rc"

    # 1 install docker
    function _check_and_install_deb {
        if ls $1;then
            dpkg -i "$1"
            echo "[INFO]::install DONE::$1"
        fi
    }

    if ! which docker ;then
        ## download  docker deb armhf
        # TODO
        #
        wget -c  https://download.docker.com/linux/debian/dists/buster/pool/stable/armhf/containerd.io_1.2.13-2_armhf.deb
        wget -c  https://download.docker.com/linux/debian/dists/buster/pool/stable/armhf/docker-ce-cli_19.03.12~3-0~debian-buster_armhf.deb
        wget -c https://download.docker.com/linux/debian/dists/buster/pool/stable/armhf/docker-ce_19.03.12~3-0~debian-buster_armhf.deb

        ##install
        _check_and_install_deb  containerd.io_*.deb  
        _check_and_install_deb  docker-ce-cli_*.deb  
        _check_and_install_deb  docker-ce_*.deb 
    fi


    # 2 build docker image  if not exists in `hub.docker.com`
    echo '[WARN] build docker image if not exists in <hub.docker.com>'
    echo "   ./build.sh"

    # 3 disk

    ## mount
    function _mkdir_mnt_point {
        if [ -z "$1" ];then
            return
        fi
        _tmp="${1}"

        if [ ! -e "${_tmp}" ]; then
            mkdir -p "${_tmp}"
        elif  [ ! -d "${_tmp}" ]; then
            echo err
            return
        fi
        chown ${uid_}:${gid_}  "${_tmp}"
    }
    ### mnt.dir
    _mkdir_mnt_point  "${base_dir_data_mnt}"
    _mkdir_mnt_point  "${base_dir_backup_mnt}"
    _mkdir_mnt_point  "${base_dir_download_mnt}"
    ### mnt.fstab
    function _check_and_echo {
        if ! grep -F "$1" /etc/fstab > /dev/null;then
            echo $1
            return 0
        else
            return 1
        fi
    }
    function _fstab {
        echo "[INFO] please eidt <</etc/fstab>> later"
        
        {
            if _check_and_echo "#LABEL=disk_dataX     ${base_dir_data_mnt}      ext4  defaults,nofail  0  2"  \
                || _check_and_echo "#LABEL=disk_backupX   ${base_dir_backup_mnt}    ext4  defaults,nofail  0  2" \
                || _check_and_echo "#LABEL=disk_downloadX ${base_dir_download_mnt}  ext4  defaults,nofail  0  2" ;then
                    ls -l /dev/disk/by-label/*
            fi
        } >> /etc/fstab
    }

    _fstab


    ## soft link
    function _soft_ln {
        if [ -z "$2" ];then
            return
        fi
        _tmp="`dirname "${2}"`"
        if [ -e "${_tmp}" ] && [ ! -d "${_tmp}" ]; then
            echo err
            return
        else
            mkdir -p "${_tmp}" 
        fi
        chown ${uid_}:${gid_}  "${_tmp}"

        ln -s "${1}" "${2}"
    }


    _soft_ln  "${base_dir_data_mnt}"     "${base_dir_data}"
    _soft_ln  "${base_dir_backup_mnt}"   "${base_dir_backup}"
    _soft_ln  "${base_dir_download_mnt}" "${base_dir_download}"


)



##############################
#     # 3. docker config ; turn off  docker log.
#     cat << EOF | tee /etc/docker/daemon.json   > /dev/null
# {
#     "data-root":"${base_dir_data}/docker",
#     "log-driver": "none",
#     "log-opts": {
#         "max-size": "10m",
#         "max-file": "2"
#     }
# }
# EOF 


