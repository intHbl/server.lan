#!/bin/bash

#

server_name=$(basename "$1")
server_name="${server_name:3:-11}"

config_file="./config.ini"


(
    cd `dirname  $0`

    _tagname="inthbl/aria2-armhf"
    _version="v20200804"
    _version="v`date +'%Y%m%d'`"

    sudo docker build  -t   ${_tagname}:${_version}   .
    sudo docker tag  ${_tagname}:${_version}  ${_tagname}:latest

    sudo docker push ${_tagname}:${_version}
    sudo docker push ${_tagname}:latest
#

)

