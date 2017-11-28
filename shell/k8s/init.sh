#!/bin/bash
# params
echo "set params"
host=192.168.10.56
clusters=192.168.10.56,192.168.10.57,192.168.10.58
k8sVersion=v1.8.4

# export
echo "export env"
## 翻墙
export http_proxy=http://192.168.32.10:6780
export https_proxy=http://192.168.32.10:6780
export no_proxy=".aliyun.com,.aliyuncs.com,.daocloud.io,localhost,$host"
echo "http_proxy: $http_proxy"
echo "https_proxy: $https_proxy"
echo "no_proxy: $no_proxy"

#bash
echo "run shell"
bash prepare.sh $clusters
bash kubectl.sh $k8sVersion $host
