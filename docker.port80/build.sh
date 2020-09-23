#!/bin/bash

#

(
    cd `dirname  $0`

    # platform

    #uname -m
    #if  platform == arm ==>armhf
    #if  platform == x86_64 ==>x86_64

    _tagname="inthbl/port80-armhf"
    _version="v20200804"
    _version="v`date +'%Y%m%d'`"





    sudo docker build  -t   ${_tagname}:${_version}   .
    sudo docker tag  ${_tagname}:${_version}  ${_tagname}:latest



    sudo docker push ${_tagname}:${_version}
    sudo docker push ${_tagname}:latest


)