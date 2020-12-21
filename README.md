# zope_web-archive
A web archive based on Zope2.

Old but good technology 

I tried to dockerize it, that is the result.

A skeleton of the APP is needed, it contains the needed Zope products, some modified by me, and a minimum data.fs file containing the web archive code.
This skeleton is present in the docker image at path: BACKUP_WARCHIVE_SKELETON
It need to be copied out of the container, then copied at the OS path of the mounted volume.

The volume is: /zope_instance/var and has to be mounted (-v /SOME_OS_PATH:/zope_instance/var) when creating the container.
Zope exposed on port 8080.
Zope admin user/password to be changed in Dockerfile as needed.


<b>A) The way I use the image is like:</b>

Available on dockerhub as gilou3000/warchive:initial.

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


<b>B) The way I build the image (skeleton needed) is:</b>
TBD...


Feel free to contact me in case you try it and have issues...


Gilles


