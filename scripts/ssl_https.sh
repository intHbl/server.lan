#!/bin/bash

set -e

## note:
###  req  subj item's match policy ::  config = /etc/ssl/openssl.conf
####config path :  /etc/ssl/openssl.cnf   ;  /etc/pki/tls/openssl.cnf
 
## ca.key,  ca.crt   
## server.key,   server.csr , server.crt

##############################################################
################################################################

if ! which openssl;then
    apt install -y openssl
fi



if ! which openssl; then
    echo "[Err] openssl install err"
    exit 1 
fi

(
    cd "`dirname "$0"`"
    source ./scripts/source_config.rc || true
)


Country_="XX"
State_="State"
City_="City"
Orgnization_="OrgY"
OrgUnit_="devG"

if [ -z "${_EMAIL}" ];then
    _EMAIL="TODO@server.lan"
fi
_subj="/C=${Country_}/ST=${State_}/L=${City_}/O=${Orgnization_}/OU=${OrgUnit_}/CN=server.lan/emailAddress=${_EMAIL}"



(
    cd ~

    # < ca side >
    ##  ca.key,  ca.crt   
    if  [ -e "ca.crt" ]
    then
        echo  "[INFO] ca.crt is exist"
    else
        echo "[INFO] gen ca.crt"
            openssl req -newkey rsa:2048 -nodes -keyout ca.key   -x509 -days 36500 -out ca.crt \
            -subj "${_subj}"
    fi
    echo [INFO] done

    if [ ! -e demoCA/serial ]
    then
            mkdir -p demoCA/certs
            mkdir demoCA/newcerts
            mkdir demoCA/private
            mkdir demoCA/crl
            touch  demoCA/index.txt
            echo 01 >  demoCA/serial
    fi


    ###############################################
    # < server side >
    
    _NUM=`cat demoCA/serial`

    echo  [INFO] gen server.key
    openssl genrsa -out server.${_NUM}.key 2048
    echo "----server.key done----------"
    

    echo  [INFO]gen .csr

    ## config path :  /etc/ssl/openssl.cnf   ;  /etc/pki/tls/openssl.cnf
    opensslcnf="/etc/ssl/openssl.cnf"
    ## SAN(Subject Alternative Name) : `multi domain`
    configstring="[SAN]\nsubjectAltName=DNS:*.server.lan,DNS:*.git.lan,DNS:server.lan,DNS:git.lan"

    openssl req -new \
        -key server.${_NUM}.key \
        -subj "${_subj}"\
        -reqexts SAN \
        -config <(cat $opensslcnf \
            <(printf  $configstring)) \
        -out server.${_NUM}.csr

    echo -----------.csr done --------------

    ## CA.config.policy_match (-subj="/C=x/ST=y    /O=z"  == CA   )
    echo ----------------------
    ###############################################


    # < ca sied >
    echo  [INFO] gen .crt

    openssl ca -in server.${_NUM}.csr \
            -keyfile ca.key \
        -cert ca.crt \
        -extensions SAN \
        -config <(cat $opensslcnf \
            <(printf $configstring)) \
        -out server.${_NUM}.crt

    echo  "[INFO] make soft link ::  .latest --> .${_NUM} "
    ln -s server.${_NUM}.key    server.latest.key
    ln -s server.${_NUM}.crt    server.latest.crt

    echo [INFO] ssl :: all is done
    exit 0


)
