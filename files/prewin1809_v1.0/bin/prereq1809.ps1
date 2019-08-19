$ErrorActionPreference = "Stop"
$reboot = $false
$regNamespace = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters'
$key = Get-ItemProperty -Path $regNamespace -Name 'DisabledComponents' -ErrorAction SilentlyContinue
if(!$key -or ($key.DisabledComponents.GetType() -ne [UInt32] -or $key.DisabledComponents -ne [Uint32]'0xffffffff')) {
    Remove-ItemProperty -Path $regNamespace -Name 'DisabledComponents' -ErrorAction SilentlyContinue
    Write-Output "Disabling IPv6"
    New-ItemProperty -Path $regNamespace -Name 'DisabledComponents' -Value '0xffffffff' -PropertyType 'DWord'
    $reboot = $true
}
$status = Get-WindowsFeature -Name "Hyper-V"
if($status.InstallState -eq "Installed") {
    Remove-WindowsFeature "Hyper-V"
    bcdedit.exe /set hypervisorlaunchtype off
    if($LASTEXITCODE) {
        Throw "Failed to set bcd setting hypervisorlaunchtype to off"
    }
}
if($env:COMPUTERNAME -ne $env:kubernetes_io_hostname) {
    Write-Output "Renaming the computer to $env:kubernetes_io_hostname"
    Rename-Computer -NewName $env:kubernetes_io_hostname -Force -Confirm:$false
    $reboot = $true
}
Write-Output "Installing the required Windows features"
$state = Install-WindowsFeature -Name "Containers" -Confirm:$false -ErrorAction Stop
if($state.Success -ne $true) {
    Throw "Failed to install Containers Windows feature"
}
if($state.RestartNeeded -eq "Yes") {
    $reboot = $true
}
Write-Output "Installing all the available Windows updates"
Install-Package PSWindowsUpdate -Force
$updates = Get-WUInstall -AcceptAll -IgnoreReboot
$updates | ForEach-Object {
    if($_.RebootRequired) {
        $reboot = $true
    }
}
$env:item = "C:\bin"
$systemPath = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") -split ';'
if($env:item -notin $systemPath) {
  $systemPath += $env:item
  [System.Environment]::SetEnvironmentVariable("PATH", ($systemPath -join ';'), "Machine")
  }
$env:item = ${env:ProgramFiles} + "\Cloudbase Solutions\Open vSwitch\bin\"
New-Item -ItemType Directory -Force -Path $env:item
$systemPath = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") -split ';'
if($env:item -notin $systemPath) {
  $systemPath += $env:item
  [System.Environment]::SetEnvironmentVariable("PATH", ($systemPath -join ';'), "Machine")
  }
# Fixup firewall rules
$ErrorActionPreference = "Stop"
$name = "kubelet"
$rule = Get-NetFirewallRule -Name $name -ErrorAction SilentlyContinue
if($rule) {
    # Delete existing rule if found
    Remove-NetFirewallRule -InputObject $rule
    }
New-NetFirewallRule -Name $name -DisplayName 'Kubernetes Node' `
                    -Enabled True -Direction Inbound `
                    -Protocol TCP -Action Allow -LocalPort 10250
#Add port 6081 to windows firewall rules
$ErrorActionPreference = "Stop"
$name = "ovn.6081"
$rule = Get-NetFirewallRule -Name $name -ErrorAction SilentlyContinue
if($rule) {
    # Delete existing rule if found
    Remove-NetFirewallRule -InputObject $rule
    }
New-NetFirewallRule -Name $name -DisplayName $name -Enabled True `
                    -Direction Inbound -Protocol UDP -Action Allow -LocalPort 6081

# Reboot if needed
if($reboot) {
    Write-Output "Rebooting computer"
    Shutdown -r -f -t 0
    Start-Sleep -s 60
}

