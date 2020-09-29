#!/bin/bash

#
(
    cd `dirname  $0`


    GiteaVer=v1.12.2
    if [ -e gitea ];then
        git -C gitea  checkout  ${GiteaVer}
    else
        if ! git clone https://github.com/go-gitea/gitea.git;then
            rm -r gitea
            echo "[Err]::$0::git clone gitea err"
            exit 1
        fi
        git -C gitea  checkout  ${GiteaVer}
    fi

    git -C gitea  checkout  ${GiteaVer}


    # X-Frame-Options SAMEORIGIN  --> "ALLOW-FROM url1,url2"
    cp context.go gitea/modules/context/context.go


)
