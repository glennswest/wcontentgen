export wdir=`pwd`
export wcontent=${GOPATH}/src/github.com/glennswest/winoperatordata/wcontent
cd ${wcontent}
tar cvzf ../wip.taz *
cd $wdir
docker cp wip.taz  winoperatordata:/content
echo "Exec the untar"
docker exec winoperatordata  sh -c "cd /content;tar xvzf wip.taz"
docker exec winoperatordata  sh -c "cd /content;rm wip.taz"
docker exec winoperatordata  sh -c "cd /content;ls -l -R -h"
rm wip.taz

