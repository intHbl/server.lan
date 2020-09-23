#!/bin/bash

# check whether mountpoint or not
mntpoint='/mnt/hb.mountpoint/dataX'
##

for ((i=0;i<3;i++));do
	if mountpoint -q "${mntpoint}";then
		break;
	else
		sleep $[1+i*5]
	fi
done

if ! mountpoint "${mntpoint}"
then
	echo '[ERR] please mount dataX disk'
	exit  1
fi

# data dir
dataPath="${mntpoint}/data.aria2"
##
if [ ! -e "$dataPath" ];then
	mkdir -p  "$dataPath"
fi
chown 2000:2000 "$dataPath"

if [ ! -e "$dataPath/ariaNg.html" ];then
	cp port80/ariaNg.html "$dataPath/"
fi


if [ -d "$dataPath/download" ] ;then
	chmod  0777 "$dataPath/download"
fi


# docker 
container_name='aria2_server'
##
if  [ `docker ps -aq -f name=^"${container_name}"$` ]
then
	echo "[INFO] container is starting :: ${container_name}"
	docker start  ${container_name}
else 
	docker run -d  \
	-v $dataPath:/data  \
	-p  6800:6800  \
	--name=${container_name}  \
	inthbl/aria2-armhf
		#:v20200727 --> latest
fi


#
#

