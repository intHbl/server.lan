FROM inthbl/seafile-v7.0.5-baselayer-armhf
# latest


LABEL maintainer=hb-in@qq.com 


# init the data 
## and add user 
## add volume ,expose port
## and start process by this user.




# COPY commad keep tar.gz formate
# this file contains configs , database ,... 
COPY seafile.init_data.2.1.tar.gz /

# start.sh
#  do init work if did not inited,
#  then start service.
ADD start.sh  /home/runner/start.sh

 
RUN groupadd -g 2000 runner \
&& useradd -u 2000 -g 2000 -m  runner \
&&   mkdir /data  \
&&   chown 2000:2000 /data  \
&&   chmod 0777 /data \
&&     chown 2000:2000 /home/runner/start.sh seafile.init_data.2.1.tar.gz \
&&     chmod +x /home/runner/start.sh


WORKDIR /
USER 2000:2000

# 80=>{8000,8082}
EXPOSE 8000 8080 8082

VOLUME ["/data"]

ENTRYPOINT ["/home/runner/start.sh"]

CMD ["restart"]

