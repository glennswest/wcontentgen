rm -r -f wip
mkdir wip
mkdir wip/bin
mkdir wip/bin/metadata
mkdir wip/k
mkdir wip/k/logs
mkdir wip/cni
touch wip/k/logs/kubeovn.log
export COMPNAME=ovn
git clone https://github.com/glennswest/ovn-kubernetes  wip/ovn-kubernetes
cd wip/ovn-kubernetes;export VERSION=`git rev-parse --short HEAD`;cd ../..
(cd wip/ovn-kubernetes;cd go-controller;make clean;make windows)
cp wip/ovn-kubernetes/go-controller/_output/go/windows/*.exe wip/bin
echo $VERSION
echo $COMPNAME
rm wcontent/content/${COMPNAME}_${VERSION}.ign
cp metadata/${COMPNAME}_${VERSION}.metadata wip/bin/metadata
cp files/${COMPNAME}_${VERSION}/bin/*.ps1 wip/bin
cp files/${COMPNAME}_${VERSION}/cni/* wip/cni
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a wcontent/content/${COMPNAME}_${VERSION}.ign bin)
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a wcontent/content/${COMPNAME}_${VERSION}.ign cni)
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a wcontent/content/${COMPNAME}_${VERSION}.ign k)
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool um wcontent/content/${COMPNAME}_${VERSION}.ign bin/metadata/${COMPNAME}_${VERSION}.metadata)
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a wcontent/content/${COMPNAME}_${VERSION}.ign bin/metadata)
$GOPATH/src/github.com/glennswest/libignition/igntool/igntool ls wcontent/content/${COMPNAME}_${VERSION}.ign
cat wip/bin/metadata/${COMPNAME}_${VERSION}.metadata
./mvtocontainer.sh
