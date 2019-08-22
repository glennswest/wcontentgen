Param(
    [Parameter(Mandatory=$true)]
    [string]$SubnetFile,
    [Parameter(Mandatory=$false)]
    [string]$OVSNetworkName="external",
    [Parameter(Mandatory=$false)]
    [int]$OVSCmdTimeout=30
)

$ErrorActionPreference = 'SilentlyContinue'


function Get-NetworkInfo {
    if(!(Test-Path $SubnetFile)) {
        Throw "The subnet file $SubnetFile doesn't exist"
    }
    $subnet = Get-Content $SubnetFile -Raw | ConvertFrom-Json
    if(!($subnet -is [string])) {
        Throw "The content from file $SubnetFile is not a string: $subnet"
    }
    $splitSubnet = $subnet.Split('/')
    if($splitSubnet.Count -ne 2) {
        Throw "The subnet format from file is incorrect: $subnet"
    }
    $net = $splitSubnet[0].Split('.')
    $gateway = "{0}.{1}.{2}.{3}" -f @($net[0], $net[1], $net[2], "1")
    return @{
        "subnet" = $subnet
        "gateway" = $gateway
    }
}

function New-OVSNetwork {
    $primaryIfIndex = (Get-NetRoute -DestinationPrefix "0.0.0.0/0").ifIndex
    $mainInterface = Get-NetAdapter -InterfaceIndex $primaryIfIndex
    [array]$networks = Get-HnsNetwork | Where-Object {
        ($_.Name -eq $OVSNetworkName) -and ($_.Type -eq "Transparent")
    }
    if($networks) {
        if($networks.Count -gt 1) {
            # If we reach this, something weird happened
            Throw "More than one OVS network was found"
        }
        $adapterName = $networks[0].NetworkAdapterName
        # Clean up existing network to refresh its subnet and gateway values
        $networks | Remove-HnsNetwork
    } else {
        $adapterName = $mainInterface.InterfaceAlias
    }
    $netInfo = Get-NetworkInfo
    $net = New-HnsNetwork -Name $OVSNetworkName -Type "Transparent" -AdapterName $adapterName `
                          -AddressPrefix $netInfo["subnet"] -Gateway $netInfo["gateway"]
    # Check if the virtual adapter is present post HNS network creation
    $virtualAdapterName = "vEthernet ($($net.NetworkAdapterName))"
    $adapter = Get-NetAdapter -Name $virtualAdapterName -ErrorAction SilentlyContinue
    if(!$adapter) {
        Throw "The virtual adapter $virtualAdapterName doesn't exist post HNS network creation"
    }
    return $net
}


try {
    Import-Module HostNetworkingService
    Import-Module HNSHelper -DisableNameChecking
    Import-Module OVS -DisableNameChecking

    echo "New-OVSNetwork"
    $net = New-OVSNetwork
    echo "Disable ovs-vswitchd"
    Set-Service "ovs-vswitchd" -StartupType Disabled
    echo "Stop Service ovs-vswitchd"
    Stop-Service "ovs-vswitchd" -Force -ErrorAction SilentlyContinue
    echo "Disable OVSOnHNSNetwork"
    echo $net.ID
    Disable-OVSOnHNSNetwork $net.ID
    $bridgeName = "vEthernet ($($net.NetworkAdapterName))"
    ovs-vsctl.exe --db="unix:C:/ProgramData/openvswitch/db.sock" --timeout $OVSCmdTimeout --if-exists --no-wait del-br "$bridgeName"
    if($LASTEXITCODE) {
        Throw "Failed to cleanup existing OVS bridge"
    }
    ovs-vsctl.exe --db="unix:C:/ProgramData/openvswitch/db.sock" --timeout $OVSCmdTimeout --no-wait --may-exist add-br "$bridgeName"
    if($LASTEXITCODE) {
        Throw "Failed to add the OVS bridge"
    }
    ovs-vsctl.exe --db="unix:C:/ProgramData/openvswitch/db.sock" --timeout $OVSCmdTimeout --no-wait --may-exist add-port "$bridgeName" "$($net.NetworkAdapterName)"
    if($LASTEXITCODE) {
        Throw "Failed to add the HNS interface to OVS bridge"
    }
    echo "Enable OVSOnHNS Network"
    Enable-OVSOnHNSNetwork $net.ID
    Set-Service "ovs-vswitchd" -StartupType Automatic
    echo "Start Service - ovs"
    Start-Service "ovs-vswitchd"
    Write-Output "The SDN network setup is ready"
} catch {
    Write-Output $_.ScriptStackTrace
    echo $null >> /k/tmp/sdn_v1.0.1.done
    exit 1
}
echo $null >> /k/tmp/sdn_v1.0.1.done
exit 0
