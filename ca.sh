#!/bin/bash
#
# k8s生产环境安装CA证书
#
#当前目录
workpath=$(cd `dirname $0`; pwd)
echo '当前工作目录'$workpath
#
#
#
#
echo "================="
echo "下载CA工具START"
#
#软件位置
mkdir -p $BIN_PATH
#在线下载
wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 -O $BIN_PATH/cfssl
chmod +x $BIN_PATH/cfssl
wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64  -O $BIN_PATH/cfssljson
chmod +x $BIN_PATH/cfssljson
wget https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64  -O $BIN_PATH/cfssl-certinfo
chmod +x $BIN_PATH/cfssl-certinfo
#路径
export PATH=$BIN_PATH:$PATH
#json模板
#cd $BIN_PATH
#cfssl print-defaults config > config.example.json
#cfssl print-defaults csr > csr.example.json
#
echo "================="
echo "下载CA工具END."
#
#
#
echo "================="
echo "CA配置START"
#
########################################################################################################
########################################################################################################
########################################################################################################
###1.根证书
#目录
mkdir -p $workpath/config/ca
#生成根证书
cat <<EOF > $workpath/config/ca/ca-config.json
{
  "signing": {
    "default": {
      "expiry": "87600h"
    },
    "profiles": {
      "kubernetes": {
        "usages": [
            "signing",
            "key encipherment",
            "server auth",
            "client auth"
        ],
        "expiry": "87600h"
      }
    }
  }
}
EOF
#
cat <<EOF > $workpath/config/ca/ca-csr.json
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "Beijing",
      "L": "XS",
      "O": "k8s",
      "OU": "System"
    }
  ]
}
EOF
#
#生成证书和秘钥
cd $workpath/config/ca
cfssl gencert -initca ca-csr.json | cfssljson -bare ca
#生成完成后会有以下文件（我们最终想要的就是ca-key.pem和ca.pem，一个秘钥，一个证书）
ls -la
#ca-config.json  ca.csr  ca-csr.json  ca-key.pem  ca.pem
#
########################################################################################################
########################################################################################################
########################################################################################################
###2.生成ETCD证书
#目录
mkdir -p $workpath/config/ca/etcd
#etcd证书
cat <<EOF > $workpath/config/ca/etcd/etcd-csr.json
{
  "CN": "etcd",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "Beijing",
      "L": "XS",
      "O": "k8s",
      "OU": "System"
    }
  ],
   "hosts": [
EOF
#
#
ca_arr1=$(echo $ETCD_IPs|tr "," "\n")
for ca_host1 in $ca_arr1; do
   echo  "     \"$ca_host1\"," >> $workpath/config/ca/etcd/etcd-csr.json
done
echo "    \"127.0.0.1\" " >> $workpath/config/ca/etcd/etcd-csr.json
echo "  ]" >> $workpath/config/ca/etcd/etcd-csr.json
echo "}" >> $workpath/config/ca/etcd/etcd-csr.json
#
#准备etcd证书配置
cd $workpath/config/ca/etcd/
#使用根证书(ca.pem)签发etcd证书
cfssl gencert \
        -ca=$workpath/config/ca/ca.pem \
        -ca-key=$workpath/config/ca/ca-key.pem \
        -config=$workpath/config/ca/ca-config.json \
        -profile=kubernetes \
        etcd-csr.json | cfssljson -bare etcd
#跟之前类似生成三个文件etcd.csr是个中间证书请求文件，我们最终要的是etcd-key.pem和etcd.pem
ls -la
#etcd.csr  etcd-csr.json  etcd-key.pem  etcd.pem
#
########################################################################################################
########################################################################################################
########################################################################################################
# 3.calico证书
#calico证书放在这
mkdir -p $workpath/config/ca/calico
#准备calico证书配置 - calico只需客户端证书，因此证书请求中 hosts 字段可以为空
cat <<EOF > $workpath/config/ca/calico/calico-csr.json
{
  "CN": "calico",
  "hosts": [],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "Beijing",
      "L": "XS",
      "O": "k8s",
      "OU": "System"
    }
  ]
}
EOF
#
cd $workpath/config/ca/calico
#使用根证书(ca.pem)签发calico证书
cfssl gencert \
    -ca=$workpath/config/ca/ca.pem \
    -ca-key=$workpath/config/ca/ca-key.pem \
    -config=$workpath/config/ca/ca-config.json \
    -profile=kubernetes \
    calico-csr.json | cfssljson -bare calico
