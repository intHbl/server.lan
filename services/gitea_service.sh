#!/bin/bash

# check whether mountpoint or not
mntpoint='/mnt/hb.mountpoint/dataX'
##
if ! mountpoint "${mntpoint}"
then
	echo '[ERR] please mount dataX disk'
	exit  1
fi

# data dir
dataPath="${mntpoint}/data.gitea"
##
if [ ! -e "$dataPath" ];then
	mkdir -p  "$dataPath"
fi
chown 2000:2000 "$dataPath"


# docker 
container_name='gitea_server'
##
if  [ `docker ps -aq -f name=^"${container_name}"$` ]
then
	echo "[INFO] container is starting :: ${container_name}"
	docker start  ${container_name}
else 
	docker run -d  \
  -v $dataPath:/data  \
  -p  10022:22  \
  -p  127.0.0.1:3000:3000  \
  --name=${container_name}  \
  inthbl/gitea-armhf
	  #:v20200716 --> latest
fi


#
#


