#!/bin/bash
#
# k8s生产环境安装需要配置的参数
#
echo "================="
echo "环境配置START."
#
#

# kubernetes二进制文件目录,默认: /opt/bin
BIN_PATH=/opt/bin
CNI_PATH=/opt/cni
# kubernetes的配置目录,默认:/etc/kubernetes
CONFIG_PATH=/etc/kubernetes
# kubernetes的CA证书目录,默认:/etc/kubernetes/ca
CA_PATH=/etc/kubernetes/ca


# 当前节点ip
NODE_IP=192.168.111.100
# 所有需要配置的主机IP
NODE_IPs="192.168.111.100,192.168.111.101,192.168.111.102,192.168.111.103,192.168.111.104,192.168.111.105"

#/etc/hosts 主机列表
HOSTS="192.168.111.108=vip,192.168.111.100=core01,192.168.111.101=core02,192.168.111.102=core03,192.168.111.103=core04,192.168.111.104=core05,192.168.111.105=core06"


# etcd 集群的ip
ETCD_IPs="192.168.111.100,192.168.111.101,192.168.111.102"
# etcd 集群服务地址列表
#ETCD_ENDPOINTS="core01=http://192.168.111.100:2379,core01=http://192.168.111.101:2379,core03=http://192.168.111.102:2379"
export ETCD_ENDPOINTS="https://92.168.111.100:2379,https://192.168.111.101:2379,https://92.168.111.102:2379"


# flanneld 网络配置前缀
export FLANNEL_ETCD_PREFIX="/kubernetes/network"


### K8S的IP地址定义
# kubernetes主节点ip
K8S_MASTER_IPs="192.168.111.100,192.168.111.101,192.168.111.102"
## kubernetes工作节点IP
K8S_NODE_IPs="192.168.111.103,192.168.111.104,192.168.111.105"
# kubernetes主节点虚拟IP
K8S_MASTER_VIP="192.168.111.108"

### 网段定义 （最好使用 主机未用的网段 来定义服务网段和 Pod 网段）
# 服务网段 (Service CIDR），部署前路由不可达，部署后集群内使用IP:Port可达
export K8S_SERVICE_CIDR="10.254.0.0/16"
# POD 网段 (Cluster CIDR），部署前路由不可达，**部署后**路由可达(flanneld保证)
export K8S_CLUSTER_CIDR="172.30.0.0/16"

# kubernetes 服务 IP (一般是 SERVICE_CIDR 中第一个IP)
export K8S_CLUSTER_KUBERNETES_SVC_IP="10.254.0.1"
# 集群 DNS 服务 IP (从 SERVICE_CIDR 中预分配)
export K8S_CLUSTER_DNS_SVC_IP="10.254.0.2"
# 集群 DNS 域名
export K8S_CLUSTER_DNS_DOMAIN="cluster.local."

# 服务端口范围 (NodePort Range)
export K8S_NODE_PORT_RANGE="40000-65000"

# TLS Bootstrapping 使用的 Token，可以使用命令 head -c 16 /dev/urandom | od -An -t x | tr -d ' ' 生成
BOOTSTRAP_TOKEN="44295c92f035cf8ba97a7c430de55ef9"



export KUBE_APISERVER="https://192.168.111.108:8080"


#
#
echo "================="
echo "环境配置END."
###end###