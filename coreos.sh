#!/bin/bash
#
# coreos配置docker、etcd、flannel
#
echo "================="
echo "Coreos配置dokcer、etcd、flannel START:"
#
#
#配置dokcer
systemctl enable docker
cd /etc/systemd/system/multi-user.target.wants
mv docker.service{,.bak}
cp /etc/systemd/system/docker.service.bak  /etc/systemd/system/docker.service
cat /etc/systemd/system/docker.service
sed  -i  '/^ExecStart=/s/$/& --registry-mirror=https:\/\/j9fztnej.mirror.aliyuncs.com --data-root=\/data\/docker\/lib/' /etc/systemd/system/docker.service
cat /etc/systemd/system/docker.service
systemctl daemon-reload
systemctl restart docker
docker volume rm $(docker volume ls -qf dangling=true)
#
#配置etcd-member
systemctl disable etcd-member
systemctl stop etcd-member
rm -rf /data/lib/etcd
#
#配置flanneld
systemctl disable flanneld
systemctl stop flanneld
rm -rf /data/lib/flanneld
cat /run/flannel/options.env

### 附注：==========================================
#查看容器重启次数
#docker inspect -f "{{ .RestartCount }}" 容器名
#查看容器最后一次的启动时间
#docker inspect -f "{{ .State.StartedAt }}" 容器名
#停止所有容器
#docker stop $(docker ps -a -q)
#删除所有容器
#docker rm $(docker ps -a -q)
#删除所有dangling数据卷（即无用的Volume）：
#docker volume rm $(docker volume ls -qf dangling=true)
#获取所有容器名称及其IP地址
#docker inspect -f '{{.Name}} - {{.NetworkSettings.IPAddress }}' $(docker ps -aq)


#
#
echo "================="
echo "Coreos配置dokcer、etcd、flannel END."
###end###