#我们最终要的是calico-key.pem和calico.pem
ls -la
#calico.csr  calico-csr.json  calico-key.pem  calico.pem
#
########################################################################################################
########################################################################################################
########################################################################################################
# 4.flannel证书
mkdir -p $workpath/config/ca/flannel
#准备flannel证书配置 - flannel只需客户端证书，因此证书请求中 hosts 字段可以为空
cat <<EOF > $workpath/config/ca/flannel/flannel-csr.json
{
  "CN": "flannel",
  "hosts": [],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "Beijing",
      "L": "XS",
      "O": "k8s",
      "OU": "System"
    }
  ]
}
EOF
#
cd $workpath/config/ca/flannel
#使用根证书(ca.pem)签发flannel证书
cfssl gencert \
    -ca=$workpath/config/ca/ca.pem \
    -ca-key=$workpath/config/ca/ca-key.pem \
    -config=$workpath/config/ca/ca-config.json \
    -profile=kubernetes \
    flannel-csr.json | cfssljson -bare flannel
#我们最终要的是flannel-key.pem和flannel.pem
ls -la
#flannel.csr  flannel-csr.json  flannel-key.pem  flannel.pem
#
#
########################################################################################################
########################################################################################################
########################################################################################################
### 5.生成api-server证书
#api-server证书放在这，api-server是核心，文件夹叫kubernetes吧，如果想叫apiserver也可以，不过相关的地方都需要修改哦
mkdir -p $workpath/config/ca/kubernetes
#准备apiserver证书配置
cat <<EOF > $workpath/config/ca/kubernetes/kube-apiserver-csr.json
{
  "CN": "kube-apiserver",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "Beijing",
      "L": "XS",
      "O": "k8s",
      "OU": "System"
    }
  ],
  "hosts": [
    "kubernetes",
    "kubernetes.default",
    "kubernetes.default.svc",
    "kubernetes.default.svc.cluster",
    "kubernetes.default.svc.cluster.local",
EOF
#
ca_arr2=$(echo $K8S_MASTER_IPs|tr "," "\n")
for ca_host2 in $ca_arr2; do
   echo  "     \"$ca_host2\"," >> $workpath/config/ca/kubernetes/kube-apiserver-csr.json
done
echo "    \"$K8S_MASTER_VIP\"," >> $workpath/config/ca/kubernetes/kube-apiserver-csr.json
echo "    \"$K8S_CLUSTER_KUBERNETES_SVC_IP\"," >> $workpath/config/ca/kubernetes/kube-apiserver-csr.json
echo "    \"127.0.0.1\" " >> $workpath/config/ca/kubernetes/kube-apiserver-csr.json
echo "  ]" >> $workpath/config/ca/kubernetes/kube-apiserver-csr.json
echo "}" >> $workpath/config/ca/kubernetes/kube-apiserver-csr.json
#
cd $workpath/config/ca/kubernetes
#使用根证书(ca.pem)签发kube-apiserver证书
cfssl gencert \
        -ca=$workpath/config/ca/ca.pem \
        -ca-key=$workpath/config/ca/ca-key.pem \
        -config=$workpath/config/ca/ca-config.json \
        -profile=kubernetes \
        kube-apiserver-csr.json | cfssljson -bare kube-apiserver
#跟之前类似生成三个文件kubernetes.csr是个中间证书请求文件，我们最终要的是kubernetes-key.pem和kubernetes.pem
ls -la
#kubernetes.csr  kubernetes-csr.json  kubernetes-key.pem  kubernetes.pem
#
#
########################################################################################################
########################################################################################################
########################################################################################################
### 6. Controller Manager Certificate
#准备controller-manager证书配置
cat <<EOF > $workpath/config/ca/kubernetes/kube-controller-manager-csr.json
{
  "CN": "system:kube-controller-manager",
  "hosts": [],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "Beijing",
      "L": "XS",
      "O": "k8s",
      "OU": "System"
    }
  ],
  "hosts": [
    "kubernetes",
    "kubernetes.default",
    "kubernetes.default.svc",
    "kubernetes.default.svc.cluster",
    "kubernetes.default.svc.cluster.local",
EOF
#
ca_arr2=$(echo $K8S_MASTER_IPs|tr "," "\n")
for ca_host2 in $ca_arr2; do
   echo  "     \"$ca_host2\"," >> $workpath/config/ca/kubernetes/kube-controller-manager-csr.json
done
echo "    \"$K8S_MASTER_VIP\"," >> $workpath/config/ca/kubernetes/kube-controller-manager-csr.json
echo "    \"$K8S_CLUSTER_KUBERNETES_SVC_IP\"," >> $workpath/config/ca/kubernetes/kube-controller-manager-csr.json
echo "    \"127.0.0.1\" " >> $workpath/config/ca/kubernetes/kube-controller-manager-csr.json
echo "  ]" >> $workpath/config/ca/kubernetes/kube-controller-manager-csr.json
echo "}" >> $workpath/config/ca/kubernetes/kube-controller-manager-csr.json
#
cd $workpath/config/ca/kubernetes
#使用根证书(ca.pem)签发kubernetes证书
cfssl gencert \
        -ca=$workpath/config/ca/ca.pem \
        -ca-key=$workpath/config/ca/ca-key.pem \
        -config=$workpath/config/ca/ca-config.json \
        -profile=kubernetes \
        kube-controller-manager-csr.json | cfssljson -bare kube-controller-manager
#
ls -la $workpath/config/ca/kubernetes
#
########################################################################################################
########################################################################################################
########################################################################################################
### 7. Scheduler Certificate
#准备scheduler证书配置
cat <<EOF > $workpath/config/ca/kubernetes/kube-scheduler-csr.json
{
  "CN": "system:kube-scheduler ",
  "hosts": [],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "Beijing",
      "L": "XS",
      "O": "k8s",
      "OU": "System"
    }
  ],
  "hosts": [
    "kubernetes",
    "kubernetes.default",
    "kubernetes.default.svc",
    "kubernetes.default.svc.cluster",
    "kubernetes.default.svc.cluster.local",
EOF
#
ca_arr2=$(echo $K8S_MASTER_IPs|tr "," "\n")
for ca_host2 in $ca_arr2; do
   echo  "     \"$ca_host2\"," >> $workpath/config/ca/kubernetes/kube-scheduler-csr.json
done
echo "    \"$K8S_MASTER_VIP\"," >> $workpath/config/ca/kubernetes/kube-scheduler-csr.json
echo "    \"$K8S_CLUSTER_KUBERNETES_SVC_IP\"," >> $workpath/config/ca/kubernetes/kube-scheduler-csr.json
echo "    \"127.0.0.1\" " >> $workpath/config/ca/kubernetes/kube-scheduler-csr.json
echo "  ]" >> $workpath/config/ca/kubernetes/kube-scheduler-csr.json
echo "}" >> $workpath/config/ca/kubernetes/kube-scheduler-csr.json
#
cd $workpath/config/ca/kubernetes
#使用根证书(ca.pem)签发kubernetes证书
cfssl gencert \
        -ca=$workpath/config/ca/ca.pem \
        -ca-key=$workpath/config/ca/ca-key.pem \
        -config=$workpath/config/ca/ca-config.json \
        -profile=kubernetes \
        kube-scheduler-csr.json | cfssljson -bare kube-scheduler
#
ls -la $workpath/config/ca/kubernetes
#
########################################################################################################
########################################################################################################
########################################################################################################
### 8. Master Kubelet Certificate
#
mkdir -p $workpath/config/ca/node
#
cat <<EOF > $workpath/config/ca/node/kubelet-csr.json
{
  "CN": "system:node",
  "hosts": [],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "Beijing",
      "L": "XS",
      "O": "system:node",
      "OU": "System"
    }
  ]
}
EOF
#
cd $workpath/config/ca/node
#使用根证书(ca.pem)签发node证书
cfssl gencert \
        -ca=$workpath/config/ca/ca.pem \
        -ca-key=$workpath/config/ca/ca-key.pem \
        -config=$workpath/config/ca/ca-config.json \
        -profile=kubernetes \
        kubelet-csr.json | cfssljson -bare kubelet
