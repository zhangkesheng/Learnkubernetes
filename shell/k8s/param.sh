#!/bin/bash
# params
echo "set params"
isMaster=true
# 如果是master则会生成token.csv, 并且需要执行生成ca证书的脚本
# 不是则需要cp token.csv和ca证书
#mkdir -p /etc/kubernetes/ssl
#scp root@192.168.10.56:/etc/kubernetes/token.csv /etc/kubernetes/
#scp root@192.168.10.56:/etc/kubernetes/ssl/* /etc/kubernetes/ssl/
#
# clusters
host=192.168.10.56
clusters=192.168.10.56,192.168.10.57,192.168.10.58
#etcd
etcdName=infra1
etcdInitialCluster=infra1=https://192.168.10.56:2380,infra2=https://192.168.10.57:2380,infra3=https://192.168.10.58:2380
# nginx
masterHostList="server 192.168.10.56:8080;server 192.168.10.57:8080;server 192.168.10.58:8080;"
nginxLoadBalancingHost=http://192.168.10.58
nginxLoadBalancingPort=8888
# kubernetesc
k8sVersion=v1.8.4
kubeEtcdServers=https://192.168.10.56:2379,https://192.168.10.57:2379,https://192.168.10.58:2379
serviceClusterIpRange=10.254.0.0/16
kubeLogLevel=0
apiserverCount=3