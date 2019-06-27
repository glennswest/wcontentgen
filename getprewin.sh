rm -r -f wip
mkdir wip
mkdir wip/bin
mkdir wip/bin/metadata
export VERSION=v1.0
export COMPNAME=prewin1809
echo $VERSION
echo $COMPNAME
export wcontent=${GOPATH}/src/github.com/glennswest/winoperatordata/wcontent
rm ${wcontent}/content/${COMPNAME}_${VERSION}.ign
cp metadata/${COMPNAME}_${VERSION}.metadata wip/bin/metadata
cp files/${COMPNAME}_${VERSION}/bin/*.ps1 wip/bin
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ${wcontent}/content/${COMPNAME}_${VERSION}.ign bin)
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool um ${wcontent}/content/${COMPNAME}_${VERSION}.ign bin/metadata/${COMPNAME}_${VERSION}.metadata)
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ${wcontent}/content/${COMPNAME}_${VERSION}.ign bin/metadata)
$GOPATH/src/github.com/glennswest/libignition/igntool/igntool ls ${wcontent}/content/${COMPNAME}_${VERSION}.ign
cat wip/bin/metadata/${COMPNAME}_${VERSION}.metadata
./mvtocontainer.sh
