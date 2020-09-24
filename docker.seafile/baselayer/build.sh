#!/bin/bash


#
(
    cd `dirname  $0`
    _tagname="inthbl/seafile-v7.0.5-baselayer-armhf"
    _version="v20200922"

    if [  ! -e "seafile-server_7.0.5_stable_pi.tar.gz" ];then
        wget https://github.com/haiwen/seafile-rpi/releases/download/v7.0.5/seafile-server_7.0.5_stable_pi.tar.gz \
            -O seafile-server_7.0.5_stable_pi.tar.gz
    fi


    sudo docker build  -t   ${_tagname}:${_version}   .
    sudo docker tag  ${_tagname}:${_version}  ${_tagname}:latest

    sudo docker push ${_tagname}:${_version}
    sudo docker push ${_tagname}:latest
    #


)