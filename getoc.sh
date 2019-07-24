rm -r -f wip
mkdir wip
mkdir wip/bin
mkdir wip/bin/metadata
mkdir wip/k
mkdir wip/k/tmp
export VERSION=v4.1.4
export COMPNAME=oc
export KUBEURL=https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-windows-4.1.4.zip
cp files/${COMPNAME}_${VERSION}/bin/* wip/bin
rm wcontent/content/${COMPNAME}_$VERSION.ign
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool ar ../wcontent/content/${COMPNAME}_$VERSION.ign ${KUBEURL} /k/tmp/oc.zip )
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ../wcontent/content/${COMPNAME}_$VERSION.ign bin)
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ../wcontent/content/${COMPNAME}_$VERSION.ign k)
cp metadata/${COMPNAME}_${VERSION}.metadata wip/bin/metadata/${COMPNAME}_${VERSION}.metadata
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool um ../wcontent/content/${COMPNAME}_${VERSION}.ign bin/metadata/${COMPNAME}_${VERSION}.metadata)
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ../wcontent/content/${COMPNAME}_${VERSION}.ign bin/metadata)
$GOPATH/src/github.com/glennswest/libignition/igntool/igntool ls wcontent/content/${COMPNAME}_${VERSION}.ign
cat wip/bin/metadata/${COMPNAME}_${VERSION}.metadata
./mvtocontainer.sh
