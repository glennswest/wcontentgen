sleep 5
$Env:hosttoken = [IO.File]::ReadAllText("C:\Program Files\WindowsNodeManager\data\ovn.key")
$masterpod = (oc project openshift-ovn-kubernetes | oc get pods | Select-String -Pattern  master | % {$_ -replace("`r`n","`n")} | %{ $_-split(" ") } |select-object -first 1)
$OVNHOSTID=(oc get pod/$masterpod -o=go-template='{{ .status.hostIP }}')
$Env:hosttoken = $Env:hosttoken -replace "`t|`n|`r",""
$Env:apiserver="https://${OVNHOSTID}:6443"
$Env:ovnnorth="tcp://${OVNHOSTID}:6641"
$Env:ovnsouth="tcp://${OVNHOSTID}:6642"
cd \cni
Get-Content ovn_k8s.conf.template | ForEach-Object { $ExecutionContext.InvokeCommand.ExpandString($_) } > ovn_k8s.conf.x
Get-Content .\ovn_k8s.conf.x | set-Content -Encoding Ascii ovn_k8s.conf
del .\ovn_k8s.conf.x
