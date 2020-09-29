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
  
    if uname -m | grep -F "arm" || [ "${_build_flag}" == "test" ];then
        for _dockerfile in docker.* docker/docker.*  ;do
            if [ ! -e "${_dockerfile}" ];then
                continue
            fi

            echo "[INFO] build armhf :: ${_dockerfile}"
            bash ./scripts/build_armhf.sh ${_dockerfile} ${_build_flag} ${_is_push} &
        done
    fi

    if uname -m | grep -F "x86_64" ||  [ "${_build_flag}" == "test" ];then
        for _dockerfile in docker.* docker/docker.*  ;do
            #TODO
            echo "x86_64"
            continue
            bash ./scripts/build_x86_64.sh
        done
    fi

)

