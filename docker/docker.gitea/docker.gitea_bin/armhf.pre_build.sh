#!/bin/bash

# (
#     cd "`dirname $0`"
# )


(
    cd "`dirname $0`"
    cp Dockerfile armhf.Dockerfile.__gen__
    if [ -f ./pre_build.sh ];then
        bash ./pre_build.sh
    fi
)


