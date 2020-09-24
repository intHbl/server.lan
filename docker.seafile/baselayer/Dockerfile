

FROM ubuntu:xenial


## installed pre-requirement and  seafile program.

LABEL  seafileVersion="7.0.5" 



ADD sources.list  /etc/apt/
ADD seafile-server_7.0.5_stable_pi.tar.gz /seafile

# python2.7
#  libselinux1:armhf  libssl1.0.0:armhf 可能已经存在了
RUN ln -s  /seafile/seafile-server-7.0.5 /seafile/seafile-server-latest  \
  && dpkg --add-architecture armhf \
  && apt update \
  && apt install -y libselinux1:armhf  libssl1.0.0:armhf \
  && apt install -y  sqlite3  python2.7 \
        python-setuptools  python-pip \
        python-pil python-ldap python-urllib3  python-simplejson \
  && pip install certifi idna  \
  && rm -r ~/.cache/pip \
  && apt clean \
  && chown -R 2000:2000 /seafile 






# TODO
## 安装seafile
    # /seafile/目录下
    # https://github.com/haiwen/seafile-rpi/releases/download/v7.0.5/seafile-server_7.0.5_stable_pi.tar.gz
############
###################
##############

