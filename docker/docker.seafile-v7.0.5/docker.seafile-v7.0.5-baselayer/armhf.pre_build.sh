#!/bin/bash

(

    cd "`dirname "$0"`"
    
    cp Dockerfile armhf.Dockerfile.__gen__
    
    _download_file="seafile-server_7.0.5_stable_pi.tar.gz"
    _download_url="https://github.com/haiwen/seafile-rpi/releases/download/v7.0.5/seafile-server_7.0.5_stable_pi.tar.gz"

    if [ ! -s "${_download_file}" ];then
        test -e "${_download_file}"  && rm "${_download_file}" 
        wget  "${_download_url}"  -O "${_download_file}"
    fi

    if [ ! -s "${_download_file}" ];then
        test -e "${_download_file}"  && rm "${_download_file}"
        exit 1
    fi

)

