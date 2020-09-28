
# server.lan

> local domain
[server.lan]("http://server.lan")  

```
    docker  -->  [build] --> [push] ---> hub.docker.com


                            ___USER_client___
                                    ↑↑      \\
                                    ||       \\
                               _____||_____   \\
                      ---->   [   port80   ]   ||
                     /         \_____ ____/    || 
                    /                \\        ||
    services/start.sh  --------> {_docker_container_}
                                            ||
                                            ||
                                        |---  ---|    
                                        |  DATA  |
                                        |________|
                                            ||
                                            || cron.backup(borgbackup)
                                            ↓↓
                                    [ ♦ borg rep ♦ ] --
                                                        \
                                                          ---rsyc----> [remote Disk]

```

## note : 
those `docker image` are built for arm platform.
not for x86

> TODO :: build for both `arm` and `x86_64`    
> machine_arch = `uname -m`

> docker_container_name = `${name}_server`  
> volume  in host  = `data.${name} `


## config ,build,install 
> config before install.
```shell
 vi config.ini
```

> build , install
```shell
install.pre.sh
build.sh
install.sh
```

# service
## seafile , (video==> jellyfin)
> `${base_dir_data}/{data.gitea,data.seafile,data.video,data.aria2,}`
## download
> `${base_dir_download}/{download.qbittorrent}`

## backup
>  borgbackup   -->    backup  
>  rsync        -->    remote_backup



# reverse proxy
> port 80/443

```shell
## hostname == server.lan --> home page (static source)
## hostname == git.server.lan -->gitea (port 3000)
## seafile
## seafile.server.lan --> (web 8000
## seafile.server.lan/webdav --> (webdav 8080
## seafile.server.lan/seaf --> (file 8082

## 

## server.lan:6800  --> aria2
## server.lan:10001 -->video


## server.lan:18080
## qbit ??
#```qbit
#-p 8080:8080 \  web ?
#-p 6881:6881 \
#-p 6881:6881/udp  \
#```
```
