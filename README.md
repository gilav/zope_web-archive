# zope_web-archive
A web archive based on Zope2.

Old but good technology 

I tried to dockerize it, that is the result.
A skeleton of the APP is needed by the Dockerfile, it contains the needed Zope products, some modified by me, and a minimum data.fs file.

The database file (Data.fs) is for now on a volume /zope_instance/var that has to be mounted (-v /SOME_OS_PATH:/zope_instance/var) when creating the container.
Zope exposed on port 8080
Zope admin user/password to be changed in Dockerfile as needed.


Feel free to contact me in case you try it and have issues...


Gilles


