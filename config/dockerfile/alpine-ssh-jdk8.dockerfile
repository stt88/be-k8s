FROM stt/alpine-glibc-ssh:latest
MAINTAINER shitaotao <shitaotao.js@chinatelecom.cn>


#定义环境变量
#ENV LANG="C.UTF-8"
ENV LANG="zh_CN.UTF-8"
#ENV LANG="en_US.UTF8"

#Java环境变量
ENV JAVA_HOME=/opt/java/default
ENV PATH=${JAVA_HOME}/bin:$PATH


WORKDIR /tmp

RUN apk add --no-cache --update-cache curl ca-certificates bash && \
    curl -jksSLH "Cookie: oraclelicense=accept-securebackup-cookie" \
    "http://download.oracle.com/otn-pub/java/jdk/8u162-b12/0da788060d494f5095bf8624735fa2f1/server-jre-8u162-linux-x64.tar.gz"  | gunzip -c - | tar -xf - && \
    apk del curl ca-certificates && \
    mkdir /opt && \ 
    mkdir /opt/java && \
    mv jdk1.8.0_162 /opt/java/jdk1.8.0_162 && \
    ln -s  /opt/java/jdk1.8.0_162 /opt/java/default &&\
    rm -rf /tmp/* /var/cache/apk/* 

