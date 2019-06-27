docker kill winoperatordata
docker rm winoperatordata
docker create -v /content --name winoperatordata busybox 
docker commit winoperatordata glennswest/winoperatordata:latest
docker rm winoperatordata
docker run -d --name winoperatordata glennswest/winoperatordata:latest sh -c 'sleep infinity'  -v /content


