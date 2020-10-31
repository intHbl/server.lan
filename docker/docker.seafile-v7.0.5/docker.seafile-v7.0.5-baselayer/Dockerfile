FROM ubuntu:xenial


## installed pre-requirement and  seafile program.

LABEL  seafileVersion="7.0.5" 



ARG uid_ 
ARG gid_
ARG username_


ADD sources.armhf.list  /etc/apt/
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
  && chown ${uid_}:${gid_} /seafile  \
  && chown -R ${uid_}:${gid_} /seafile 





