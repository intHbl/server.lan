#!/bin/bash

# check whether mountpoint or not
mntpoint='/mnt/hb.mountpoint/dataX'
if  ! mountpoint "${mntpoint}"
then
	echo '[ERR] please mount dataX disk'
	exit 1
fi

# data dir
dataPath="${mntpoint}/data.seafile"
if [ ! -e "$dataPath" ];then
	mkdir -p  "$dataPath"
fi

chown 2000:2000 "$dataPath"

# docker 
container_name='seafile_server'

if [ `docker ps -aq -f name=^"${container_name}"$` ]
then
	echo "[INFO] container is starting :: ${container_name}"
	docker start  ${container_name}
else
	docker run -d \
	-v  "$dataPath":/data \
	-e LANG=en_US.UTF-8 \
	-e LC_ALL=en_US.UTF-8 \
	-p 8000:8000 \
	-p 8080:8080 \
	-p 8082:8082 \
	--name ${container_name} \
	inthbl/seafile-v7.0.5-armhf
		#:v20200712 --> latest
fi


