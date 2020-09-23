#!/bin/bash

#
(
    cd `dirname  $0`

    

    _tagname="inthbl/gitea-armhf"
    _version="v20200727.1"
    _version="v20200802"
    _version="v20200804"
    _version=v`date +'%Y%m%d'`


    GiteaVer=v1.12.2
    if  [ ! -e gitea ];then
        git clone https://github.com/go-gitea/gitea.git
    fi

    git -C gitea  checkout  ${GiteaVer}


    rm gitea/Dockerfile gitea/dockerfile  2> /dev/null

    # user : id git == 2000
    cp Dockerfile gitea/Dockerfile
    # X-Frame-Options SAMEORIGIN  --> "ALLOW-FROM url1,url2"
    cp context.go gitea/modules/context/context.go


    sudo docker build  -t   ${_tagname}:${_version}   ./gitea/
    sudo docker tag  ${_tagname}:${_version}  ${_tagname}:latest



    sudo docker push ${_tagname}:${_version}
    sudo docker push ${_tagname}:latest

    #


)
