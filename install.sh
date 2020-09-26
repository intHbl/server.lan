#!/bin/bash



# before those ,  diskes are mounted (or soft link had made).




config_file="/etc/server.lan/config.ini"
( 
    cd  `dirname $0`
    source scripts/function.sh

    if [ ! -e `dirname "${config_file}"` ];then
        sudo mkdir -p `dirname "${config_file}"`
    fi
    sudo cp config.ini  "${config_file}"

    source  "${config_file}"

    # 1. add user
    sudo useradd -u ${uid_} -g ${gid_} -m  "${username_}"

    # 2. install docker 
    ## 2.1 download
    TODO
    ## 2.2 install
    sudo dpkg -i  containerd.io_*.deb  
    sudo dpkg -i  docker-ce-cli_*.deb  
    sudo dpkg -i  docker-ce_*.deb 

    # 3. docker config ; turn off  docker log.
    cat << EOF | sudo tee /etc/docker/daemon.json   > /dev/null
{
    "data-root":"${base_dir_data}/docker",
    "log-driver": "none",
    "log-opts": {
        "max-size": "10m",
        "max-file": "2"
    }
}
EOF 
    
    cat /etc/docker/daemon.json

    sudo service docker restart

    # 4.1 /etc/rc.local  或者作用 cron 代替
    /etc/rc.local  <---  start.sh
    # 4.2 /etc/crontab  <---  information 
    add_to_cron " * * * * * ${username_} TODO_command "


)







