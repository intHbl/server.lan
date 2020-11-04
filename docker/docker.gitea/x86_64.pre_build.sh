#!/bin/bash


# build image :: baselayer  , if not exits.        

_build_flag="$1"
_is_push="$2"
_platform="$3"

(
    cd "$(dirname "$0")"

    bash ./pre_build.sh  "${_build_flag}"  "${_is_push}"  "${_platform}"

)
