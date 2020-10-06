#!/bin/bash


## email for server side


_email=""
_secret=""


function addTOGitea {
    $1
    $2
    "${_email}"  "${_secret}"
}


function addTOSeafile {
    $1
    $2
    "${_email}"  "${_secret}"
}




# config

echo "[INFO] input your Email and secret"
read -p "Email address  : " _email
read -s -p "Key or Passwd or Secret_code: " _secret


## seafile
echo ${_email}
echo ${_secret}
TODO
exit 1

addTOGitea 
addTOSeafile 


# then restart container
sudo docker restart gitea_server.lan
sudo docker restart seafile_server.lan


