#!/bin/bash

#

(
    cd `dirname  $0`

    _tagname="inthbl/mp4server-armhf"
    _version="v20200806"

    sudo docker build  -t   ${_tagname}:${_version}   .
    sudo docker tag  ${_tagname}:${_version}  ${_tagname}:latest

    sudo docker push ${_tagname}:${_version}
    sudo docker push ${_tagname}:latest
    #

)