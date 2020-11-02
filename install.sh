#!/bin/bash



echo "!!![WARN] Before those ,  diskes are mounted (and soft links are made). "
echo "   if not , please check 'install.pre.sh' first "
echo

read -p "  is all ready to continue?(y/N)"  _tmp


if [ "y_" == "${_tmp}_" ] || [ "Y_" == "${_tmp}_" ];then
    true
else
    exit 1
fi

if  [ "`whoami`" != "root" ];then
    echo "[Err] please run as root ,current user = `whoami`"
    exit 1
fi
#

# 1 /etc/config.ini
# 1.2  useradd
# 2 /usr/lib/server.lan
# 3 service start entry

_config_file="/etc/server.lan/config.ini"
read -p "  delete config file  ${_config_file} ?(y/N)"  _tmp
if [ "y_" == "${_tmp}_" ] || [ "Y_" == "${_tmp}_" ];then
    rm "${_config_file}"
else
    true
fi

( 
    cd  "`dirname $0`"

# etc  /etc/server.lan/...
    echo "[INFO] cp config file"     
    source  "scripts/source_config.rc"

##  add user
    echo "[INFO] add group user" 
    groupadd -g ${gid_} ${username_}
    useradd -u ${uid_} -g ${gid_} -m  "${username_}"

# bin  /usr/lib/server.lan/....
    echo "[INFO] cp excute file to   /usr/lib/server.lan" 
    _software_dir="/usr/lib/server.lan"
    if [ ! -e "${_software_dir}" ];then
        mkdir -p "${_software_dir}"
    elif [ -d "${_software_dir}" ];then
        rm -r "${_software_dir}/*"
    else
        echo "[ERR]::${_software_dir}:: is not a directory "
        exit 1
    fi

 
    rm  -r "${_software_dir}/*"
    

    ## cp xxxx /usr/lib/server.lan
    cp -r  cron.d/ "${_software_dir}"
    cp -r  port80/ "${_software_dir}"
    cp -r  services/ "${_software_dir}"



    chmod u+x services/*.sh
    chown ${uid_}:${gid_} /usr/lib/server.lan
    chown -R ${uid_}:${gid_} /usr/lib/server.lan/

# ssl  , https
    function _soft_link {
        rm "$2" || true
        ln -s  "$1"  "$2"
    }
    
    if  [ "x${_ENABLE_HTTPS}" == "xtrue" ] ;then
        bash ./scripts/ssl_https.sh
        _soft_link      "${HOME}/server.latest.key"   "${_software_dir}/port80/server.key"
        _soft_link      "${HOME}/server.latest.crt"   "${_software_dir}/port80/server.crt"
        echo "[INFO] HTTPS enabled"
        cp  "/root/ca.crt"   "${_software_dir}/port80/static/root_ca.crt"
    fi

    echo "[INFO] stop and rm containers   < -f name=_server.lan > "

    docker rm $(docker stop $(docker ps -a  -f name=_server.lan -q) )

# entry
    echo
    echo "[OK] install is done"
    echo 
    echo "[INFO] entries :: ${_software_dir}/{services,cron.d}/....  "
    echo "  [INFO] entrypoint -- >  ${_software_dir}/services/start.sh " 
    echo "  [INFO] cron shell -- >  bash ${_software_dir}/cron.d/backup.sh " 
    echo "  [INFO] other cron shells -- >  bash ${_software_dir}/cron.d/<xxx>.sh "
    

    # 4.1  服务的入口. TODO
    #  /etc/rc.local  或者作用 cron 代替
    ###/etc/rc.local  <---  # start_by_root.sh

    # 4.2 /etc/crontab  <---  information 
    ### add_to_cron " * * * * * ${username_} TODO_command "
    ## "57 3 * * *  root  ${_software_dir}/cron.d/information.root.sh"
    ## "* 4 * * * ${username_} ${_software_dir}/cron.d/borg.backup.sh"
    
)

echo "[OK]  install done"

