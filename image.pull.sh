#!/bin/bash


function print_help_menu {

    echo "./pull  arg1"
    echo "     arg1 = <imagename|''> , '' == pull all images for running server.lan "
    echo " "
}


if [ "x$1" == "x--help" ] || [ "x$1" == "x-h" ]
    print_help_menu
    exit 1
fi

_image_want_=$1


(
    cd `dirname  $0`
    
    _platform="`bash ./scripts/platform.sh`"

    echo "[INFO] platform, arch == ${_platform} "

    dockerhub_username_="`basename ${__dockerhub__}`"

    # ${_platform}: armhf , x86_64 | test , test= just echo information,but do not real build.
    # if docker version  | grep -i arch | grep -F "arm" || [ "${_build_flag}" == "test" ];then
    ## docker.*

    if  [ ! -z "${_image_want_}" ] ;then
        image_="${_image_want_}-${_platform}"
        docker pull "${dockerhub_username_}/${image_}"
        
        sleep 1
        exit 0
    fi

    for _docker_path in  docker/docker.*  ;do
        if [ ! -d "${_docker_path}" ];then
            continue
        fi

        tmp_="$(basename ${_docker_path})"
        tmp_="${tmp_:7}"
        image_="${tmp_}-${_platform}"
        docker pull "${dockerhub_username_}/${image_}"

        sleep 1
    done
)
