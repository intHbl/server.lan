#!/bin/bash


_platform="none"
if uname -m | grep -iE "arm|aarch" > /dev/null;then
    _platform="armhf"
elif  uname -m | grep -iE "amd64|x86_64" > /dev/null;then
    _platform="x86_64"
fi

echo  "${_platform}"
