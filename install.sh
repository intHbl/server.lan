

apt install <TODO borgbackup>
deb install <TODO docker.pkg.deb>
# > https://download.docker.com/linux



# config
docker  json   docker_data --> ${dataX}/docker  #docker daemon config
cat /etc/docker/daemon.json
{
    "data-root":"/mnt/hb.mountpoint/dataX/docker",
    "log-driver": "none",
    "log-opts": {
        "max-size": "10m",
        "max-file": "2"
    }
}

adduser  runner #  2000:2000
/etc/rc.local  <---  start.sh
/etc/crontab  <---  backup , information 

# logs
/tmp/server.lan_<...>.log

# disks
mkdir -p /mnt/hb.mountpoint/{dataX,backupX}  # mountpoint
chmod 0777 ...
```shell
## add to /etc/fstab
LABEL=disk_dataX /mnt/hb.mountpoint/dataX  ext4  defaults,nofail  0  2
LABEL=disk_backupX /mnt/hb.mountpoint/backupX  ext4  defaults,nofail  0  2
##LABEL=disk_downloadX /mnt/hb.mountpoint/downloadX  ext4  defaults,nofail  0  2
```
mount -a   ## mount auto  <- fstab
mountpoint /some_dir #check mountpoint or not


# service
## seafile , (video==> jellyfin)
${dataX}/{data.gitea,data.seafile,data.video,data.aria2,}
## download
${downloadX}/{download.qbittorrent}
##  borgbackup    data --> backup
##  rsync   backup  --> remote_backup








