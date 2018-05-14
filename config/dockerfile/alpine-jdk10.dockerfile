FROM stt/alpine-glibc:latest
MAINTAINER shitaotao <stt88@qq.com>


#定义环境变量
#ENV LANG="C.UTF-8"
ENV LANG="zh_CN.UTF-8"
#ENV LANG="en_US.UTF8"

#Java环境变量
ENV JAVA_HOME="/usr/lib/java/default"
ENV PATH=${JAVA_HOME}/bin:$PATH


WORKDIR /tmp

RUN apk add --no-cache --update-cache curl ca-certificates bash && \
    curl -jksSLH "Cookie: oraclelicense=accept-securebackup-cookie" \
###  "http://download.oracle.com/otn-pub/java/jdk/10+46/76eac37278c24557a3c4199677f19b62/serverjre-10_linux-x64_bin.tar.gz"  | gunzip -c - | tar -xf - && \
    "http://download.oracle.com/otn-pub/java/jdk/10+46/76eac37278c24557a3c4199677f19b62/jdk-10_linux-x64_bin.tar.gz"  | gunzip -c - | tar -xf - && \ 
    apk del curl ca-certificates && \
    mkdir /usr/lib/java && \ 
    mv jdk-10 /usr/lib/java/jdk-10 && \
    ln -s  /usr/lib/java/jdk-10 "$JAVA_HOME" &&\
    ln -s "$JAVA_HOME/bin/"* "/usr/bin/" && \
    rm -rf "$JAVA_HOME/lib/src.zip" && \
    rm -rf /tmp/* /var/cache/apk/* 

