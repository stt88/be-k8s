FROM stt/alpine:latest
MAINTAINER shitaotao <stt88@qq.com>

#定义环境变量
#ENV LANG="C.UTF-8"
#ENV LANG="zh_CN.UTF-8"
#ENV LANG="en_US.UTF8"

ENV KEEPALIVED_VERSION="1.4.3"

RUN apk add --update ca-certificates openssl tar && \
    wget http://www.keepalived.org/software/keepalived-${KEEPALIVED_VERSION}.tar.gz && \
    tar zxvf keepalived-${KEEPALIVED_VERSION}.tar.gz && \
    mv keepalived-${KEEPALIVED_VERSION}/etcd* /bin/ && \

echo 2 >/proc/sys/net/ipv4/conf/all/arp_announce
echo 2 >/proc/sys/net/ipv4/conf/lo/arp_announce
echo 1 >/proc/sys/net/ipv4/conf/all/arp_announce
echo 1 >/proc/sys/net/ipv4/conf/lo/arp_announce
ifconfig lo:0 10.1.10.7 netmask 255.255.255.255 broadcast 10.1.10.7
route add -host 10.1.10.7 dev lo:0

    apk del --purge tar openssl && \
    rm -Rf keepalived-${KEEPALIVED_VERSION}* /var/cache/apk/*

VOLUME /data
EXPOSE 2379 2380 12379 12380
ADD run-etcd.sh /bin/run.sh
RUN chmod -R 755 /bin/run.sh
ENTRYPOINT ["/bin/run.sh"]
