FROM stt/alpine:latest
MAINTAINER shitaotao <stt88@qq.com>

#定义环境变量
#ENV LANG="C.UTF-8"
#ENV LANG="zh_CN.UTF-8"
#ENV LANG="en_US.UTF8"

ENV FLANNELD_VERSION="v0.10.0"

RUN apk add --update ca-certificates openssl tar && \
    apk add --no-cache iproute2 net-tools iptables strongswan wireguard-tools && update-ca-certificates &&\
    wget https://github.com/coreos/flannel/releases/download/${FLANNELD_VERSION}/flannel-${FLANNELD_VERSION}-linux-amd64.tar.gz && \
    tar zxvf flannel-${FLANNELD_VERSION}-linux-amd64.tar.gz && \
    mv flanneld /bin/ && \
    chmod 755 /bin/flanneld &&\
    mv mk-docker-opts.sh /bin/ && \
    chmod 755 /bin/mk-docker-opts.sh && \
    rm -rf README.md && \
    apk del --purge tar && \
    rm -Rf flannel-${FLANNELD_VERSION}-linux-amd64* /var/cache/apk/*

VOLUME /data
#EXPOSE 2379 2380
ADD shell-flannel-run.sh /bin/run.sh
RUN chmod -R 755 /bin/run.sh
#ENTRYPOINT ["/bin/flanneld"]
ENTRYPOINT ["/bin/run.sh"]


