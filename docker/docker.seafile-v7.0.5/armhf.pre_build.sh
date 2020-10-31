#!/bin/bash


# build image :: baselayer  , if not exits.
(
    cd "$(dirname "$0")"

    _image_name="seafile-v7.0.5-baselayer"

    _dir_dockerfile="$(dirname "$0")/docker.${_image_name}"
    _build_flag="$1"
    _is_push="$2"


    if ! docker image ls | grep -F "inthbl/${_image_name}" ;then
        # ./server.lan/docker/<-->
        if ! bash ../../scripts/build_dockerimage.sh  "${_dir_dockerfile}" "${_build_flag}"  "${_is_push}" "armhf" ;then
            exit 1
        fi
    fi

    exit 0
)
