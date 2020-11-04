#!/bin/bash


# init == login at lease once { seafile, gitea,}. 

(

    cd "`dirname "$0"`"



    source "./scripts/source_config.rc"

    _dataX="${base_dir_data}"

    PATH="/bin:/sbin:${PATH}"



    # for gitea borg backup
    chown  "${uid_}:${gid_}"  "${_dataX}/data.${__service_name__}/git/.ssh"
    chown -R "${uid_}:${gid_}"  "${_dataX}/data.${__service_name__}/git/.ssh"


    # set Email sending
    bash ./install.post.set_email.sh

)