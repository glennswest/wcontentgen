$Env:lhost=$Env:COMPUTERNAME.ToLower()
echo $Env:lhost
c:\bin\kubelet.exe --hostname-override="$Env:lhost" --v=6 `
    --resolv-conf="" `
     --log-dir /k/logs `
    --enable-debugging-handlers `
    --cluster-domain=cluster.local `
    --hairpin-mode=promiscuous-bridge `
    --image-pull-progress-deadline=20m `
    --cgroups-per-qos=false `
    --enforce-node-allocatable="" `
    --pod-infra-container-image=kubeletwin/pause:latest `
    --network-plugin=cni `
    --cni-bin-dir="c:\bin" `
    --cni-conf-dir "c:\cni" `
    --config=/etc/kubernetes/kubelet.conf `
    --bootstrap-kubeconfig=/etc/kubernetes/kubeconfig `
    --kubeconfig=/var/lib/kubelet/kubeconfig `
    --allow-privileged `
    --minimum-container-ttl-duration=6m0s `
    --client-ca-file=/etc/kubernetes/ca.crt `
    --anonymous-auth=false `
    --v=3 `
    --root-dir="/" `
    --cert-dir="c:/var/lib/kubelet/pki/" `
    --container-runtime-endpoint="tcp://localhost:3735"
