#!/bin/bash

#
(
    cd "`dirname  $0`"


    GiteaVer=v1.12.2
    
    _flag=""
    function _git_checkout {
        if ! git -C gitea  checkout  ${GiteaVer} ;then
            if [ -e gitea ];then
                rm -r gitea/
            fi
        else
            _flag="OK"
        fi
    }

    function _git_clone {
        if ! [ -e gitea ];then
            git clone https://github.com/go-gitea/gitea.git
        fi
    }

    for((i=0;i<3;i++));do
        _git_checkout
        if [ ! -z "${_flag}" ];then
            # context.go :: X-Frame-Options SAMEORIGIN  --> "ALLOW-FROM url1,url2"
            cp context.go gitea/modules/context/context.go

            break
        fi
        _git_clone
    done
    
)

