#!/bin/bash

#
## arg1=dockerfile's dir
## arg2=push  

if [ ! -d "$1" ];then
    echo "[Err] ar1 need directory name, like 'docker.xxxx'"
    exit 1
fi

_dir_dockerfile=$1
_build_flag=$2
_is_push=$3


config_file="config.ini"
if [ ! -e "${config_file}" ];then
    config_file="$(dirname $0)/../${config_file}"
fi
source "${config_file}"


function _build_hook {

    if [ ! -z "$1" ] && [ -f "$1" ];then
        echo "[INFO]::build hook::$1"
        bash "$1"
    fi
}


_tag_name=$(basename "$1")
_tag_name="${_tag_name:7}"
_tagname="inthbl/${_tag_name}-armhf"
# _version="v20200804"
_version="v`date +'%Y%m%d.%H'`"



if [ "x${_build_flag}" == "xtest" ];then
    echo "[test]::dockerfile.dir==${_dir_dockerfile}"
    echo "[test]  ::tag==${_tagname}:${_version}"
    exit 0
elif [ "x${_build_flag}" != "xbuild" ];then
    exit 0
fi


## pre
_build_hook "${_dir_dockerfile}/pre_build.sh"


sudo docker build  \
    --build-arg uid_=${uid_} \
    --build-arg gid_=${gid_} \
    --build-arg username_=${username_} \
    -t  ${_tagname}:${_version}  "${_dir_dockerfile}"

sudo docker   tag      ${_tagname}:${_version}  ${_tagname}:latest

if [ "x${_is_push}" == "xpush" ];then
    sudo docker push ${_tagname}:${_version}
    sudo docker push ${_tagname}:latest
else
    echo "
    sudo docker push ${_tagname}:${_version}
    sudo docker push ${_tagname}:latest
    " >> ~/docker.push.sh
fi
#
## post
_build_hook "${_dir_dockerfile}/post_build.sh"






#

