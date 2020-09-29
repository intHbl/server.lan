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

( 
    cd  "`dirname $0`"

    # etc  /etc/server.lan/...     
    source  "scripts/source_config.rc"

    ##  add user
    useradd -u ${uid_} -g ${gid_} -m  "${username_}"

    # bin  /usr/lib/server.lan/....
 
    _software_dir="/usr/lib/server.lan"
    if [ ! -e "${_software_dir}" ];then
        mkdir -p "${_software_dir}"
    fi [ ! -d "${_software_dir}" ];then
        echo "[ERR]::${_software_dir}:: is not a directory "
        exit 1
    fi
    # cp xxxx /usr/lib/server.lan
    cp -r  cron.d/ "${_software_dir}"
    cp -r  port80/ "${_software_dir}"
    cp -r  services/ "${_software_dir}"

    chmod u+x services/*.sh
    chown ${uid_}:${gid_} /usr/lib/server.lan
    chown -R ${uid_}:${gid_} /usr/lib/server.lan/

    # 4.1  服务的入口. TODO
    #  /etc/rc.local  或者作用 cron 代替
    ###/etc/rc.local  <---  # start_by_root.sh

    # 4.2 /etc/crontab  <---  information 
    ### add_to_cron " * * * * * ${username_} TODO_command "
    ## "57 3 * * *  root  ${_software_dir}/cron.d/information.root.sh"
    ## "* 4 * * * ${username_} ${_software_dir}/cron.d/borg.backup.sh"
    
)

