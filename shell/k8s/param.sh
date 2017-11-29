#!/bin/bash
# params
echo "set params"
host=192.168.10.56
clusters=192.168.10.56,192.168.10.57,192.168.10.58
k8sVersion=v1.8.4
etcdName=infra1
etcdInitialCluster=infra1=https://192.168.10.56:2380,infra2=https://192.168.10.57:2380,infra3=https://192.168.10.58:2380
masterHostList="server 192.168.10.56:8080;server 192.168.10.57:8080;server 192.168.10.58:8080;"
nginxLoadBalancingHost=http://192.168.10.58
nginxLoadBalancingPort=8888