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
#
#当前目录
workpath=$(cd `dirname $0`; pwd)
echo '当前工作目录'$workpath
rm -rf /etc/kubernetes
rm -rf $workpath/config/ca
rm -rf $workpath/config/conf
rm -rf $workpath/config/key
rm -rf $workpath/config/sh

#
###==================================
#环境变量
source $workpath/env.sh
#
###==================================
#生成CA
source $workpath/ca1.sh
#
###==================================
#下载k8s二进制文件
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


    ssh $ip2 "rm -rf /tmp/iamges"

done
#
#
echo "安装END."