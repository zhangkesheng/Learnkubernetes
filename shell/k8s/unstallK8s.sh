#!/bin/bash
# 一键删除k8s安装记录
rm -R /etc/kubernetes
rm -R /var/lib/etcd
rm -R /home/zks
rm /usr/bin/kube*
rm /usr/bin/etcd*
rm /etc/systemd/system/etcd.service
rm /etc/systemd/system/kube-apiserver.service
rm /etc/systemd/system/kube-controller-manager.service
rm /etc/systemd/system/kube-scheduler.service
export KUBE_APISERVER=
systemctl disable etcd,kube-apiserver,kube-controller-manager,kube-scheduler

