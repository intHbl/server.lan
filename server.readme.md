# graph
router : DNS/proxy ; vpn/wireguard

docker  -->  [build] --> [push] ---> hub.docker.com


services/start.sh   ----->  {docker container}
				     ||
				     ||
				    data
				     ||
				     || cron.backup(borgbackup)
                     ||
                     ↓↓
                [ ♦ borg rep ♦ ] ----rsyc----> [remote Disk]

				

# user
```shell

name = runner
uid:gid = 2000:2000
`http port 80` == root

```


# server data directory
## mount by label
> /mnt/hb.mountponit
/etc/fstab 
/etc/fstab 
/etc/fstab 
disk 
	data
	download
	backup (for data)

# start shell
/etc/rc.local
```shell
# start.sh
{

	date
	mount | grep "^/dev"
	ls -alFh /mnt/hb.mountpoint
	/home/hb/server.lan/services/start.sh &

} > /tmp/server.lan_serviceStarting.log


```

# backup shell
```shell
# /etc/crontab
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

#....

0  4    * * *  runner  /mnt/hb.mountpoint/backupX/.start.backup.sh

```

# logs

/tmp/server.lan_*.log