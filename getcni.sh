export VERSION=0.3.1
export COMPNAME=cni
echo $VERSION
echo $COMPNAME
rm -r -f wip
mkdir wip
mkdir wip/bin
mkdir wip/bin/metadata
export wcontent=${GOPATH}/src/github.com/glennswest/wcontent
rm ${wcontent}/content/${COMPNAME}_${VERSION}.ign
cp metadata/${COMPNAME}_${VERSION}.metadata wip/bin/metadata
cp files/${COMPNAME}_${VERSION}/bin/*.ps1 wip/bin
mkdir wip/cni
touch wip/cni/10-ovn-kubernetes.conf
cat > wip/cni/10-ovn-kubernetes.conf << EOL
{"cniVersion":"0.3.1","name":"ovn-kubernetes","type":"ovn-k8s-cni-overlay","ipam":{},"dns":{}}
EOL
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ${wcontent}/content/${COMPNAME}_${VERSION}.ign bin)
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ${wcontent}/content/${COMPNAME}_${VERSION}.ign cni)
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool um ${wcontent}/content/${COMPNAME}_${VERSION}.ign bin/metadata/${COMPNAME}_${VERSION}.metadata)
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ${wcontent}/content/${COMPNAME}_${VERSION}.ign bin/metadata)
$GOPATH/src/github.com/glennswest/libignition/igntool/igntool ls ${wcontent}/content/${COMPNAME}_${VERSION}.ign
cat wip/bin/metadata/${COMPNAME}_${VERSION}.metadata
export wdir=`pwd`
cd ${wcontent}
git add content/${COMPNAME}_${VERSION}.ign
git commit -a -m "$1"
git push origin master
cd $wdir

