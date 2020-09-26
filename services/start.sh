#!/bin/bash


# readme
# this 'start.sh' script
## do check
## then run  service.sh
## run at boot time 
## run by root
## 


# config
config_file="/etc/server.lan/config.ini"
source  "${config_file}"


function do_check__ {
	echo "[INFO]::$0::`date`::start check disk mount, log dir"

	sleep 10

	/bin/mount -a

	sleep 1

	for ((ii=0;ii<33;ii++));do
		if mountpoint ${base_dir_data}
		then
			sleep 1
			break
		else
			sleep $[1+2*n]
			echo "[INFO] try mount auto :: 'mount -a' "
			/bin/mount -a
		fi
	done

	if [ `docker ps -a|wc -l` -le 2 ];then
		/etc/init.d/docker restart
	fi

	if ! mountpoint ${base_dir_data} ;then
		echo "[Err] ${base_dir_data} is not mountpoint"
		exit 1
	fi

	if [ ! -e "${base_dir_log}" ];then
		mkdir -p "${base_dir_log}"
		chown ${uid_}:${gid_}  "${base_dir_log}"
	fi

	echo "[OK]::$0::`date`::check done"

}




(

	do_check__

	cd "$(dirname "$0")"
	echo "[INFO] current dir :: `pwd`"
	

	for i in sh_*_service.sh;
	do
		echo "[INFO]::`date`:: try to run service :: './$i &'";

		bash "./$i" &

		echo "[OK]::$i"
		echo ""
		sleep 2
	done

	for i in rc_*_service.rc;
	do
		echo "[INFO]::`date`:: try to run service :: './$i &'";
		bash "./run_rc.sh" "$i"
		sleep 1
		echo ""
	done

	sleep 10

	echo ""
	echo "[OK]::$0::all is done"

	docker ps -a 
	
) > /tmp/server.lan__start.log

