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


# root
if  [ "`whoami`" != "root" ];then
    echo "[Err] please run as root ,current user = `whoami`"
    exit 1
fi


# apt install

function _check_and_apt_install {
    if [ -z "$1" ];then
        return
    fi
    if ! which $1;then
        apt install -y $1
    fi
}

_check_and_apt_install borgbackup
_check_and_apt_install rsync



# 1 /etc/config.ini
# 1.2  useradd
# 2 /usr/local/server.lan
# 3 service start entry

_config_file="/etc/server.lan/config.ini"
read -p "  delete config file  ${_config_file} ?(y/N)"  _tmp
if [ "y_" == "${_tmp}_" ] || [ "Y_" == "${_tmp}_" ];then
    rm "${_config_file}"
# etc  /etc/server.lan/...
    echo "[INFO] cp 'config.ini' file  ->  ${_config_file} "   
else
    true
fi

( 
    cd  "`dirname $0`"
    source  "scripts/source_config.rc"

##  add user
    echo "[INFO] add group user" 
    groupadd -g ${gid_} ${username_}
    useradd -u ${uid_} -g ${gid_} -m  "${username_}"
    usermod  -G docker ${username_}

# bin  /usr/local/server.lan/....
    echo "[INFO] cp excute file to   /usr/local/server.lan" 
    _software_dir="/usr/local/server.lan"
    

    if [ -d "${_software_dir}" ];then
        rm -r "${_software_dir}"
    elif [ -f "${_software_dir}" ];then
        echo "[ERR]::${_software_dir}:: is not a directory "
        exit 1
    fi

    if [ ! -e "${_software_dir}" ];then
        mkdir -p "${_software_dir}"
    fi
 
    rm  -r "${_software_dir}/*"
    

    ## cp xxxx /usr/local/server.lan
    cp -r  cron.d/ "${_software_dir}"
    cp -r  port80/ "${_software_dir}"
    cp -r  services/ "${_software_dir}"



    chmod u+x services/*.sh
    chown ${uid_}:${gid_} /usr/local/server.lan
    chown -R ${uid_}:${gid_} /usr/local/server.lan/

# ssl  , https
    function _soft_link {
        rm "$2" &>/dev/null || true
        ln -s  "$1"  "$2"
    }
    
    if  [ "x${_ENABLE_HTTPS}" == "xtrue" ] ;then
        echo
        echo 
        echo " ############## "
        bash ./scripts/ssl_https.sh
        _soft_link      "${HOME}/server.latest.key"   "${_software_dir}/port80/server.key"
        _soft_link      "${HOME}/server.latest.crt"   "${_software_dir}/port80/server.crt"
        echo "[INFO] HTTPS enabled"
        cp  "/root/ca.crt"   "${_software_dir}/port80/static/root_ca.crt"
        echo 
        echo " ###############  ## "
        echo 
    fi

    echo "[INFO] stop and rm containers   < -f name=_server.lan > "

    docker rm $(docker stop $(docker ps -a  -f name=_server.lan -q) )

# entry
    echo
    echo "[OK] install is done"
    echo 
    echo "[INFO] entries :: ${_software_dir}/{services,cron.d}/....  "
    echo "  [INFO] entrypoint -- >  ${_software_dir}/services/start.sh " 
    #echo "  [INFO] cron shell -- > 0  4 * * * ${username_}  bash ${_software_dir}/cron.d/backup.sh " 
    #echo "  [INFO] cron shell -- > 55 3 * * * ${username_}  bash ${_software_dir}/cron.d/log.sh " 
    echo "  [INFO] cron shells -- >  # 0  4 * * * ${username_}  bash ${_software_dir}/cron.d/<xxx>.sh "
    echo "  "
    for sh_i in ${_software_dir}/cron.d/*.sh;do
        echo "                      #  m h d m w ${username_} bash  ${sh_i} "
    done
    echo " <<<<<  <<<<<<<  <<<<<<< "

    echo
    echo "[INFO] DDNS ::  #ip#     server.lan *.server.lan git.lan *.git.lan "
    echo "        <<<ip>>>        server.lan *.server.lan git.lan *.git.lan"
    echo "        <<<ip>>>        server.lan"
    echo "        <<<ip>>>        git.lan    seafile.server.lan    file.server.lan"
    echo "        <<<ip>>>        bitwarden.server.lan"
    echo "        <<<ip>>>        down.server.lan    qbit.server.lan"
    echo "        <<<ip>>>        statics.server.lan"
    
    

    # 4.1  服务的入口. TODO
    #  /etc/rc.local  或者作用 cron 代替
    ###/etc/rc.local  <---  # start_by_root.sh

    # 4.2 /etc/crontab  <---  information 
    ### add_to_cron " * * * * * ${username_} TODO_command "
    ## "57 3 * * *  root  ${_software_dir}/cron.d/information.root.sh"
    ## "* 4 * * * ${username_} ${_software_dir}/cron.d/borg.backup.sh"
    
)

echo "[OK]  install done"

