$powershell = (Get-Command powershell).Source
$scriptPath = "C:\bin\start_kubelet.ps1"
$arguments = '-ExecutionPolicy Bypass -NoProfile -File "{0}"' -f $scriptPath
$serviceName = "kubelet-ocp"
nssm install $serviceName $powershell $arguments
nssm set ocpkubelet DisplayName kubelet-ocp
nssm set ocpkubelet Description Kubelet For OpenShift
nssm set ocpkubelet Start SERVICE_AUTO_START
nssm set ocpkubelet AppStdout C:\k\logs\kubelet.log
nssm set ocpkubelet AppStderr C:\k\logs\kubelet.log
nssm set ocpkubelet AppRotateFiles 1
nssm set ocpkubelet AppRotateOnline 1
nssm set ocpkubelet AppRotateSeconds 86400
nssm set ocpkubelet AppRotateBytes 1048576
