rm -r -f wip
mkdir wip
mkdir wip/bin
mkdir wip/bin/metadata
mkdir wip/k
mkdir wip/k/logs
touch wip/k/logs/kubelet.log
export VERSION=v1.13.6
export COMPNAME=kube
export wcontent=${GOPATH}/src/github.com/glennswest/winoperatordata/wcontent
export KUBEURL=https://dl.k8s.io/${VERSION}/kubernetes-node-windows-amd64.tar.gz 
cp files/${COMPNAME}_${VERSION}/bin/* wip/bin
rm ${wcontent}/content/${COMPNAME}_$VERSION.ign
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool ar ${wcontent}/content/${COMPNAME}_$VERSION.ign ${KUBEURL} /k/tmp/kubernets.tar.gz )
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ${wcontent}/content/${COMPNAME}_$VERSION.ign bin)
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ${wcontent}/content/${COMPNAME}_$VERSION.ign k)
cp metadata/${COMPNAME}_${VERSION}.metadata wip/bin/metadata/${COMPNAME}_${VERSION}.metadata
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool um ${wcontent}/content/${COMPNAME}_${VERSION}.ign bin/metadata/${COMPNAME}_${VERSION}.metadata)
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ${wcontent}/content/kube_${VERSION}.ign bin/metadata)
$GOPATH/src/github.com/glennswest/libignition/igntool/igntool ls ${wcontent}/content/${COMPNAME}_${VERSION}.ign
cat wip/bin/metadata/${COMPNAME}_${VERSION}.metadata
./mvtocontainer.sh
