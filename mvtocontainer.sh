export wdir=`pwd`
export wcontent=${GOPATH}/src/github.com/glennswest/winoperatordata/wcontent
cp templates/* ${wcontent}
cd ${wcontent}
tar cvzf ../wip.taz *
cd $wdir
docker cp wip.taz  winoperatordata:/content
docker exec winoperatordata  sh -c "cd /content;tar xvzf wip.taz"
docker exec winoperatordata  sh -c "cd /content;rm wip.taz"
docker exec winoperatordata  sh -c "cd /content;ls -l -R -h"
rm wip.taz

