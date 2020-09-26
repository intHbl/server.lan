#!/bin/bash

#
(
    cd `dirname  $0`


    GiteaVer=v1.12.2
    if  [ ! -e gitea ];then
        git clone https://github.com/go-gitea/gitea.git
    fi

    git -C gitea  checkout  ${GiteaVer}


    # X-Frame-Options SAMEORIGIN  --> "ALLOW-FROM url1,url2"
    cp context.go gitea/modules/context/context.go


)
