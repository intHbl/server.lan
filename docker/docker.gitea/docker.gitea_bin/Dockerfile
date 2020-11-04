
###################################
#Build stage
FROM golang:1.14-alpine3.12 AS build-env

ARG GOPROXY
ENV GOPROXY ${GOPROXY:-direct}
# china :: GOPROXY=https://goproxy.cn

# ARG GITEA_VERSION
ARG TAGS="sqlite sqlite_unlock_notify"
ENV TAGS "bindata $TAGS"
ARG CGO_EXTRA_CFLAGS


#Build deps
RUN apk --no-cache add build-base git nodejs npm

#Setup repo
ADD  gitea.v1.12.2.OK.tar.gz   ${GOPATH}/src/code.gitea.io/gitea
COPY context.go   ${GOPATH}/src/code.gitea.io/gitea/modules/context/context.go
WORKDIR ${GOPATH}/src/code.gitea.io/gitea

#Checkout version if set
# RUN if [ -n "${GITEA_VERSION}" ]; then git checkout "${GITEA_VERSION}"; fi \
#  && make clean-all build
RUN make clean-all build


