#!/bin/bash
#
echo "安装START:"
#
#
#
#当前目录
workpath=$(cd `dirname $0`; pwd)
echo '当前工作目录'$workpath

#
#
###==================================
#环境变量
source $workpath/env.sh
#
#
###==================================
#docker装载镜像
ip5=$(echo $NODE_IPs|tr "," "\n")
for ip6 in $ip5; do
    ssh $ip6 "source $CONFIG_PATH/sh/docker.sh"
done
#
#
###==================================
#运行etcd
etcd_ip=$(echo $ETCD_IPs|tr "," "\n")
for etcd_ip1 in $etcd_ip; do
    ssh $etcd_ip1 "source $CONFIG_PATH/sh/docker_run_etcd.sh"
done
#
###==================================
#flannel
#在etcd里插入flannel配置信息,指定flannel使用172.100.0.0/16区间
export ETCDCTL_API=2
$BIN_PATH/etcdctl \
   --cert-file /etc/kubernetes/ca/etcd/etcd.pem \
   --key-file /etc/kubernetes/ca/etcd/etcd-key.pem \
   --ca-file /etc/kubernetes/ca/ca.pem \
   --endpoints "http://192.168.111.100:2379,http://192.168.111.101:2379,http://192.168.111.102:2379" \
   set /kubernetes/network/config '{"Network":"172.100.0.0/16","SubnetLen": 20,"Backend":{"Type"":"vxlan","VNI":1}}'
# or:
#
echo "安装END."