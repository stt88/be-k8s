#!/bin/bash
#
#
# SSH免密登录
# config ssh
#
ssh-keygen -t rsa
ssh-copy-id root@92.168.111.104
chmod 700 /root/.ssh
chmod 700 /home/core/.ssh
chmod 600 /root/.ssh/authorized_keys
chmod 600 /home/core/.ssh/authorized_keys
chmod 600 /root/.ssh/id_rsa
chmod 600 /home/core/.ssh/id_rsa
chown -R core:core /home/core/.ssh
#
#
###end###




