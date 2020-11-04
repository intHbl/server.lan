#!/bin/bash


# build image :: baselayer  , if not exits.        

_build_flag="$1"
_is_push="$2"
_platform="$3"

if [ -z "${_platform}" ];then
    echo "[Err] arch|platform is not set"
    exit 1
fi

(
    cd "$(dirname "$0")"

    function build_image_y {

        _image_name="$1"
        _dir_dockerfile="$(pwd)/docker.${_image_name}"
        # docker/docker.xxxx/docker.yyyy

        if ! docker image ls "inthbl/${_image_name}-${_platform}:latest" | grep -F "inthbl/${_image_name}-${_platform}" ;then
            # ./server.lan/docker/<-->
            echo "[INFO] build image : ${_image_name}-${_platform} "
            if ! bash ../../scripts/build_dockerimage.sh  "${_dir_dockerfile}" "${_build_flag}"  "${_is_push}"  "${_platform}" ;then
                return 1
            fi
            echo "[INFO] DONE :: build image : ${_image_name}-${_platform} "
        fi
        return 0
    }

    
    build_image_y   "seafile-v7.0.5-baselayer" 

)

