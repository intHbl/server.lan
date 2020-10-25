FROM ubuntu:xenial AS initDataStage

# cd docker/docker.seafile-v7.0.5/ 
# docker build -t test/seafile -f  x86_64.Dockerfile .

# COPY commad keep tar.gz formate
# this file contains configs , database ,... 
# COPY seafile.init_data.2.1.tar.gz /


## overwrite by setting --build-arg uid_=xxxx
ARG uid_=2000 
ARG gid_=2000
ARG username_=test

ADD /seafile.init_data.*.tar.gz /initdata
RUN chown -R  ${uid_}:${gid_}  /initdata 


###################

FROM seafileltd/seafile-mc:7.0.5  
## ubuntu:xenial
LABEL maintainer=hb-in@qq.com  
LABEL readme="default admin user :: user=admin@admin.lan  passwd=admin"

# init the data 
## and add user 
## add volume ,expose port
## and start process by this user.


ARG uid_=2000 
ARG gid_=2000
ARG username_=test




RUN apt update \
    && apt install -y sqlite3  \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 

# add  user:group
# data: /data , bin: /seafile
RUN groupadd -g ${gid_} ${username_} \
    &&   useradd -u ${uid_} -g ${gid_} -m  ${username_} \
    &&   mkdir /data /seafile  \
    &&   chown ${uid_}:${gid_} /data  /seafile  \
    &&   chmod 0777 /data /seafile \
    &&   mv /opt/seafile/seafile-server-7.0.5 /seafile \
    &&   chown -R ${uid_}:${gid_} /seafile


COPY --from=initDataStage /initdata /initdata

# 80=>{8000,8082}  web:8000 webdav:8080  file:8082
EXPOSE 8000 8080 8082


# entry :: ./start.sh
#  do init work if did not inited,
#  then start service.

ADD start.sh  /start.sh
RUN  chown ${uid_}:${gid_} /start.sh  \
    &&  chmod +x /start.sh 

WORKDIR /
USER ${uid_}
VOLUME ["/data"]


ENTRYPOINT ["/start.sh"]
CMD ["restart"]
