#!/bin/bash


# inited == have run  `sudo bash /usr/lib/server.lan/service/start.sh `


(

    cd "`dirname "$0"`"



    source "./scripts/source_config.rc"

    _dataX="${base_dir_data}"

    PATH="/bin:/sbin:${PATH}"



    # for gitea borg backup
    chown  "${uid_}:${gid_}"  "${_dataX}/data.${__service_name__}/git/.ssh"
    chown -R "${uid_}:${gid_}"  "${_dataX}/data.${__service_name__}/git/.ssh"


    # set Email sending
    # bash ./install.post.set_email.sh
    echo "[INFO] set Email sending "
    echo "       sudo bash ./install.post.set_email.sh"
    

)