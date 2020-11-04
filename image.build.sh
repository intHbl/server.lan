#!/bin/bash


function print_help_menu_ {

    echo "Usage: ./build.sh  --[arg1]  --[arg2] "
    echo "    arg1= --test | --build | --build=<xxx>   ; xxx==docker/docker.xxxx"
    echo "          --help | -h "

    echo "    arg2(optional)= --push | '' "
    echo 
    echo "    if  (arg1 == build && arg2 != push);then "
    echo "       'auto generated docker push shell'  >>  ~/docker.push.sh  "
    echo "                             ${HOME}/docker.push.sh ;   /root/docker.push.sh "
    echo "    fi "
    echo 
    (
        echo "Docker:"
        cd "`dirname "$0"`"
        ls docker | grep -E "docker\..*"
        ls docker/docker.*/docker.*/.. | grep -E "docker\..*"
    )
    exit 0

}

function arg_parse_ {
    if [ "x${1}" == "x" ];then
        return
    fi

    echo parse $1
    case $1 in
    "--build" )
        _build_flag="build"
        ;;
    "--help"|"-h" )
        print_help_menu_
        ;;
    "--push" )
        _is_push="push"
        ;;
    "--build="*)
        if [ "xx${1:0:8}" == "xx--build=" ];then
            _build_flag="build"
            _build_want_=${1:8}
        fi
    esac

}

_build_flag="test"
_is_push=""



arg_parse_ "$1"
arg_parse_ "$2"


echo "[INFO] want  build :>>  ${_build_want_}  <<:  (if null --> build all)"
echo "[INFO] push or not :>>  ${_is_push}  <<:  (default=not)"
echo

function pppp_ {
    for((i=1;i<=$1;i++));do
        echo -n -e "\r[INFO] press CTRL+C to break  $i/$1"
        sleep 1
    done
    echo 
}
# wait for 10 sec if need cancel 
if [ "x${_build_flag}" != "xtest" ];then
    pppp_  10
fi
echo 


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
    ## docker.*
    for _docker_path in  docker/docker.*  ;do
        if [ ! -d "${_docker_path}" ];then
            continue
        fi

        if  [ -z "${_build_want_}" ] ;then
            true
        elif  [ "${_docker_path}" == "docker/docker.${_build_want_}" ];then
            true
        else 
            continue
        fi

        echo "[INFO] build image for ${_platform} :: ${_docker_path}"
        bash ./scripts/build_dockerimage.sh "${_docker_path}" "${_build_flag}" "${_is_push}" "${_platform}"  &
        sleep 2
    done
)
