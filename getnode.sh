rm -r -f wip/*
mkdir wip/bin
mkdir wip/bin/metadata
mkdir wip/k
echo "Kubernetes config Dir" > wip/k/readme.txt
export VERSION=2.0.0
export COMPNAME=node
export wcontent=${GOPATH}/src/github.com/glennswest/winoperatordata/wcontent
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ${wcontent}/content/${COMPNAME}_${VERSION}.ign bin)
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ${wcontent}/content/${COMPNAME}_${VERSION}.ign k)
cp metadata/${COMPNAME}_$VERSION.metadata wip/bin/metadata/${COMPNAME}_${VERSION}.metadata
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool um ${wcontent}/content/${COMPNAME}_$VERSION.ign bin/metadata/${COMPNAME}_${VERSION}.metadata)
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ${wcontent}/content/${COMPNAME}_$VERSION.ign bin/metadata)
$GOPATH/src/github.com/glennswest/libignition/igntool/igntool ls ${wcontent}/content/${COMPNAME}_${VERSION}.ign
./mvtocontainer.sh
