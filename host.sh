#!/bin/bash
#
# k8s生产环境安装：主机配置
#
echo "================="
echo "主机配置START."
#
#
#1、设置系统参数 – 允许路由转发，不对bridge的数据进行处理
#写入配置文件
cat <<EOF > /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

#生效配置文件
sysctl -p /etc/sysctl.d/k8s.conf
#若问题
#执行sysctl -p 时出现：
#sysctl -p
#sysctl: cannot stat /proc/sys/net/bridge/bridge-nf-call-ip6tables: No such file or directory
#sysctl: cannot stat /proc/sys/net/bridge/bridge-nf-call-iptables: No such file or directory
#解决方法：
modprobe br_netfilter
ls /proc/sys/net/bridge
#
#
#
#2、group配置
usermod -aG docker root
usermod -aG docker core
#
#
#
#3、关闭系统Swap，记得/etc/fstab也要注解掉SWAP挂载
swapoff -a && sysctl -w vm.swappiness=0
#
#
#
#4、配置host，使每个Node都可以通过名字解析到ip地址
#/etc/hosts
echo "127.0.0.1       localhost" > /etc/hosts
echo "::1             localhost" >> /etc/hosts
arr1=$(echo $HOSTS|tr "," "\n")
for x1 in $arr1; do
   echo $x1 |sed 's/=/ /g' >> /etc/hosts
done
#
#
#5、配置PATH
mv /etc/profile{,.bak}
cp /etc/profile.bak /etc/profile
echo "export PATH=$CNI_PATH:$BIN_PATH:$PATH" >> /etc/profile
source /etc/profile
#
#
echo "================="
echo "主机配置END."
###end###