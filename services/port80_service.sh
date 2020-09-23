#!/bin/bash



# port 80/443


## hostname == server.lan --> home page (static source)
## hostname == git.server.lan -->gitea (port 3000)
## seafile
## seafile.server.lan --> (web 8000
## seafile.server.lan/webdav --> (webdav 8080
## seafile.server.lan/seaf --> (file 8082



## server.lan:6800  --> aria2
## server.lan:10001 -->video

## qbit ??
#```qbit
#-p 8080:8080 \  web ?
#-p 6881:6881 \
#-p 6881:6881/udp  \
#```


(

    cd `dirname $0`

    if [ ! -e "port80/http_server" ];then

        container_name='port80_http_server'
        ##
        echo "[info] do copy "
        docker run --rm  \
        -v "$(pwd)/port80":/data  \
        --name=${container_name}  \
        inthbl/port80-armhf


    fi

)


(

    cd "`dirname $0`/port80"

    if [ ! -e "http_server" ];then
        echo "[Err] have no 'http_server'"
        exit 1
    fi


    if [ ! -x "http_server" ];then
        chmod u+x http_server
    fi

    # run as root
    pidfile=/run/http_server.pid
    if [ -e "${pidfile}" ];then
        echo "[info] kill process"
        kill `cat ${pidfile}`
    fi

    ls -l ${pidfile}
    echo 
    
    start-stop-daemon --start --quiet --oknodo \
            --background --chuid 0:0  \
                --make-pidfile  --pidfile \
                ${pidfile} --exec "`pwd`/http_server"

    
    echo -e "\n\n"

    cat ${pidfile}

    ps ax | grep http | grep -v "grep"
)

