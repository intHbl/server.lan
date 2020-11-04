FROM inthbl/gitea_bin-x86_64 as build-env

ARG uid_ 
ARG gid_
ARG username_



FROM alpine:3.12
LABEL maintainer="maintainers@gitea.io" modifiedBy="hb-in@qq.com"


ARG uid_ 
ARG gid_
ARG username_


RUN apk --no-cache add \
    bash \
    ca-certificates \
    curl \
    gettext \
    git \
    linux-pam \
    openssh \
    s6 \
    sqlite \
    su-exec \
    tzdata \
    gnupg

RUN addgroup -S -g ${gid_}  git \
  &&  adduser -S -H -D \
    -h /data/git \
    -s /bin/bash \
    -u ${uid_} -G git  git  \
  &&  echo "git:$(dd if=/dev/urandom bs=24 count=1 status=none | base64)" | chpasswd


# entry
COPY --from=build-env /go/src/code.gitea.io/gitea/docker/root /

# gitea bin
COPY --from=build-env /go/src/code.gitea.io/gitea/gitea /app/gitea/gitea
RUN ln -s /app/gitea/gitea /usr/local/bin/gitea

ENV USER git
ENV GITEA_CUSTOM /data/gitea

#USER git
EXPOSE 22 3000
VOLUME ["/data"]


ENTRYPOINT ["/usr/bin/entrypoint"]
CMD ["/bin/s6-svscan", "/etc/s6"]
