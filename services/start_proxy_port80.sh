#!/bin/bash

# config
server_name="http_port80"
config_file="/etc/server.lan/config.ini"
source  "${config_file}"

# template
# (

#     cd `dirname $0`

#     # config
#     source  "${config_file}"
#     # init env and ( start container if exits)
#     source "./init.env_and_start.rc"

# )

(
    _software_dir="/usr/lib/server.lan/port80"
    if [ ! -d "${_software_dir}" ];then
        echo "[ERR]::${_software_dir}:: is not exists "
        exit 1
    fi
    cd "${_software_dir}"

    for ((ii=0;ii<3;ii++));do
        if [ ! -e "http_server" ];then
            container_name='port80_http_server'
            echo "[info] ::$0::  copy from docker container "
            docker run --rm  \
                -v "$(pwd)":/data  \
                --name="${container_name}"  \
                inthbl/port80-armhf
        fi
        if [ -e "http_server" ];then
            break
        fi
        sleep 1
    done


    if [ ! -e "http_server" ];then
        echo "[Err] ::$0:: have no 'http_server'"
        exit 1
    elif [ ! -x "http_server" ];then
        chmod u+x http_server
    fi

    # run as root
    pidfile=/run/server.lan_http_server.pid
    if [ -e "${pidfile}" ];then
        echo "[INFO] ::$0:: kill process :: pid==`cat ${pidfile}`"
        kill `cat ${pidfile}`
    fi

    echo 
    
    start-stop-daemon --start --quiet --oknodo \
            --background --chuid 0:0  \
                --make-pidfile  --pidfile \
                "${pidfile}" --exec "`pwd`/http_server"

    
    echo -e "\n\n[INFO] pid == `cat "${pidfile}"`"
    ps ax | grep -F http_server | grep -v "grep"
    echo 
    echo "[OK]::$0::done"

) >> "/tmp/server.lan_${server_name}.log"

