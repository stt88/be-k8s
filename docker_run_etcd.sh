#!/bin/bash
#
#
# 运行etcd
#
rm -rf /data/lib/etcd
mkdir -p /data/lib/etcd
docker run -d  --net=host -v /data/lib/etcd:/data -v /etc/kubernetes/ca:/ca  stt/etcd \
  --name=etcd01 \
  --initial-cluster-state=new \
  --initial-cluster-token=etcd-cluster-1 \
  --initial-cluster=etcd01=https://192.168.111.100:2380,etcd02=https://192.168.111.101:2380,etcd03=https://192.168.111.102:2380 \
  --initial-advertise-peer-urls=https://192.168.111.100:2380 \
  --advertise-client-urls=https://192.168.111.100:2379 \
  --cert-file=/ca/etcd/etcd.pem \
  --key-file=/ca/etcd/etcd-key.pem \
  --trusted-ca-file=/ca/ca.pem \
  --peer-cert-file=/ca/etcd/etcd.pem \
  --peer-key-file=/ca/etcd/etcd-key.pem \
  --peer-trusted-ca-file=/ca/ca.pem \
  --heartbeat-interval=500 \
  --election-timeout=5000

 --peer-client-cert-auth
  --client-cert-auth

  --listen-client-urls=https://0.0.0.0:2379 \
  --listen-peer-urls=https://0.0.0.0:2380 \
--restart=always

#
#
#
###end###




