#!/bin/bash

(

    cd "`dirname "$0"`"
    
    cp Dockerfile armhf.Dockerfile.__gen__

    if [  ! -e "seafile-server_7.0.5_stable_pi.tar.gz" ];then
        wget https://github.com/haiwen/seafile-rpi/releases/download/v7.0.5/seafile-server_7.0.5_stable_pi.tar.gz \
            -O seafile-server_7.0.5_stable_pi.tar.gz
    fi

)

