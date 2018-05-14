#!/bin/bash
#
# k8s生产环境安装:kubectl配置
#
echo "================="
echo "Kube配置START."
#
#
### kubectl(admin):
# 指定apiserver的地址和证书位置（ip自行修改）
$BIN_PATH/kubectl config set-cluster kubernetes \
    --certificate-authority=$workpath/config/ca/ca.pem \
    --embed-certs=true \
    --server=${KUBE_APISERVER} \
    --kubeconfig=$workpath/config/conf/kube-admin.conf
# 设置客户端认证参数，指定admin证书和秘钥
$BIN_PATH/kubectl config set-credentials system:admin \
    --client-certificate=$workpath/config/ca/admin/admin.pem \
    --client-key=$workpath/config/ca/admin/admin-key.pem \
    --embed-certs=true \
    --kubeconfig=$workpath/config/conf/kube-admin.conf
# 关联用户和集群
$BIN_PATH/kubectl config set-context system:admin@kubernetes \
    --cluster=kubernetes \
    --user=system:admin \
    --kubeconfig=$workpath/config/conf/kube-admin.conf
# 设置当前上下文
$BIN_PATH/kubectl config use-context system:admin@kubernetes \
    --kubeconfig=$workpath/config/conf/kube-admin.conf
#设置结果就是一个配置文件，可以看看内容
cat $workpath/config/conf/kube-admin.conf
#
#
### kube-controller-manager:
# controller-manager set cluster
$BIN_PATH/kubectl config set-cluster kubernetes \
    --certificate-authority=$workpath/config/ca/ca.pem \
    --embed-certs=true \
    --server=${KUBE_APISERVER} \
    --kubeconfig=$workpath/config/conf/kube-controller-manager.conf
# controller-manager set credentials
$BIN_PATH/kubectl config set-credentials system:kube-controller-manager \
    --client-certificate=$workpath/config/ca/kubernetes/kube-controller-manager.pem \
    --client-key=$workpath/config/ca/kubernetes/kube-controller-manager-key.pem \
    --embed-certs=true \
    --kubeconfig=$workpath/config/conf/kube-controller-manager.conf
# controller-manager set context
$BIN_PATH/kubectl config set-context system:kube-controller-manager@kubernetes \
    --cluster=kubernetes \
    --user=system:kube-controller-manager \
    --kubeconfig=$workpath/config/conf/kube-controller-manager.conf
# controller-manager set default context
$BIN_PATH/kubectl config use-context system:kube-controller-manager@kubernetes \
    --kubeconfig=$workpath/config/conf/kube-controller-manager.conf
#
#
#
### Scheduler Certificate
# controller-manager set cluster
$BIN_PATH/kubectl config set-cluster kubernetes \
    --certificate-authority=$workpath/config/ca/ca.pem \
    --embed-certs=true \
    --server=${KUBE_APISERVER} \
    --kubeconfig=$workpath/config/conf/kube-scheduler.conf
# controller-manager set credentials
$BIN_PATH/kubectl config set-credentials system:kube-scheduler \
    --client-certificate=$workpath/config/ca/kubernetes/kube-scheduler.pem \
    --client-key=$workpath/config/ca/kubernetes/kube-scheduler-key.pem \
    --embed-certs=true \
    --kubeconfig=$workpath/config/conf/kube-scheduler.conf
# controller-manager set context
$BIN_PATH/kubectl config set-context system:kube-scheduler@kubernetes \
    --cluster=kubernetes \
    --user=system:kube-scheduler \
    --kubeconfig=$workpath/config/conf/kube-scheduler.conf
# controller-manager set default context
$BIN_PATH/kubectl config use-context system:kube-scheduler@kubernetes \
    --kubeconfig=$workpath/config/conf/kube-scheduler.conf
#
#
#
### kubelet.conf
# controller-manager set cluster
$BIN_PATH/kubectl config set-cluster kubernetes \
    --certificate-authority=$workpath/config/ca/ca.pem \
    --embed-certs=true \
    --server=${KUBE_APISERVER} \
    --kubeconfig=$workpath/config/conf/kubelet.conf
#  set credentials
$BIN_PATH/kubectl config set-credentials system:node \
    --client-certificate=$workpath/config/ca/node/kubelet.pem \
    --client-key=$workpath/config/ca/node/kubelet-key.pem \
    --embed-certs=true \
    --kubeconfig=$workpath/config/conf/kubelet.conf
#  set context
$BIN_PATH/kubectl config set-context system:node@kubernetes \
    --cluster=kubernetes \
    --user=system:node \
    --kubeconfig=$workpath/config/conf/kubelet.conf
# set default context
$BIN_PATH/kubectl config use-context system:node@kubernetes \
    --kubeconfig=$workpath/config/conf/kubelet.conf
#

#
#
echo "================="
echo "Kube配置END."
###end###