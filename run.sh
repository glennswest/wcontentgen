git pull
export GIT_COMMIT=$(git rev-parse --short HEAD)
echo $GIT_COMMIT
export pname=winoperatordata
oc delete dc $pname
oc delete is $pname
oc delete sa $pname
oc delete project $pname
sleep 30
oc new-project $pname
sleep 10
oc project $pname
oc import-image $pname --from=docker.io/glennswest/$pname:$GIT_COMMIT --confirm
oc delete  istag/$pname:latest
oc new-app glennswest/$pname:$GIT_COMMIT --token=$(oc sa get-token $pname) 
export defaultdomain=$(oc describe --namespace=openshift-ingress-operator ingresscontroller/default | grep "Domain:" | cut -d ":" -f 2 | cut -d "." -f 1- | tr -d ' ')
oc expose svc/winoperatordata --hostname=winoperatordata.$defaultdomain
