export GIT_COMMIT=$(git rev-parse --short HEAD)
docker commit winoperatordata glennswest/winoperatordata:latest
docker tag glennswest/winoperatordata:latest  glennswest/winoperatordata:$GIT_COMMIT
docker tag glennswest/winoperatordata:$GIT_COMMIT  docker.io/glennswest/winoperatordata:$GIT_COMMIT
docker push docker.io/glennswest/winoperatordata:$GIT_COMMIT


