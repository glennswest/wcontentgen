$Env:hosttoken = [IO.File]::ReadAllText("C:\Program Files\WIndowsNodeManager\data\ovn.key")
$Env:apiserver="https://${Env:master}:8443"
$Env:ovnnorth="tcp://${Env:masterip}:6641"
$Env:ovnsouth="tcp://${Env:masterip}:6642"
Get-Content \cni\ovn_k8s.conf.template | ForEach-Object { $ExecutionContext.InvokeCommand.ExpandString($_) } > ovn_k8s.conf
