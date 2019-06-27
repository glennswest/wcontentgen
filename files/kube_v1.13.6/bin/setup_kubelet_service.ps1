$powershell = (Get-Command powershell).Source
$scriptPath = "C:\bin\start_kubelet.ps1"
$arguments = '-ExecutionPolicy Bypass -NoProfile -File "{0}"' -f $scriptPath
$serviceName = "kubelet-ocp"
nssm install $serviceName $powershell $arguments
nssm set ${serviceName} DisplayName kubelet-ocp
nssm set ${serviceName} Description Kubelet For OpenShift
nssm set ${serviceName} Start SERVICE_AUTO_START
nssm set ${serviceName} AppStdout C:\k\logs\kubelet.log
nssm set ${serviceName} AppStderr C:\k\logs\kubelet.log
nssm set ${serviceName} AppRotateFiles 1
nssm set ${serviceName} AppRotateOnline 1
nssm set ${serviceName} AppRotateSeconds 86400
nssm set ${serviceName} AppRotateBytes 1048576
Start-Service kubelet-ocp
