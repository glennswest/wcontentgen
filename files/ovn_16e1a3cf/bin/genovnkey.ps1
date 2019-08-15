oc create serviceaccount ovn
oc adm policy add-scc-to-user privileged -z ovn
oc adm policy add-cluster-role-to-user cluster-admin -z ovn
New-Item -path "C:\Program Files\WindowsNodeManager\data" -type directory
oc sa get-token ovn | Out-File  C:\Program Files\WindowsNodeManager\data\ovn.key
