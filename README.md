# Learnkubernetes
步骤:
1. 修改param.sh 的参数
2. 选择一个做负载均衡服务器, 执行: `bash step0_set_nginx_load_balancing.sh`
3. 选择一个服务器, 执行ca里面的 `init.sh`, 并将pem文件cp到其他主机上
4. 执行 `bash step1_prepare.sh`
5. 将生成的 `/etc/kubernetes/token.csv` cp到其他服务器上
6. 执行 `bash step2_set_etcd.sh`, 需要在所有主机上同时执行
7. 检查etcd 状态
8. 执行 `bash step3_kubernetes_master_clusters.sh`
