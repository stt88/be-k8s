#!/bin/bash
#
#
#
echo "================="
echo "安装K8S生产环境，主机需开通ssh免密登录、已安装docker"
echo "                   并需要删除etcd和flannel服务"
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
###==================================
#下载k8s二进制文件
source $workpath/soft.sh
#
###==================================
#生成CA
source $workpath/ca.sh
#
#生成kube的配置文件
source $workpath/kube.sh
#
###==================================
#所有主机,复制CA证书和二进制软件
ip1=$(echo $NODE_IPs|tr "," "\n")
for ip2 in $ip1; do
    ssh $ip2 "mkdir -p $BIN_PATH"
    ssh $ip2 "mkdir -p $CNI_PATH"
    ssh $ip2 "mkdir -p $CA_PATH"
    ssh $ip2 "mkdir -p $CONFIG_PATH/sh"
    ssh $ip2 "mkdir -p $CONFIG_PATH/conf"
    ssh $ip2 "mkdir -p $CONFIG_PATH/key"
    ssh $ip2 "mkdir -p $CONFIG_PATH/dockerfile"
    ssh $ip2 "mkdir -p $CONFIG_PATH/yaml"
    ssh $ip2 "mkdir -p /tmp/images"

    scp $workpath/docker.sh  $ip2:$CONFIG_PATH/sh/docker.sh
    scp $workpath/host.sh  $ip2:$CONFIG_PATH/sh/host.sh
    scp -r $workpath/docker_run*  $ip2:$CONFIG_PATH/sh
    ssh $ip2 "chown +x $CONFIG_PATH/sh/*"

    scp -r $workpath/config/ca/* $ip2:$CA_PATH
    scp -r $workpath/config/conf/*  $ip2:$CONFIG_PATH/conf
    scp -r $workpath/config/key/*  $ip2:$CONFIG_PATH/key
    scp -r $workpath/config/dockerfile/*  $ip2:$CONFIG_PATH/dockerfile
    scp -r $workpath/config/k8s-yaml/*  $ip2:$CONFIG_PATH/yaml

    scp -r $workpath/soft/bin/*  $ip2:$BIN_PATH
    ssh $ip2 "chown +x $BIN_PATH/*"

    scp -r $workpath/soft/images/*  $ip2:/tmp/images
    ssh $ip2 "docker load -i /tmp/images/cloud-controller-manager.tar"
    ssh $ip2 "docker load -i /tmp/images/kube-aggregator.tar"
    ssh $ip2 "docker load -i /tmp/images/kube-apiserver.tar"
    ssh $ip2 "docker load -i /tmp/images/kube-controller-manager.tar"
    ssh $ip2 "docker load -i /tmp/images/kube-proxy.tar"
    ssh $ip2 "docker load -i /tmp/images/kube-scheduler.tar"
    ssh $ip2 "rm -rf /tmp/iamges"
    ssh $ip2 "docker images"
done
#
###==================================
#所有主机配置
ip3=$(echo $NODE_IPs|tr "," "\n")
for ip4 in $ip3; do
    ssh $ip4 "source $CONFIG_PATH/sh/host.sh"
done
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
# 复制etcd CA配置至其他主机
#ip0=$(echo $ETCD_IPs|tr "," "\n")
#for x0 in $ip0; do
#   scp  root@$x0
#
#done
#
###==================================
# 复制k8s Master CA配置至其他主机
#ip1=$(echo $K8S_MASTER_IPs|tr "," "\n")
#for x1 in $ip1; do
#   scp  root@$x1
#done
#
###==================================
# 复制k8s 工作节点CA配置至其他主机
#ip2=$(echo $K8S_NODE_IPs|tr "," "\n")
#for x2 in $ip2; do
#   scp  root@$x0
#done
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
   --endpoints "https://192.168.111.100:2379,https://192.168.111.101:2379,https://192.168.111.102:2379" \
   set /kubernetes/network/config '{"Network":"172.100.0.0/16","SubnetLen": 20,"Backend":{"Type"":"vxlan","VNI":1}}'
# or:
#export ETCDCTL_API=3
#$BIN_PATH/etcdctl \
#   --cert="/etc/kubernetes/ca/etcd/etcd.pem" \
#   --key="/etc/kubernetes/ca/etcd/etcd-key.pem" \
#   --cacert="/etc/kubernetes/ca/ca.pem" \
#   --endpoints="http://192.168.111.100:2379,http://192.168.111.101:2379,http://192.168.111.102:2379" \
#   put /kubernetes/network/config '{"Network":"172.100.0.0/16","SubnetLen": 20,"Backend":{"Type"":"vxlan","VNI":1}}'
#
#
#运行
flannel_ip=$(echo $NODE_IPs|tr "," "\n")
for flannel_ip1 in $flannel_ip; do
    ssh $flannel_ip1 "source $CONFIG_PATH/sh/docker_run_flannel.sh"
done
#
#
###==================================
#部署Kubernetes的#master节点
mip=$(echo $K8S_MASTER_IPs|tr "," "\n")
 for mip1 in $mip; do
   ssh $mip1 "source $CONFIG_PATH/sh/docker_run_master.sh"
   ssh $mip1 "docker ps"
done
#
#查看kubernetes版本信息
$BIN_PATH/kubectl -s 192.168.2.143:8080 version
#
#工作节点启动kubelet
#取得work节点IP
export NODE_IP=`ifconfig ens33 | grep 'inet addr:' | cut -d: -f2 | cut -d' ' -f1`
#启动kubelet
kubelet --api-servers=192.168.2.143:8080 --node-ip=$NODE_IP --hostname_override=192.168.2.144 > kubelet.log 2>&;1 &;
#注意如果当前两个几点的主机名相同则一定要使用hostname_override参数,否则需要把主机名改为不同的;

#在master上查看节点信息
kubectl -s 192.168.2.143:8080 get no

#启动kube-proxy
kube-proxy --master=192.168.2.143:8080 > proxy.log 2>&;1 &;

#查看pod、replication controller、service和endpoint
$BIN_PATH/kubectl -s 192.168.1.143:8080 get po
$BIN_PATH/kubectl -s 192.168.1.143:8080 get rc
$BIN_PATH/kubectl -s 192.168.1.143:8080 get svc
$BIN_PATH/kubectl -s 192.168.1.143:8080 get ep





echo "================="
echo "安装END."
