#!/bin/bash


# readme
# this 'start.sh' script
## do check
## then run  service.sh
## run at boot time 
## run by root
## 


# /etc/server.lan/
# /usr/lib/server.lan/
# /var/server.lan/{data,backup,download}

if [ `id -u` -ge "1000" ];then
	echo "[Err] user != root , use 'sudo ',or su to root "
	exit 1
fi


(
	# config
	config_file="/etc/server.lan/config.ini"
	if [ ! -e "${config_file}" ];then
		echo "[Err]::config_file not exists::${config_file}"
		exit 1
	fi

	source  "${config_file}"
	cd "$(dirname "$0")"

	function _do_check__ {

		# pre run start.

		echo "[INFO]::$0::`date`::start check disk mount, log dir"

		## disk
		for ((ii=0;ii<16;ii++));do
			if [ "${ii}" -eq 15 ];then
				echo "[Err] ${base_dir_data} is not mountpoint"
				exit 1
			fi

			if mountpoint ${base_dir_data} ;then
				sleep 1
				break
			else
				sleep $[1+2*ii]
				echo "[INFO] try mount auto :: 'mount -a' "
				/bin/mount -a
			fi
		done

		if ! mountpoint ${base_dir_download} ;then
			echo "[Err] ${base_dir_download} is not mountpoint"
			exit 1
		fi

		# if [ `docker ps -a|wc -l` -le 2 ];then
		# 	/etc/init.d/docker restart
		# fi


		## log
		if [ ! -e "${base_dir_log}" ];then
			mkdir -p "${base_dir_log}"
			chown ${uid_}:${gid_}  "${base_dir_log}"
		fi

		echo "[OK]::$0::`date`::check done"

	}

	

	# run 80 port for `home page` and `reverse proxy`.
	bash ./start_proxy_port80.sh &

	# check for services.
	_do_check__


	echo "[INFO] current dir :: `pwd`"
	

	for i in sh_*_service.sh;
	do
		if [ ! -f "$i" ];then
			continue
		fi
		echo "[INFO]::`date`:: try to run service :: './$i &'   ";

		bash   "./$i"   &

		echo "[OK]::$i"
		echo ""

		sleep 1
	done

	for i in rc_*_service.rc;
	do
		if [ ! -f $i ];then
			continue
		fi

		echo "[INFO]::`date`:: try to run service :: './$i &'    ";

		bash   "./run_rc.sh"   "$i"  & 
		echo "[OK]::$i"
		echo ""

		sleep 1
		
	done

	sleep 10

	echo ""
	echo "[OK]::$0::all is done"

	docker ps -a 
	
) | tee /tmp/server.lan__start.log


