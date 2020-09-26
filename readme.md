
# server.lan

> local domain
[server.lan]("http://server.lan")  


## note : 
those `docker image` are built for arm platform.
not for x86

> TODO :: build for both `arm` and `x86_64`    
> machine_arch = `uname -m`

> docker_container_name = `${name}_server`  
> volume  in host  = `data.${name} `


## config before install.
> vi config.ini


# disks
mount disks ***before install***
> mkdir -p /mnt/hb.mountpoint/{dataX,backupX}  # mountpoint  
> chmod 0777 ...

> /etc/fstab
```shell
LABEL=disk_dataX /mnt/hb.mountpoint/dataX  ext4  defaults,nofail  0  2
LABEL=disk_backupX /mnt/hb.mountpoint/backupX  ext4  defaults,nofail  0  2
## LABEL=disk_downloadX   mntpoint=/mnt/hb.mountpoint/downloadX 
```
```shell
mount -a   ## mount auto  <- fstab
mountpoint /some_dir #check mountpoint or not

_m_point="/mnt/hb.mountpoint/backupX"
sudo mkdir -p ${_m_point}
sudo chown 2000:2000 ${_m_point}
sudo mount  /dev/disk/by-label/disk_backupX  ${_m_point}
sudo ln -s ${_m_point} "`dirname ${_m_point}`/dataX"
```

# service
## seafile , (video==> jellyfin)
> `${dataX}/{data.gitea,data.seafile,data.video,data.aria2,}`
## download
> `${downloadX}/{download.qbittorrent}`

# backup
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



## server.lan:6800  --> aria2
## server.lan:10001 -->video

## qbit ??
#```qbit
#-p 8080:8080 \  web ?
#-p 6881:6881 \
#-p 6881:6881/udp  \
#```
```
