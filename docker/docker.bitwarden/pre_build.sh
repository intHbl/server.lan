#!/bin/bash


for((i=0;i<3;i++));do
    if docker pull bitwardenrs/server ;then
        exit 0;
    else
        echo "[Warn]::retry::$(($i+1))/2"
    fi
done

exit 1

