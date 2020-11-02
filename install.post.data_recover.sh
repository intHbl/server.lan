#!/bin/bash


(
    cd  "`dirname $0`"

  # etc  /etc/server.lan/...
    echo "[INFO] cp config file"     

    config_file="scripts/source_config.rc"
    if [ ! -e "${config_file}" ];then
        config_file="/etc/server.lan/config.ini"
    fi
    source  "${config_file}"

    # base_dir_data_mnt=/mnt/server.lan/dataX
    # base_dir_data=/var/server.lan/data
    # # backup
    # base_dir_backup_mnt=/mnt/server.lan/backupX
    # base_dir_backup=/var/server.lan/backup

    if ! mountpoint  "${base_dir_data_mnt}";then
      echo "[Err] please mount before this operation, dir=${base_dir_data_mnt}"
      exit 1
    fi

    target_dir="${base_dir_data_mnt}/xxxx"
    if [ ! -e "${target_dir}" ];then
        true
    elif [ -f "${target_dir}"  ];then
      echo "[Err] is a file , need an empty directory"
      exit 1
    elif ! [ -z "`ls -A "${target_dir}" `" ];then
      echo "[Err]  need an empty directory, dir=${target_dir} "
      exit 1
    fi

    # stop service if running
    if [ -z $1 ];then
      ls ${base_dir_backup_mnt}/backup.* | grep -E  "backup\..*"
      exit 0
    fi


    (
      repo_path_="${base_dir_backup_mnt}/backup.$1"
      tag_="$2"

      export BORG_PASSPHRASE=mima123456
      if [ -z "$2" ];then
        borg list "${repo_path_}"
      fi

      
      cd /
      borg extract  -p  "${repo_path_}::${tag_}"
      unset BORG_PASSPHRASE
    )
    # start service


)