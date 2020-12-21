# zope_web-archive
A web archive based on Zope2.

Old but good technology 

I tried to dockerize it, that is the result.
A skeleton of the APP is needed by the Dockerfile, it contains the needed Zope products, some modified by me, and a minimum data.fs file.

The database file (Data.fs) is for now on a volume /zope_instance/var that has to be mounted (-v /SOME_OS_PATH:/zope_instance/var) when creating the container.
Zope exposed on port 8080
Zope admin user/password to be changed in Dockerfile as needed.


<pre>
##
## make volume OS folder, give all rights, first start of image
## - empty Data,fs will be created in volume by zope
##
mkdir zope_var
chmod -R 777 /home/user/zope_var
docker run  -v /home/user/zope_var:/zope_instance/var -p 8080:8080/tcp gilou3000/warchive:initial


##
## get container id:
##
docker ps
-> 521a87b68452 for example

##
## copy BACKUP_WARCHIVE_SKELETONout of image (521a87b68452) 
##
docker cp 521a87b68452/BACKUP_WARCHIVE_SKELETON .

##
## use WARCHIVE data.fs
##
rm /home/user/zope_var/*
cp -R ./BACKUP_WARCHIVE_SKELETON/var/* /home/user/zope_var/
chmod -R 777 /home/user/zope_var

##
## start image with WARCHIVE data.fs
##
docker run  -v /home/user/zope_var:/zope_instance/var -p 8080:8080/tcp gilou3000/warchive:initial
</pre>


Available on dockerhub as gilou3000/warchive:tagname (still have to test if it run as it shloud).

Feel free to contact me in case you try it and have issues...


Gilles


