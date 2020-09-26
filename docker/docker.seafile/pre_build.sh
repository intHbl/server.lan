#!/bin/bash


# build image :: baselayer  , if not exits.
(
    _image_name=seafile-v7.0.5-baselayer

    if ! docker image ls | grep -F "inthbl/${seafile-v7.0.5-baselayer}" ;then
        bash ./scripts/build_armhf.sh  "$(dirname "$0")/seafile-v7.0.5-baselayer"
    fi

)