#!/bin/bash


# readme
#######################################
## docker image
##  https://hub.docker.com/r/bitwardenrs/server/dockerfile
## support os/arch
##  linux/amd64
##  linux/arm/v6
##  linux/arm/v7
##  linux/arm64/v8
#   
## github: https://github.com/dani-garcia/bitwarden_rs/



# 
# check whether mountpoint or not
mntpoint='/mnt/hb.mountpoint/dataX'
##
if ! mountpoint "${mntpoint}"
then
	echo '[ERR] please mount dataX disk'
	exit  1
fi

# data dir
dataPath="${mntpoint}/data.bitwarden"
##
if [ ! -e "$dataPath" ];then
	mkdir -p  "$dataPath"
fi
chown 2000:2000 "$dataPath"


# docker 
container_name='bitwarden_server'
##
if  [ `docker ps -aq -f name=^"${container_name}"$` ]
then
	echo "[INFO] container is starting :: ${container_name}"
	docker start  ${container_name}
else 
    # default port=ROCKET_PORT=80
    docker run -d \
        --user=2000:2000 \
        --name=${container_name} \
        -v ${dataPath}:/data/ \
        -e ROCKET_PORT=8080 \
        -p 9000:8080 \
        bitwardenrs/server
        # :latest
fi


#
#


