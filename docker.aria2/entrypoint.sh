#!/bin/sh

# entrypoint
echo [starting] :: `date` :: aria2

# conf file
conf="/data/.aria2.d/aria2.conf"
if [ ! -e `dirname ${conf}` ];then
    mkdir -p `dirname ${conf}`
fi
if [ -e "${conf}" ];then
    cp ${conf} "/etc/aria2.conf"
    mv ${conf} "${conf}.template"
fi
if [ ! -e "${conf}.template" ];then
    cp "/etc/aria2.conf"  "${conf}.template"
fi

if [ ! -e "/tmp/aria2.session" ];then
    touch '/tmp/aria2.session'
fi

# run 
aria2c --conf-path=/etc/aria2.conf  > /tmp/server.lan_aria2c.log &
/file_server  '/data'  > /tmp/server.lan_fileServer.log



