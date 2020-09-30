#!/bin/bash

set -e

seafile_data_dir='/data'


function check_and_run(){

    if ! [ -e "$1" ] ;then
        echo "[ERR] : $1 : file is not exist"
        return 1
    fi

    if ! [ -x "$1" ] ;then
        echo "[Warn] : $1 : file is not excutable"
    fi

    #run
    "$1" "$2"

}



if ! [ -e ${seafile_data_dir} ] ;then
    echo "[ERR] mount VOLUME to ${seafile_data_dir}"
    exit 1

fi



(
    cd /seafile
    ln -s   /data/seahub.db       seahub.db     || true

    ln -s   /data/ccnet           ccnet         || true
    ln -s   /data/conf/           conf          || true
    ln -s   /data/seafile-data/   seafile-data  || true
    ln -s   /data/seahub-data     seahub-data   || true
)



for ((i=0;i<5;i++));do
    if ! [ -e /data/seahub.db ] || ! [ -e /data/ccnet/ ] || ! [ -e /data/conf/ ] || ! [ -e /data/seafile-data/ ] || ! [ -e /data/seahub-data/ ]
    then
        # -k  keep old files| dont replace
        # tar -C "${seafile_data_dir}" -k -zxvf /seafile.init_data.*.tar.gz 2>/dev/null
        cp -r /initdata/*  "${seafile_data_dir}"
        
    else
        break
    fi
done
if [ "$i" -eq 5 ];then
    echo "[ERR] data init error"
    exit 1
fi

{
date
echo "[INFO] arg1=$1 "

for ((i=0;i<3;i++));do
	if check_and_run "/seafile/seafile-server-latest/seafile.sh"  "$1";then
		break
	fi
    sleep 1
done

for ((i=0;i<3;i++));do
	if check_and_run "/seafile/seafile-server-latest/seahub.sh"   "$1";then
		break
	fi
    sleep 1
done
} > /tmp/server.lan_seafile.startting.log




# tail -f /dev/null
if [ "x$2" == 'x' ] ; then
  tail -f /dev/null
fi

