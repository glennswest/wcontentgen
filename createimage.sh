docker kill winoperatordata
docker rm winoperatordata
docker create --name winoperatordata busybox 
docker commit winoperatordata glennswest/winoperatordata:latest
docker rm winoperatordata
docker run -d --name winoperatordata glennswest/winoperatordata:latest sh -c 'mkdir /templates;mkdir /content;sleep infinity'  


