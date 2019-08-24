rm -r -f wip
mkdir wip
mkdir wip/bin
mkdir wip/bin/metadata
export VERSION=v1.0.1
export COMPNAME=pause
cp files/${COMPNAME}_${VERSION}/bin/*.ps1 wip/bin
rm -f wcontent/content/${COMPNAME}_${VERSION}.ign
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ../wcontent/content/${COMPNAME}_${VERSION}.ign bin)
cp metadata/${COMPNAME}_$VERSION.metadata wip/bin/metadata/${COMPNAME}_${VERSION}.metadata
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool um ../wcontent/content/${COMPNAME}_$VERSION.ign bin/metadata/${COMPNAME}_${VERSION}.metadata)
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ../wcontent/content/${COMPNAME}_$VERSION.ign bin/metadata)
$GOPATH/src/github.com/glennswest/libignition/igntool/igntool ls wcontent/content/${COMPNAME}_${VERSION}.ign
./mvtocontainer.sh
