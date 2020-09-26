#!/bin/bash


#
(
    cd `dirname  $0`
    _tagname="inthbl/seafile-v7.0.5-armhf"
    _version="v20200726"
    _version="v20200801"
    _version="v20200804"
    _version="v20200804.1"

    sudo docker build  -t   ${_tagname}:${_version}   .
    sudo docker tag  ${_tagname}:${_version}  ${_tagname}:latest

    sudo docker push ${_tagname}:${_version}
    sudo docker push ${_tagname}:latest
    #


)