FROM stt/alpine:latest
MAINTAINER shitaotao <stt88@qq.com>


#定义环境变量
#ENV LANG="C.UTF-8"
#ENV LANG="zh_CN.UTF-8"
#ENV LANG="en_US.UTF8"

#root密码root

RUN apk --update add --no-cache openssh bash \
  && sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
  && echo "root:root" | chpasswd \
  && rm -rf /var/cache/apk/*  \
  && sed -ie 's/#Port 22/Port 22/g' /etc/ssh/sshd_config  \
  && sed -ri 's/#HostKey \/etc\/ssh\/ssh_host_key/HostKey \/etc\/ssh\/ssh_host_key/g' /etc/ssh/sshd_config  \
  && sed -ir 's/#HostKey \/etc\/ssh\/ssh_host_rsa_key/HostKey \/etc\/ssh\/ssh_host_rsa_key/g' /etc/ssh/sshd_config  \
  && sed -ir 's/#HostKey \/etc\/ssh\/ssh_host_dsa_key/HostKey \/etc\/ssh\/ssh_host_dsa_key/g' /etc/ssh/sshd_config  \
  && sed -ir 's/#HostKey \/etc\/ssh\/ssh_host_ecdsa_key/HostKey \/etc\/ssh\/ssh_host_ecdsa_key/g' /etc/ssh/sshd_config  \
  && sed -ir 's/#HostKey \/etc\/ssh\/ssh_host_ed25519_key/HostKey \/etc\/ssh\/ssh_host_ed25519_key/g' /etc/ssh/sshd_config  \
  && /usr/bin/ssh-keygen -A  \
  && ssh-keygen -t rsa -b 4096 -f  /etc/ssh/ssh_host_key

EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]

