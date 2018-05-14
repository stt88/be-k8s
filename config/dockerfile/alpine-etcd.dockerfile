FROM stt/alpine:latest
MAINTAINER shitaotao <stt88@qq.com>

#定义环境变量
#ENV LANG="C.UTF-8"
#ENV LANG="zh_CN.UTF-8"
#ENV LANG="en_US.UTF8"

ENV ETCD_VERSION="v3.3.4"

RUN apk add --update ca-certificates openssl tar && \
    wget https://github.com/coreos/etcd/releases/download/${ETCD_VERSION}/etcd-${ETCD_VERSION}-linux-amd64.tar.gz && \
    tar zxvf etcd-${ETCD_VERSION}-linux-amd64.tar.gz && \
    mv etcd-${ETCD_VERSION}-linux-amd64/etcd* /bin/ && \
    apk del --purge tar  && \
    rm -Rf etcd-${ETCD_VERSION}-linux-amd64* /var/cache/apk/*

VOLUME /data
EXPOSE 2379 2380
ADD shell-etcd-run.sh /bin/run.sh
RUN chmod -R 755 /bin/run.sh
ENTRYPOINT ["/bin/run.sh"]