#我们最终要的是admin-key.pem和admin.pem
ls -la
#
########################################################################################################
########################################################################################################
########################################################################################################
### 9. kube-proxy证书
#准备proxy证书配置 - proxy只需客户端证书，因此证书请求中 hosts 字段可以为空。
#CN 指定该证书的 User 为 system:kube-proxy，预定义的 ClusterRoleBinding system:node-proxy 将User system:kube-proxy 与 Role system:node-proxier 绑定，授予了调用 kube-api-server proxy的相关 API 的权限
cat <<EOF > $workpath/config/ca/node/kube-proxy-csr.json
{
  "CN": "system:kube-proxy",
  "hosts": [],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "Beijing",
      "L": "XS",
      "O": "system:kube-proxy",
      "OU": "System"
    }
  ]
}
EOF
#
cd $workpath/config/ca/node
##使用根证书(ca.pem)签发calico证书
cfssl gencert \
        -ca=$workpath/config/ca/ca.pem \
        -ca-key=$workpath/config/ca/ca-key.pem \
        -config=$workpath/config/ca/ca-config.json \
        -profile=kubernetes \
        kube-proxy-csr.json | cfssljson -bare kube-proxy
#我们最终要的是kube-proxy-key.pem和kube-proxy.pem
ls -la
#kube-proxy.csr  kube-proxy-csr.json  kube-proxy-key.pem  kube-proxy.pem
#
########################################################################################################
########################################################################################################
########################################################################################################
### 10. kubectl证书
#kubectl证书放在这，由于kubectl相当于系统管理员，我们使用admin命名
mkdir -p $workpath/config/ca/admin
#准备admin证书配置 - kubectl只需客户端证书，因此证书请求中 hosts 字段可以为空
cat <<EOF > $workpath/config/ca/admin/admin-csr.json
{
  "CN": "system:admin",
  "hosts": [],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "Beijing",
      "L": "XS",
      "O": "system:admin",
      "OU": "System"
    }
  ]
}
EOF
#
cd $workpath/config/ca/admin
#使用根证书(ca.pem)签发admin证书
cfssl gencert \
        -ca=$workpath/config/ca/ca.pem \
        -ca-key=$workpath/config/ca/ca-key.pem \
        -config=$workpath/config/ca/ca-config.json \
        -profile=kubernetes \
        admin-csr.json | cfssljson -bare admin
