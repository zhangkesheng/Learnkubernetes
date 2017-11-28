#!/bin/bash
# 重新启动所有etcd服务
# 停止并删除工作目录的member文件夹
systemctl stop etcd.service
systemctl disable etcd.service
rm -r /var/lib/etcd/member/
# 重新启动etcd集群
systemctl daemon-reload
systemctl enable etcd
systemctl start etcd
systemctl status etcd
