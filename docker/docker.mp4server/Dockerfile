#Build stage
FROM golang:1.14-alpine3.12  AS  build-env

RUN mkdir -p ${GOPATH}/src/file.server/fsvr
COPY *.go ${GOPATH}/src/file.server/fsvr
WORKDIR   ${GOPATH}/src/file.server/fsvr

RUN go build  -o file_server *.go





FROM alpine:3.12

# LABEL  <k1>=<value> [<k2>=<v2>…]
LABEL "maintainer"="hb-in@qq.com"


COPY      entrypoint.sh   /etc/
COPY --from=build-env  /go/src/file.server/fsvr/file_server /file_server

RUN chmod +x /etc/entrypoint.sh /file_server 


VOLUME ["/data"]

EXPOSE 8080
WORKDIR /
USER 2000

ENTRYPOINT ["/etc/entrypoint.sh"]




