

function TODO {

    echo "[Err] 'TODO' "
    exit 1

}


function has_string {

    string_=$1
    file_=$2

    if grep -F "$string_"  ${file_} \
     && [ "`grep -F "$string_"  ${file_}`" ==  "$string_" ] ;then
        return 0
    else
        return 1
    fi

}

function add_to_cron {
    
    crontab_="/etc/crontab"
    if has_string "$1" ;then
        return
    fi

    {
        echo
        echo "$1"

    } | sudo tee ${crontab_}

}

