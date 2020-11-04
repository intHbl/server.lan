#!/bin/bash

#
## arg1=dockerfile's dir
## arg2=push  

if [ ! -d "$1" ];then
    echo "[Err] ar1 need directory name, like 'docker.xxxx'"
    exit 1
elif  ! basename "$1" | grep -E "^docker\..+" ;then
    echo "[Err] directory name is must like 'docker.xxxx', xxxx can be any char... "
    exit 1
fi

echo "[INFO]::build args::arg1=path=$1 "
echo "              arg2=test|build=$2 arg3=push?=$3 "
echo "              arg4=platform=$4 "
echo

_dir_dockerfile=$1
_build_flag=$2
_is_push=$3
_platform=$4




function _build_hook {
    # pre|post scripts
    if [ ! -z "$1" ] && [ -f "$1" ];then
        echo "[INFO]::build hook::$1"
        bash "$1" "${_build_flag}" "${_is_push}" "${_platform}"
    fi
}

{
    tmp_="`pwd`"
    cd "$(dirname "`dirname $0`")"
    source "./scripts/source_config.rc"
    cd "${tmp_}"
}

_tag_name=$(basename "${_dir_dockerfile}")
_tag_name="${_tag_name:7}"
_log_file="/tmp/dockerbuild.${_tag_name}-${_platform}"


_tagname_arch="inthbl/${_tag_name}-${_platform}"
# _version="v20200804"
_version="v`date +'%Y%m%d.%H'`"

{
    echo 
    echo "------- start to build ---------------"
    date

    if [ "x${_build_flag}" == "xtest" ];then
        echo "[test]::dockerfile.dir==${_dir_dockerfile}"
        echo "[test]  ::tag(arch)==${_tagname_arch}:${_version}"
        exit 0
    elif [ "x${_build_flag}" != "xbuild" ];then
        echo "[INFO] add flag 'build' (arg2) if want to build"
        exit 0
    fi


    (
        cd "${_dir_dockerfile}"

        ## pre
        if ! _build_hook "./${_platform}.pre_build.sh" ;then
            echo "[Err]::run $(pwd)/${_platform}.pre_build.sh  err"
            exit 1
        fi


        dockerfile="./${_platform}.Dockerfile"
        if [ ! -e "./${_platform}.Dockerfile" ];then
            dockerfile="${_platform}.Dockerfile.__gen__"
            if [ ! -e "${dockerfile}" ];then
                echo "[Warning]::no Dockerfile in $(pwd) for arch==${_platform}"
                exit 0
            fi
        fi
        if ! sudo docker image ls "${_tagname_arch}:${_version}" | grep -F "${_tagname_arch}:${_version}";then
            if ! sudo docker build  \
                --build-arg uid_=${uid_} \
                --build-arg gid_=${gid_} \
                --build-arg username_=${username_} \
                --build-arg GOPROXY=https://goproxy.cn \
                -t  ${_tagname_arch}:${_version} -f "${dockerfile}"  .  
            then
                exit 1
            fi
            sudo docker   tag      ${_tagname_arch}:${_version}  ${_tagname_arch}:latest

        fi

        if [ "x${_is_push}" == "xpush" ];then

            sudo docker push ${_tagname_arch}:${_version}
            sudo docker push ${_tagname_arch}:latest
        else
            echo "
            sudo docker push ${_tagname_arch}:${_version}
            sudo docker push ${_tagname_arch}:latest
            " >> ~/docker.push.sh
        fi
        #
        ## post
        _build_hook "./post_build.sh"
    )
    

} 2>&1 | tee "${_log_file}"

mv "${_log_file}" "${_log_file}.DONE.log"

exit 0
#

