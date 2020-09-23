#Build stage
FROM golang:1.14-alpine3.12  AS  build-env

RUN mkdir -p ${GOPATH}/src/file.server/fsvr
COPY *.go ${GOPATH}/src/file.server/fsvr
WORKDIR   ${GOPATH}/src/file.server/fsvr

RUN go build  -o file_server *.go





FROM alpine:3.12

# LABEL  <k1>=<value> [<k2>=<v2>…]
LABEL "maintainer"="hb-in@qq.com"

# aria2.conf  entrypoint.sh
COPY   aria2.conf   entrypoint.sh   /etc/

RUN  echo "http://mirrors.aliyun.com/alpine/v3.12/main" > /etc/apk/repositories  \
&& echo "http://mirrors.aliyun.com/alpine/v3.12/community" >> /etc/apk/repositories  \
&& chmod +x /etc/entrypoint.sh \
&& chown  2000:2000   /etc/entrypoint.sh /etc/aria2.conf \
&& apk update \
&& apk add --no-cache aria2  \
&& apk add --no-cache tzdata  \
&& echo "Asia/Shanghai" > /etc/timezone  \
&& mv /usr/share/zoneinfo/Asia/Shanghai    /etc/localtime  \
&& apk del tzdata  \
&& rm -rf /var/cache/apk/*  \
&& rm -rf /root/.cache  \
&& rm -rf /tmp/*


COPY --from=build-env  /go/src/file.server/fsvr/file_server /file_server

VOLUME ["/data"]
EXPOSE 6800
WORKDIR /
USER 2000

ENTRYPOINT ["/etc/entrypoint.sh"]
# 6800/jsonrpc  --> 6801

# CMD ["--conf-path=/etc/aria2.conf"]



