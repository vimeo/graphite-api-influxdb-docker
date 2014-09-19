# graphite-api-influxdb-docker

build docker image with graphite-api and graphite-influxdb
using http://phusion.github.io/baseimage-docker/
which means you effectively get a full working linux system with an init system, logging,
etc.  So you can login if anything goes wrong.

# building

* install docker on your system
* make a new directory and put your own Dockerfile in it, it looks like so:

```
FROM dieter/graphite-api-influxdb
```

* put a customized graphite-api.yaml in this directory, you can base yourself off the graphite-api.yaml in this repository

* build!

```
docker build .
```

* run !

```
docker run -p 8000:8000 <image-id>
```

# enabling ssh login

add this to your Dockerfile

```
ADD <your-ssh-key>.pub /tmp/your_key
RUN cat /tmp/your_key >> /root/.ssh/authorized_keys && rm -f /tmp/your_key
```

once built and running, this will allow you to login to the container like so:

```
docker ps # get container-id
docker inspect <container-id> # look at ip
ssh root@<ip>
```

# http 500 errors

on /render calls, you might get http 500 responses.
unfortunately we can't simply log yet what happend (i.e. which exception)
or display the errors in the http response.
see https://github.com/brutasse/graphite-api/issues/16
but you can make a free account on getsentry.com and use that, it works nicely.
