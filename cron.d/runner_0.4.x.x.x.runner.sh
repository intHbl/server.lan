#!/bin/bash

#  user=runner uid=2000 gid=2000
#  min hour dayOfmonth month week  user  cmd 
#  0  4  * * *    runner  "`pwd`/$0"
function rolling_bar {
    echo  -ne  "\t----------------------------------------------------"
    sleep 0.2
    echo  -ne  "\r\t---------------------------------------<<<<<<<<<<<++"
    sleep  0.2
    echo  -ne  "\r\t---------------------------<<<<<<<<<<<++++++++++++++"
    sleep  0.2
    echo  -ne  "\r\t------------<<<<<<<<<<<+++++++++++++++++++++++++++++"
    sleep  0.2
    echo  -ne  "\r\t<<<<<<<<++++++++++++++++++++++++++++++++++++++++++++"
    sleep  0.2
    echo  -ne  "\r\t++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
    sleep  0.2
}

(
    cd "`dirname $0`"

    function run_sh_script_ {

        # arg1  ==  cmd.sh
        # arg2  ==  info

        if [ -z "$1" ];then
            return 1
        elif ! [ -e "$1" ];then
            return 1
        fi
        echo 
        if [ ! -z "${2}" ];then
            echo "[INFO] $2"
        fi

        echo "[INFO] run script : `pwd`/$1 "
        echo "  >>  >>>    >>>>    >>>>>>>>>>      >>>>>>>>>>>>>     "
        (
            bash  "$1"
        )
        echo " # # # # # # # # # # # # # # # # # # # # # # # # "
        rolling_bar
        
    }
    

    run_sh_script_   "./cmd/log.sh"   "generate information"

    run_sh_script_   "./cmd/backup.sh"  "start backup.sh"
    
)
