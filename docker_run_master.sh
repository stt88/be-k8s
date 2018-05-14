#!/bin/bash
#
#
#
#
#master节点启动apiServer
docker run -d --name=apiserver01 --net=host  gcr.io/google_containers/kube-apiserver:7bf05b2d35172296e4fbd2604362456f \
  kube-apiserver --insecure-bind-address=192.168.2.143 --service-cluster-ip-range=10.0.0.0/16 --etcd-servers=http://192.168.2.143:4001
#
#master节点启动ControllerManager
docker run -d --name=ControllerM  gcr.io/google_containers/kube-controller-manager:6c95ef0b57ac9deda34ae1a4a40baa0a \
  kube-controller-manager --master=192.168.2.143:8080
#
#master节点启动Scheduler
docker run -d --name=scheduler    gcr.io/google_containers/kube-scheduler:e5342c3d8ced06850af97347daf6ae4b \
  kube-scheduler --master=192.168.2.143:8080
#
#
#
###end###




