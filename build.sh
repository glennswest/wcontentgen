git push origin master
export GIT_COMMIT=$(git rev-parse --short HEAD)
rm -r -f tmp
mkdir tmp
docker build --no-cache -t glennswest/winoperatordata:$GIT_COMMIT .
docker tag glennswest/winoperatordata:$GIT_COMMIT  docker.io/glennswest/winoperatordata:$GIT_COMMIT
docker push docker.io/glennswest/winoperatordata:$GIT_COMMIT
