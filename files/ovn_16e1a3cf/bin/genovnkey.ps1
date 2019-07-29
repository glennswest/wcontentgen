oc create serviceaccount ovn
oc adm policy add-scc-to-user privileged -z ovn
oc adm policy add-cluster-role-to-user cluster-admin -z ovn
oc sa get-token ovn > C:\Program Files\WindowsNodeManager\data\ovn.key
