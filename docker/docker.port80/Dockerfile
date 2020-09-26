
###################################
#Build stage
FROM golang:1.14.9-buster
# 1.14-alpine3.12 alpine 好像复制到宿主机中无法运行.!!! 不知是什么原因




#Build deps
# RUN apk --no-cache add build-base git nodejs npm
#RUN apk --no-cache add git

#Setup repo
COPY http_server/*  ${GOPATH}/src/x/port80/
WORKDIR ${GOPATH}/src/x/port80

#Checkout version if set
RUN  mkdir /out \
    &&  go build -o /out/http_server  ./*.go
    #TODO? GOOS=linux GOARCH=arm  go build -o /out/http_server  ./*.go

VOLUME [ "/data" ]

CMD ["cp", "/out/http_server", "/data" ]
