#!/bin/bash



_build_flag=$1
_is_push=$2
if [ -z "$1"  ] || [ "--help" == "-$1" ] || [ "-h" == "$1" ];then
    echo "Usage: ./build.sh  [arg1]  [arg2] "
    echo "    arg1=build|test|help|h"
    echo "    arg2=''|push"
    echo 
    echo "    if  (arg1 == build && arg2 != push);then "
    echo "       'auto generated docker push shell'  >>  ~/docker.push.sh  "
    echo "    fi "
    echo 
    exit 0
fi


# arg1=build|test|help
# arg2=push
# auto generated docker push shell if not  (arg2 != push)
date > ~/docker.push.sh

# build arg :: username_ uid_ gid_


(
    cd `dirname  $0`
    
    _platform="`bash ./scripts/platform.sh`"

    # ${_platform}: armhf , x86_64 | test , test= just echo information,but do not real build.
    # if docker version  | grep -i arch | grep -F "arm" || [ "${_build_flag}" == "test" ];then
    for _docker_path in docker.* docker/docker.*  ;do
        if [ ! -d "${_docker_path}" ];then
            continue
        fi

        echo "[INFO] build image for ${_platform} :: ${_docker_path}"
        bash ./scripts/build_dockerimage.sh "${_docker_path}" "${_build_flag}" "${_is_push}" "${_platform}"  &
        sleep 2
    done
)
