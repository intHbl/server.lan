FROM ubuntu:xenial AS initDataStage


# COPY commad keep tar.gz formate
# this file contains configs , database ,... 
# COPY seafile.init_data.2.1.tar.gz /

ARG uid_ 
ARG gid_
ARG username_

ADD /seafile.init_data.*.tar.gz /initdata
RUN chown -R  ${uid_}:${gid_}  /initdata 



FROM inthbl/seafile-v7.0.5-baselayer-armhf
# latest

LABEL maintainer=hb-in@qq.com  
LABEL readme="default admin user :: user=admin@admin.lan  passwd=admin"

# init the data 
## and add user 
## add volume ,expose port
## and start process by this user.


ARG uid_ 
ARG gid_
ARG username_

# start.sh
#  do init work if did not inited,
#  then start service.


# add user , mkdir data 
RUN groupadd -g ${gid_} ${username_} \
    &&   useradd -u ${uid_} -g ${gid_} -m  ${username_} \
    &&   mkdir /data  \
    &&   chown ${uid_}:${gid_} /data  \
    &&   chmod 0777 /data 

ADD start.sh  /start.sh

RUN  chown ${uid_}:${gid_} /start.sh  \
    &&  chmod +x /start.sh 

COPY --from=initDataStage /initdata /initdata

WORKDIR /
USER ${uid_}

# 80=>{8000,8082}
EXPOSE 8000 8080 8082

VOLUME ["/data"]

ENTRYPOINT ["/start.sh"]

CMD ["restart"]

