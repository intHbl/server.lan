
#!/bin/bash

# https://github.com/go-gitea/gitea/releases
## version  v1.12.2

(
 
    cd "`dirname $0`"
    _file_name="gitea-src-1.12.2.tar.gz"
    _download_file_name="gitea.v1.12.2.OK.tar.gz"

    if [ ! -e "${_download_file_name}" ];then
        for((i=0;i<20;i++));do
            echo "[INFO]::download::$i/20::${_file_name}"
            if wget -c https://github.com/go-gitea/gitea/releases/download/v1.12.2/gitea-src-1.12.2.tar.gz \
            -O "${_file_name}" ;then

                mv  "${_file_name}"  "${_download_file_name}" 
                break
            else
                echo "[Warn]::download err::$i::retry -> $(($i+1))/20"
            fi
        done
    fi

    if [ ! -e "${_download_file_name}" ];then
        exit 1
    fi
    
    exit 0

)