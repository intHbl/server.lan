# readme

## 0.account  user/passwd
```shell
 user   = admin@admin.lan
 passwd = admin
```

## 1.base layer
### - 主程序文件夹
```
/seafile/seafile-server-7.0.5/
```


###  - 初始数据包
```
/seafile.init_data.2.1.tar.gz
######
/data/
/data/ccnet
/data/conf/
/data/seafile-data/
/data/seahub-data
/data/seahub.db
```


## 2.安装之后 
```
/seafile/
/seafile/ccnet/ -> /data/ccnet/
/seafile/conf -> /data/conf/
/seafile/seafile-data/ -> /data/seafile-data/
/seafile/seahub-data/ -> /data/seahub-data/
/seafile/seahub.db -> /data/seahub.db
/seafile/logs/
/seafile/pids/
/seafile/seafile-server-latest/ -> seafile-server-7.0.5/
```


## 3.其他
/etc/sources.list
```shell
# armhf
deb http://mirrors.ustc.edu.cn/ubuntu-ports/ xenial main multiverse restricted universe
deb http://mirrors.ustc.edu.cn/ubuntu-ports/ xenial-backports main multiverse restricted universe
deb http://mirrors.ustc.edu.cn/ubuntu-ports/ xenial-proposed main multiverse restricted universe
deb http://mirrors.ustc.edu.cn/ubuntu-ports/ xenial-security main multiverse restricted universe
```
```shell
# /etc/apt/sources.list
#   deb  [arch]<url>  <`lsb_release -m`>            main  restricted universe multiverse
#   deb  [arch]<url>  <`lsb_release -m`>-security   main restricted universe multiverse
#   deb  [arch]<url>  <`lsb_release -m`>-updates    main restricted universe multiverse
#   deb  [arch]<url>  <`lsb_release -m`>-proposed   main restricted universe multiverse
#   deb  [arch]<url>  <`lsb_release -m`>-backports  main restricted universe multiverse

## url  http://mirrors.tuna.tsinghua.edu.cn/ubuntu/
## url  http://mirrors.aliyun.com/ubuntu/

# x86
#deb http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse
#deb http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse
#deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse
#deb http://mirrors.aliyun.com/ubuntu/ xenial-proposed main restricted universe multiverse
#deb http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse

# armhf
deb http://mirrors.ustc.edu.cn/ubuntu-ports/ xenial main multiverse restricted universe
deb http://mirrors.ustc.edu.cn/ubuntu-ports/ xenial-backports main multiverse restricted universe
deb http://mirrors.ustc.edu.cn/ubuntu-ports/ xenial-proposed main multiverse restricted universe
deb http://mirrors.ustc.edu.cn/ubuntu-ports/ xenial-security main multiverse restricted universe
#deb http://mirrors.ustc.edu.cn/ubuntu-ports/ xenial-updates main multiverse restricted universe
#deb-src http://mirrors.ustc.edu.cn/ubuntu-ports/ xenial main multiverse restricted universe
#deb-src http://mirrors.ustc.edu.cn/ubuntu-ports/ xenial-backports main multiverse restricted universe
#deb-src http://mirrors.ustc.edu.cn/ubuntu-ports/ xenial-proposed main multiverse restricted universe
#deb-src http://mirrors.ustc.edu.cn/ubuntu-ports/ xenial-security main multiverse restricted universe
#deb-src http://mirrors.ustc.edu.cn/ubuntu-ports/ xenial-updates main multiverse restricted univers

```