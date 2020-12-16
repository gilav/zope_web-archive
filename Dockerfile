#
# this shaloud build a docker image for the zope 2 Warchive app
#
# Needs:
# - an instance of the warchive in current path, named: instance214_2
#   where the used zope Products will be taken. The Data.fs will also be used.
#

FROM python:2.7-alpine


#
# some ARGs
ENV WARCHIVE_SKELETON ./skeletons/instance214_2
ENV WARCHIVE_DOCKER_BUILD "2020-12-09 V:1.0.0"

RUN apk add zlib-dev libjpeg-turbo-dev

# get temporary packages needed by zope install: gcc, musl-dev
RUN apk add --update --no-cache --virtual .tmp-build-deps gcc musl-dev
 
RUN pip install pillow

# install zope
RUN pip install \
 --no-binary zc.recipe.egg \
 -r https://zopefoundation.github.io/Zope/releases/2.13.29/requirements.txt

# remove temporary packages
RUN apk del .tmp-build-deps

# make zope instance
RUN mkzopeinstance -d zope_instance -u admin:!admin123
#RUN echo "zope instance ls:`ls -alrt zope_instance`"
#RUN echo "zope instance/bin ls:`ls -alrt zope_instance/bin`"
#RUN echo "zope config:`cat zope_instance/etc/zope.conf`"


#ARG redo=1
# apply patch on /usr/local/lib/python2.7/site-packages/OFS/Image.py
COPY ${WARCHIVE_SKELETON}/OSF_Image.patch zope_instance/
RUN patch /usr/local/lib/python2.7/site-packages/OFS/Image.py zope_instance/OSF_Image.patch
RUN echo "@@@@ Image.py patched?: `grep read_raw /usr/local/lib/python2.7/site-packages/OFS/Image.py`"
#RUN echo "Image.py: `cat /usr/local/lib/python2.7/site-packages/OFS/Image.py`"


#
RUN echo ${WARCHIVE_DOCKER_BUILD} > zope_instance/WARCHIVE_DOCKER_BUILD.version

# add used zope products
COPY ${WARCHIVE_SKELETON}/Products/ExtFile/ zope_instance/Products/ExtFile
COPY ${WARCHIVE_SKELETON}/Products/CookieCrumbler/ zope_instance/Products/CookieCrumbler
COPY ${WARCHIVE_SKELETON}/Products/LocalFS/ zope_instance/Products/LocalFS 
COPY ${WARCHIVE_SKELETON}/Products/Photo/ zope_instance/Products/Photo
COPY ${WARCHIVE_SKELETON}/Products/ZipFolder/ zope_instance/Products/ZipFolder
RUN echo "zope Products:`ls -l zope_instance/Products/`"

# add used Extensions
COPY ${WARCHIVE_SKELETON}/Extensions/*.py zope_instance/Extensions/

#RUN echo "zope Products:`ls -lrt zope_instance/Products`"
RUN echo "zope Extensions:`ls -l zope_instance/Extensions/*.py`"

# delete everything in var
RUN rm -R zope_instance/var

# make volume
VOLUME /zope_instance/var

# copy fata.fs in place
#ADD ${WARCHIVE_SKELETON}/var/Data.fs zope_instance/var/Data.fs

# delete zope_instance/var
#RUN rm -R zope_instance/var
#RUN ln /data zope_instance/var

# create a zope user
RUN adduser --disabled-password --gecos '' zope

# give permission on zope_instance to zope user
RUN chown -R zope:zope zope_instance
#RUN chmod 777 zope_instance/var
#RUN chown -R zope:zope /data

#RUN echo "ls /data:`ls -lrt /data`"
RUN echo "zope instance:`ls -lrt zope_instance`"

# expose port 800
EXPOSE 8080

# change user and start
USER zope 
ENTRYPOINT ["/bin/sh", "-f", "zope_instance/bin/zopectl", "fg"]
