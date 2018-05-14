#!/bin/bash
#
# k8s生产环境安装：下载k8s二进制文件
#
echo "================="
echo "下载K8S二进制文件START."
#
#
#当前目录
workpath=$(cd `dirname $0`; pwd)
echo '当前工作目录'$workpath
#
#
mkdir -p $workpath/soft
mkdir -p $workpath/soft/bin
mkdir -p $workpath/soft/images
mkdir -p $workpath/soft/cni
#
#
wget https://github.com/coreos/etcd/releases/download/v3.3.4/etcd-v3.3.4-linux-amd64.tar.gz
tar zxvf etcd-v3.3.4-linux-amd64.tar.gz
mv etcd-v3.3.4-linux-amd64/etcd $workpath/soft/bin/
mv etcd-v3.3.4-linux-amd64/etcdctl $workpath/soft/bin/
chmod +x $workpath/soft/bin/etcd
chmod +x $workpath/soft/bin/etcdctl
rm -rf etcd-v3.3.4-linux-amd64.tar.gz
rm -rf etcd-v3.3.4-linux-amd64
wget https://github.com/coreos/flannel/releases/download/v0.10.0/flannel-v0.10.0-linux-amd64.tar.gz
tar zxvf flannel-v0.10.0-linux-amd64.tar.gz
mv flanneld $workpath/soft/bin/
mv mk-docker-opts.sh $workpath/soft/bin/
rm -rf flannel-v0.10.0-linux-amd64.tar.gz
rm -rf README.md
chmod +x $workpath/soft/bin/flanneld
chmod +x $workpath/soft/bin/mk-docker-opts.sh
wget https://github.com/docker/compose/releases/download/1.21.0/docker-compose-Linux-x86_64  -O $workpath/soft/bin/docker-compose
wget https://github.com/docker/machine/releases/download/v0.14.0/docker-machine-Linux-x86_64 -O $workpath/soft/bin/docker-machine
chmod +x $workpath/soft/bin/docker-compose
chmod +x $workpath/soft/bin/docker-machine
wget https://storage.googleapis.com/kubernetes-helm/helm-v2.9.0-rc4-linux-amd64.tar.gz
tar zxvf helm-v2.9.0-rc4-linux-amd64.tar.gz
mv linux-amd64/helm $workpath/soft/bin/
chmod +x $workpath/soft/bin/helm
rm -rf helm-v2.9.0-rc4-linux-amd64*
rm -rf linux-amd64
#
wget https://dl.k8s.io/v1.10.2/kubernetes-server-linux-amd64.tar.gz
tar zxvf kubernetes-server-linux-amd64.tar.gz
mv -f kubernetes/server/bin/*.tar $workpath/soft/images/
rm -rf kubernetes/server/bin/*_tag
chmod +x kubernetes/server/bin/*
mv -f kubernetes/server/bin/*  $workpath/soft/bin/
rm -rf kubernetes-server-linux-amd64.tar.gz
rm -rf kubernetes
ls -la  $workpath/soft/bin/
ls -la  $workpath/soft/images/
#
wget https://github.com/containernetworking/plugins/releases/download/v0.7.1/cni-plugins-amd64-v0.7.1.tgz
tar zxvf cni-plugins-amd64-v0.7.1.tgz -C $workpath/soft/cni
#
#
echo "================="
echo "下载K8S二进制文件END."
####end###