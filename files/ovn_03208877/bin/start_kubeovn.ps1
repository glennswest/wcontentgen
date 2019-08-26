C:\bin\ovnkube.exe --init-node $env:COMPUTERNAME.ToLower() `
                   -k8s-kubeconfig="C:\Users\Administrator\.kube\config" `
                   --config-file "C:\cni\ovn_k8s.conf" `
                   -cluster-subnet 10.128.0.0/14/23 `
                   -cni-conf-dir="C:\cni" `
                   --nodeport `
                   --k8s-service-cidr=172.30.0.0/16 `
                   --loglevel=4 `
                   --gateway-mode=local



