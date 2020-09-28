#!/bin/bash


## functional ::  all most for starting docker container 

# config
server_name=$(basename "$1")
##  rc_XXservernameXX_service.rc  ==> XXservernameXX
server_name="${server_name:3:-11}"
config_file="/etc/server.lan/config.ini"
source  "${config_file}"

(

    cd `dirname $0`

    # config
    source  "${config_file}"
    # init env and ( start container if exits)
    source "./init.env_and_start.rc"

	# 
	source "$1"

) >> "${base_dir_log}/${server_name}.log"

