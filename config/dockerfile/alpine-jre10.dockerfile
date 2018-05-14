FROM stt/alpine-glibc:latest
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
###  "http://download.oracle.com/otn-pub/java/jdk/10+46/76eac37278c24557a3c4199677f19b62/serverjre-10_linux-x64_bin.tar.gz"  | gunzip -c - | tar -xf - && \
    "http://download.oracle.com/otn-pub/java/jdk/10+46/76eac37278c24557a3c4199677f19b62/jdk-10_linux-x64_bin.tar.gz"  | gunzip -c - | tar -xf - && \ 
    apk del curl ca-certificates && \
    mkdir /opt && \ 
    mkdir /opt/java && \
    mv jdk-10 /opt/java/jdk-10 && \
    ln -s  /opt/java/jdk-10 /opt/java/default &&\
    rm -rf /tmp/* /var/cache/apk/* 

