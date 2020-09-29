#!/bin/bash


## functional ::  almost for starting docker container 

# config
server_name=$(basename "$1")
##  rc_XXservernameXX_service.rc  ==> XXservernameXX
server_name="${server_name:3:-11}"
config_file="/etc/server.lan/config.ini"

(

    cd `dirname $0`
    if [ ! -e "${config_file}" ];then
        echo "[Err] config_file::not exists"
        exit 1
    fi
    # config
    source  "${config_file}"
    # init env and ( start container if exists)
    source "./init.env_and_start.rc"

	# or (run a new container if not exists)
	source "$1"

) >> "${base_dir_log}/${server_name}.log"

