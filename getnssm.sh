rm -r -f wip
mkdir wip
mkdir wip/bin
mkdir wip/bin/metadata
export VERSION=2.24
export COMPNAME=nssm
export wcontent=${GOPATH}/src/github.com/glennswest/winoperatordata/wcontent
echo $VERSION
echo $COMPNAME
rm ${wcontent}/content/${COMPNAME}_${VERSION}.ign
cp metadata/${COMPNAME}_${VERSION}.metadata wip/bin/metadata
cp files/${COMPNAME}_${VERSION}/bin/*.ps1 wip/bin
wget https://nssm.cc/release/nssm-2.24.zip -O wip/bin/nssm-2.24.zip
(cd wip/bin;unzip nssm-2.24.zip;mv nssm-2.24/win64/nssm.exe .;rm -r -f nssm-2.24;rm nssm-2.24.zip)
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ${wcontent}/content/${COMPNAME}_${VERSION}.ign bin)
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool um ${wcontent}/content/${COMPNAME}_${VERSION}.ign bin/metadata/${COMPNAME}_${VERSION}.metadata)
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ${wcontent}/content/${COMPNAME}_${VERSION}.ign bin/metadata)
$GOPATH/src/github.com/glennswest/libignition/igntool/igntool ls ${wcontent}/content/${COMPNAME}_${VERSION}.ign
cat wip/bin/metadata/${COMPNAME}_${VERSION}.metadata
./mvtocontainer.sh
