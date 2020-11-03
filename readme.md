
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
those `docker image` are built for those platform:  
    arm (armhf, arm64)
    x86_64


> machine_arch = `uname -m` ; `docker version | grep -i arch`

> docker_container_name = `${name}_server.lan`  
> docker_volume    = `${disk_data_mountpoint}/data.${name}:/data `

.   
.   
.   

## config ,build, install 

> config :: `cp config.ini.template config.ini`  -> edit config.ini 
> install   
> > install.pre.sh :: run install.pre.sh -> edit /etc/fstab ; e2label /dev/sdX  disk_<label>X   
> > -                     image.pull ; _(optional : image.build)_    
> > install.sh ::  run install.sh   ->  
> > -                (data backup; log)  : edit /etc/crontab ;   
> > -                (entry: start.sh )  : edit /etc/rc.local    
> > install.post :: after services started ->  run install.post.*.sh -> reboot  
> > 


```
> uninstall `uninstall.sh`  
> reinstall `uninstall.sh` -> ` (pre) -> install.sh [ -> post]`

.   
.   
.   

# service
## seafile , (video==> jellyfin)
> `${base_dir_data}/data.{gitea,seafile,video,aria2}`
## download
> `${base_dir_download}/download.{qbittorrent,}`

## backup
>  borgbackup   -->    backup  
>  rsync        -->    remote_backup


.   
.   
.   

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
