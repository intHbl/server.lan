## inthbl/seafile_v7.0.5:20200710



FROM inthbl/seafile-v7.0.5-baselayer-armhf 
# .20200712

LABEL maintainer=hb-in@qq.com



# 80=>{8000,8082}
 
RUN groupadd -g 2000 runner \
&& useradd -u 2000 -g 2000 -m  runner \
&& mkdir /data  \
&& chown 2000:2000 /data  \
&& chmod 0777 /data


# COPY commad keep tar.gz formate
# this file contains configs , database ,... 
COPY seafile.init_data.2.1.tar.gz /

# start.sh
#  do init work if did not inited,
#  then start service.
ADD start.sh  /home/runner/start.sh


RUN chown 2000:2000 /home/runner/start.sh \
&& chmod +x /home/runner/start.sh


WORKDIR /
USER 2000:2000

EXPOSE 8000 8080 8082

VOLUME ["/data"]

ENTRYPOINT ["/home/runner/start.sh"]

CMD ["restart"]