#我们最终要的是admin-key.pem和admin.pem
ls -la
#admin.csr  admin-csr.json  admin-key.pem  admin.pem
#
########################################################################################################
########################################################################################################
########################################################################################################
# 11、Front Proxy Certificate
mkdir -p $workpath/config/ca/front
#准备front证书配置
cat <<EOF > $workpath/config/ca/front/front-proxy-ca-csr.json
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  }
}
EOF
#
cfssl gencert \
  -initca front-proxy-ca-csr.json | cfssljson -bare front-proxy-ca
#
cat <<EOF > $workpath/config/ca/front/front-proxy-client-csr.json
{
  "CN": "front-proxy-client",
  "key": {
    "algo": "rsa",
    "size": 2048
  }
}
EOF
#
cd $workpath/config/ca/front
#使用根证书(ca.pem)签发flannel证书
cfssl gencert \
  -ca=$workpath/config/ca/front/front-proxy-ca.pem \
  -ca-key=$workpath/config/ca/front/front-proxy-ca-key.pem \
  -config=$workpath/config/ca/ca-config.json \
  -profile=kubernetes \
  front-proxy-client-csr.json | cfssljson -bare front-proxy-client
#
ls -la $workpath/config/ca/front/
#
########################################################################################################
########################################################################################################
########################################################################################################
### 12. 生成token认证文件
#生成随机token
head -c 16 /dev/urandom | od -An -t x | tr -d ' ' > token.id
export BOOTSTRAP_TOKEN=`cat token.id`
echo "TOKEN="$BOOTSTRAP_TOKEN
#按照固定格式写入token.csv，注意替换token内容
echo "`cat token.id`,kubelet-bootstrap,10001,\"system:kubelet-bootstrap\"" > $workpath/config/ca/kubernetes/token.csv
#
#
########################################################################################################
########################################################################################################
########################################################################################################
### Service Account Key
# Service account 不是通过 CA 进行认证，因此不要通过 CA 来做 Service account key 的检查，这边建立一组 Private 与 Public 金钥提供给 Service account key 使用：
#
openssl genrsa -out sa.key 2048
openssl rsa -in sa.key -pubout -out sa.pub
mkdir -p $workpath/config/key
mv sa.pub $workpath/config/key/
mv sa.key $workpath/config/key/
ls -la $workpath/config/key/
#sa.key  sa.pub


#
echo "================="
echo "CA配置END"
#
###end###