rm -r -f wip/bin
mkdir wip/bin
mkdir wip/bin/metadata
mkdir wip/k
mkdir wip/k/pause
export VERSION=v1.0.1
export COMPNAME=pause
export wcontent=${GOPATH}/src/github.com/glennswest/winoperatordata/wcontent
cp files/${COMPNAME}_${VERSION}/bin/*.ps1 wip/bin
cp files/${COMPNAME}_${VERSION}/k/pause/* wip/k/pause
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ${wcontent}/content/${COMPNAME}_${VERSION}.ign bin)
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ${wcontent}/content/${COMPNAME}_${VERSION}.ign k/pause)
cp metadata/${COMPNAME}_$VERSION.metadata wip/bin/metadata/${COMPNAME}_${VERSION}.metadata
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool um ${wcontent}/content/${COMPNAME}_$VERSION.ign bin/metadata/${COMPNAME}_${VERSION}.metadata)
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ${wcontent}/content/${COMPNAME}_$VERSION.ign bin/metadata)
$GOPATH/src/github.com/glennswest/libignition/igntool/igntool ls ${wcontent}/content/${COMPNAME}_${VERSION}.ign
./mvtocontainer.sh
