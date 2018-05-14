#!/bin/bash
#
#
#
echo "================="
echo "docker导入镜像START."
#
#
docker build -f /etc/kubernetes/dockerfile/alpine.dockerfile -t stt/alpine:latest /etc/kubernetes/dockerfile/
docker build -f /etc/kubernetes/dockerfile/alpine.dockerfile -t stt/alpine:3.7 /etc/kubernetes/dockerfile/
docker build -f /etc/kubernetes/dockerfile/alpine-glibc.dockerfile -t stt/alpine-glibc  /etc/kubernetes/dockerfile/
docker build -f /etc/kubernetes/dockerfile/alpine-ssh.dockerfile -t stt/alpine-ssh  /etc/kubernetes/dockerfile/
docker build -f /etc/kubernetes/dockerfile/alpine-glibc-ssh.dockerfile -t stt/alpine-glibc-ssh  /etc/kubernetes/dockerfile/
#
docker build -f /etc/kubernetes/dockerfile/alpine-etcd.dockerfile -t stt/etcd:v3.3.4  /etc/kubernetes/dockerfile/
docker build -f /etc/kubernetes/dockerfile/alpine-flannel.dockerfile -t stt/flannel:v0.10.0  /etc/kubernetes/dockerfile/
#
docker pull quay.io/coreos/flannel:v0.10.0-amd64
#
#
echo "================="
echo "docker导入镜像END."
