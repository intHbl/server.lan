#!/bin/bash

 
#if [ -z $1 ] || [ x$1 == xhelp ] || [ x$1 == "x-help" ] || [ x$1 == "x--help" ] ; then
#       echo arg1='<user>@<host>:<src_dir>'
#       echo arg2='<dst_dir>'  or  default='/mnt/`basename $1`'
#       exit 0
#fi


function m_(){
        dest_dir=$2
        if [ -z $dest_dir ];then
                dest_dir="/mnt/sshfs/`basename $1`"
        fi

        echo "[INFO] dst=$dest_dir"

        if [ -e $dest_dir ] &&  mountpoint -q $dest_dir ;then
                echo '[E] the dest dir has already been mounted'
                exit 1
        elif [ -d $dest_dir ];then
                true ; # ok
        elif [ ! -e $dest_dir ];then
                sudo mkdir -p "$dest_dir"
        fi

        sudo umount "$dest_dir"

        if ! sudo sshfs -o nonempty,reconnect,allow_other,exec -p22   $1  $dest_dir ;then
                dest_dir="${dest_dir}_"
                if [ ! -e "${dest_dir}" ];then
                        sudo mkdir -p "${dest_dir}"
                else
                    sudo umount "$dest_dir"
                fi
                sudo sshfs -o nonempty,reconnect,allow_other,exec -p22   $1  "$dest_dir"
        fi

}


# m_ $1 $2
m_   "hb@server.lan:/mnt/hb.mountpoint/dataX/data.aria2/download"
