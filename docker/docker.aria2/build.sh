#!/bin/bash

#

(
    cd `dirname  $0`

_tagname="inthbl/aria2-armhf"
_version="v20200727.1"
_version="v20200802"
_version="v20200804"

sudo docker build  -t   ${_tagname}:${_version}   .
sudo docker tag  ${_tagname}:${_version}  ${_tagname}:latest

sudo docker push ${_tagname}:${_version}
sudo docker push ${_tagname}:latest
#

)

