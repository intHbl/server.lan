#!/bin/bash

set -e

seafile_path="/seafile"
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




#################

echo "[INFO] `date` init data"
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

(
    function mk_ln_for_dir_ {
            # ln -s   /data/ccnet/           ccnet         || true
            if [ -d "$2" ];then
                return
            fi
            echo "[INFO] make soft link :: ln -s $1 $2 "

            ln -s   "$1" "$2"   || true

    }

    cd "${seafile_path}"
    
     ln -s   /data/seahub.db       seahub.db  || true

     mk_ln_for_dir_   /data/ccnet/           ccnet          
     mk_ln_for_dir_   /data/conf/            conf           
     mk_ln_for_dir_   /data/seafile-data/    seafile-data  
     mk_ln_for_dir_   /data/seahub-data/     seahub-data    
     mk_ln_for_dir_   /data/logs/            logs           
     mk_ln_for_dir_ "${seafile_path}/seafile-server-7.0.5/"  "${seafile_path}/seafile-server-latest" 

    mk_ln_for_dir_ "${seafile_path}/seafile-server-7.0.5/"  "${seafile_data_dir}/seafile-server-latest" 

) 2> /dev/null

##################

echo "[INFO] `date` :: run seafile seahub"
{
date
echo "[INFO] arg1=$1 "


for ((i=0;i<3;i++));do
	if check_and_run "${seafile_path}/seafile-server-latest/seafile.sh"  "$1";then
		break
	fi
    sleep 1
done

for ((i=0;i<3;i++));do
	if check_and_run "${seafile_path}/seafile-server-latest/seahub.sh"   "$1";then
		break
	fi
    sleep 1
done
} > /tmp/server.lan_seafile.startting.log
echo "[done] `date` :: seafile seahub"



# tail -f /dev/null
if [ "x$2" == 'x' ] ; then
  tail -f /dev/null
fi

