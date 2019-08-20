rm -r -f wip
mkdir wip
mkdir wip/bin
mkdir wip/k
mkdir wip/k/data
mkdir wip/bin/metadata
export VERSION=2.70beta
export COMPNAME=ovs
export wcontent=${GOPATH}/src/github.com/glennswest/winoperatordata/wcontent
echo $VERSION
echo $COMPNAME
rm ${wcontent}/content/${COMPNAME}_${VERSION}.ign
cp metadata/${COMPNAME}_${VERSION}.metadata wip/bin/metadata
cp files/${COMPNAME}_${VERSION}/bin/*.ps1 wip/bin
cp files/${COMPNAME}_${VERSION}/k/data/* wip/k/data/
#wget https://cloudbase.it/downloads/openvswitch-hyperv-installer-beta.msi -O wip/bin/openvswitch-hyperv-installer-beta.msi
# Temp to try this version
wget https://cloudbase.it/downloads/openvswitch-hyperv-2.7.0-certified.msi -O wip/bin/openvswitch-hyperv-installer-beta.msi
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ${wcontent}/content/${COMPNAME}_${VERSION}.ign bin)
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ${wcontent}/content/${COMPNAME}_${VERSION}.ign k)
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool um ${wcontent}/content/${COMPNAME}_${VERSION}.ign bin/metadata/${COMPNAME}_${VERSION}.metadata)
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ${wcontent}/content/${COMPNAME}_${VERSION}.ign bin/metadata)
$GOPATH/src/github.com/glennswest/libignition/igntool/igntool ls ${wcontent}/content/${COMPNAME}_${VERSION}.ign
cat wip/bin/metadata/${COMPNAME}_${VERSION}.metadata
./mvtocontainer.sh
