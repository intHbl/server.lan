#!/bin/bash


## email for server side

source "./scripts/source_config.rc"

_dataX="${base_dir_data}"

PATH="/bin:/sbin:${PATH}"


function addTOBitwarden {
     docker rm ` docker stop  bitwarden_server.lan` 
}

function addTOGitea {
    _target=${_dataX}/data.gitea/gitea/conf/app.ini
    if [ ! -f "${_target }" ];then
        echo "[Err] app config not found, please run <'install.sh'> before this"
        return 1
    fi
    { 
        echo "
[mailer]
ENABLED = true
HOST    = ${_EMAIL_HOST}:${_EMAIL_PORT}
FROM    = \"server.Bot\"<${_EMAIL}>
USER    = ${_EMAIL}
PASSWD  = ${_EMAIL_SECRET}
" 
    } >> "${_target }"

}


function addTOSeafile {
    ${_dataX}/data.seafile/conf/seahub_settings.py
    if [ ! -f "${_target }" ];then
        echo "[Err] app config not found, please run <'install.sh'> before this"
        return 1
    fi
    {
        echo "
EMAIL_USE_SSL = True
EMAIL_HOST = '${_EMAIL_HOST}'
EMAIL_HOST_USER = '${_EMAIL}'
EMAIL_HOST_PASSWORD = '${_EMAIL_SECRET}'
EMAIL_PORT = '${_EMAIL_PORT}'
DEFAULT_FROM_EMAIL = EMAIL_HOST_USER
SERVER_EMAIL = EMAIL_HOST_USER
"
    } >> "${_target}"

}

exitflag=false
function isEmpty_and_exit {
    if [ -z "$1" ];then
        echo "[Err] arg is not set"
        exitflag=true
    fi
}

echo "[INFO] check mailer settings from  ${config_file}:: 
    _EMAIL_HOST     : `isEmpty_and_exit "${_EMAIL_HOST}"`
    _EMAIL_PORT     : `isEmpty_and_exit "${_EMAIL_PORT}"`
    _EMAIL          : `isEmpty_and_exit "${_EMAIL}"`
    _EMAIL_SECRET   : `isEmpty_and_exit "${_EMAIL_SECRET}"`
"

if ${exitflag};then
    exit 1
fi


addTOBitwarden
addTOGitea 
addTOSeafile 


# then restart container
 bash ./scripts/run_rc.sh rc_bitwarden_service.rc

 docker restart gitea_server.lan
 docker restart seafile_server.lan


