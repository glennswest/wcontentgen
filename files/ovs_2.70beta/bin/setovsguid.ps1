sleep 10
$GUID = (New-Guid).Guid; Write-Output $GUID
ovs-vsctl --db="unix:C:/ProgramData/openvswitch/db.sock" set Open_vSwitch . external_ids:system-id=$guid


