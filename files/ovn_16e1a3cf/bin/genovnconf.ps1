sleep 5
$Env:hosttoken = [IO.File]::ReadAllText("C:\Program Files\WindowsNodeManager\data\ovn.key")
$Env:hosttoken = $Env:hosttoken -replace "`t|`n|`r",""
$Env:apiserver="https://${Env:master}:8443"
$Env:ovnnorth="tcp://${Env:masterip}:6641"
$Env:ovnsouth="tcp://${Env:masterip}:6642"
cd \cni
Get-Content ovn_k8s.conf.template | ForEach-Object { $ExecutionContext.InvokeCommand.ExpandString($_) } > ovn_k8s.conf.x
Get-Content .\ovn_k8s.conf.x | set-Content -Encoding Ascii ovn_k8s.conf
del .\ovn_k8s.conf.x
