#!/bin/bash



### readme
## run at boot time
## 



function do_do_check__ {
	echo $0

	sleep 10

	/bin/mount -a

	sleep 1

	for ((n=0;i<33;i++));do
		if mountpoint /mnt/hb.mountpoint/dataX	
		then
			sleep 1
			break
		else
			sleep $[1+2*n]
			/bin/mount -a
		fi
	done

	if [ `docker ps -a|wc -l` -le 2 ];then
		/etc/init.d/docker restart
	fi

	if ! mountpoint /mnt/hb.mountpoint/dataX;then
		exit 1
	fi

}


do_check__


(
	cd `dirname $0`
	pwd

	date

	for i in *_service.sh;
	do
		echo "[INFO]::`date`:: try to run service :: $i";
		bash "./$i" &i

		echo '[OK]'

		echo ''
	done
)

docker ps -a 
echo ''

echo '[OK]all is done'



