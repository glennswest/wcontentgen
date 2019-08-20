$ErrorActionPreference = "Stop"
$env:item = ${env:ProgramFiles} + "\Cloudbase Solutions\Open vSwitch\bin\"
$systemPath = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") -split ';'
if($env:item -notin $systemPath) {
  $systemPath += $env:item
  [System.Environment]::SetEnvironmentVariable("PATH", ($systemPath -join ';'), "Machine")
  }
Set-Service -Name ovsdb-server -StartupType Automatic
Start-Service ovsdb-server
$GUID = (New-Guid).Guid; Write-Output $GUID
ovs-vsctl --db="unix:C:/ProgramData/openvswitch/db.sock" set Open_vSwitch . external_ids:system-id=$guid


