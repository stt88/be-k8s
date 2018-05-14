FROM stt/alpine:latest
MAINTAINER shitaotao <stt88@qq.com>

#定义环境变量
#ENV LANG="C.UTF-8"
#ENV LANG="zh_CN.UTF-8" 
#ENV LANG="en_US.UTF8"

#定义glib版本
ENV GLIBC_VERSION=2.27-r0

# Download and install glibc
RUN apk add --update curl && \
  curl -Lo /etc/apk/keys/sgerrand.rsa.pub   https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub && \
  curl -Lo glibc.apk      "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk" && \
  curl -Lo glibc-bin.apk  "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk" && \
  curl -Lo glibc-i18n.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-i18n-${GLIBC_VERSION}.apk" && \
  apk add glibc-bin.apk glibc.apk glibc-i18n.apk && \
  /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib && \
  echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
  apk del curl && \
  rm -rf glibc.apk glibc-bin.apk glibc-i18n.apk /var/cache/apk/*
