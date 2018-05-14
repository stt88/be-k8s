FROM alpine:3.7
MAINTAINER shitaotao <stt88@qq.com>

#定义环境变量
ENV LANG="C.UTF-8"
#ENV LANG="zh_CN.UTF-8"
#ENV LANG="en_US.UTF8"

#定义时区变量
ENV TIME_ZONE=Asia/Shanghai


#阿里源
RUN  echo 'https://mirrors.aliyun.com/alpine/v3.7/main/' > /etc/apk/repositories \
     && echo 'https://mirrors.aliyun.com/alpine/v3.7/community/' >> /etc/apk/repositories

#安装时区tzdata包
RUN   apk add --no-cache tzdata

#设置时区
RUN  echo "${TIME_ZONE}" > /etc/timezone \ 
     && ln -sf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime 
