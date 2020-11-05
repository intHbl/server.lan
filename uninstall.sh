#!/bin/bash


# 3 directories totally , bin  data  config
#####################################

# rm  container## rm container if exists
for _dockerfile in docker.* docker/docker.*  ;do
    if [ -e "${_dir_dockerfile}" ];then
        # docker.xxxxxx
        _server_name=$(basename "${_dir_dockerfile}")
        container_name="${_server_name:7}_server.lan"

        docker rm -f  "${container_name}" 
    fi
done


# rm /usr/local/server.lan
rm -r /usr/local/server.lan/*


# !!! don't delete 
## config(/etc/server.lan/)  and   
## data(/var/lib/server.lan/)



######### others # ######
## rc.local
## crontab