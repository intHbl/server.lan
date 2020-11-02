#!/bin/bash


## email for server side
(
    cd "`dirname "$0"`"



    source "./scripts/source_config.rc"

    _dataX="${base_dir_data}"

    PATH="/bin:/sbin:${PATH}"


    function addTOBitwarden {
        docker rm "bitwarden_server.lan" &> /dev/null
    }

    function addTOGitea {
        _target=${_dataX}/data.gitea/gitea/conf/app.ini
        if [ ! -f "${_target}" ];then
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
        } >> "${_target}"

    }


    function addTOSeafile {
        _target=${_dataX}/data.seafile/conf/seahub_settings.py
        if [ ! -f "${_target}" ];then
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
        echo "[OK]"
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


    function stop_container {

        echo "[Info] stop container :: $1"
        docker stop "$1"

    }

    function start_container {

        echo "[Info] start container :: $1"
        docker start "$1" 2> /dev/null

    }

    stop_container bitwarden_server.lan
    stop_container gitea_server.lan
    stop_container seafile_server.lan

    addTOBitwarden
    addTOGitea 
    addTOSeafile 


    # then restart container
    bash ./services/run_rc.sh rc_bitwarden_service.rc
    start_container gitea_server.lan
    start_container seafile_server.lan


)