#!/bin/bash
#
#
# 运行etcd
#
#flanneld --etcd-endpoints=http://192.168.2.143:4001 --etcd-prefix=/solinx.co/network --iface=ens33 > flannel.log 2>&;1 &;

docker run -d --name=flannel01 --net=host --restart=always  -v /var/etcd/data:/var/etcd/data stt/flannel \

  -etcd-endpoints http://127.0.0.1:2379
  -etcd-cafile   /etc/kubernetes/ca/ca.pem
  -etcd-certfile /etc/kubernetes/ca/etcd/etcd.pem
  -etcd-keyfile  /etc/kubernetes/ca/etcd/etcd-key.pem
  -etcd-prefix "/kubernetes/network"
  -etcd-password
  -etcd-username

#
#
#
###end###




