#!/bin/bash



# information

echo cpu temperature
for tt in `cat /sys/class/thermal/thermal_zone*/temp` ;do echo $(($tt/1000));done

echo disk information

ls -l /dev/disk/by-label/disk_*
mount | grep '^/dev/sd'

df -h /dev/disk/by-label/disk_dataX
du -sh /mnt/hb.mountpoint/dataX/data.*


df -h /dev/disk/by-label/disk_backupX
sudo du -sh /mnt/hb.mountpoint/backupX/backup.*

