#!/bin/bash
#
#
# 运行etcd
#
#flanneld --etcd-endpoints=http://192.168.2.143:4001 --etcd-prefix=/solinx.co/network --iface=ens33 > flannel.log 2>&;1 &;

docker run -d --name=etcd01 --net=host --restart=always  -v /var/etcd/data:/var/etcd/data stt/etcd \

  --data-dir=/var/etcd/data

  --initial-cluster-state=new
  --initial-cluster-token=etcd-cluster-1
  --initial-cluster=etc-core02=https://192.168.111.101:2380,etcd-core01=https://192.168.111.100:2380,etcd-core03=https://192.168.111.102:2380
  --initial-advertise-peer-urls=https://192.168.111.101:2380
  --listen-client-urls=https://0.0.0.0:2379
  --listen-peer-urls=https://0.0.0.0:2380
  --advertise-client-urls=https://192.168.111.101:2379

  --peer-client-cert-auth
  --client-cert-auth
  --cert-file=/etc/kubernetes/ca/etcd/etcd.pem
  --key-file=/etc/kubernetes/ca/etcd/etcd-key.pem
  --trusted-ca-file=/etc/kubernetes/ca/ca.pem
  --peer-cert-file=/etc/kubernetes/ca/etcd/etcd.pem
  --peer-key-file=/etc/kubernetes/ca/etcd/etcd-key.pem
  --peer-trusted-ca-file=/etc/kubernetes/ca/ca.pem

  --heartbeat-interval=500
  --election-timeout=5000
#
#
#
###end###




