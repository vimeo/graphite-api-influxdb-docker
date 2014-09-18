# graphite-api-influxdb-docker

build docker image with graphite-api and graphite-influxdb
using http://phusion.github.io/baseimage-docker/
which means you effectively get a full working linux system with an init system, logging,
etc.  So you can login if anything goes wrong.

# building

install docker on your system, clone this repo.
inside the working copy, modify the graphite-api.yaml, and then

```
docker build .
docker run -p 8000:8000 <image-id>
```

# building a customized version

add this to Dockerfile
```
# to enable ssh login
ADD <your-ssh-key>.pub  /tmp/your_key
RUN cat /tmp/your_key >> /root/.ssh/authorized_keys && rm -f /tmp/your_key
```


# ssh login

```
docker ps # get container-id
docker inspect <container-id> # look at ip
ssh root@<ip>
```


# http 500 errors

on /render calls, you might get http 500 responses.
unfortunately we can't simply log yet what happend (i.e. which exception)
see https://github.com/brutasse/graphite-api/issues/16
but you can make a free account on getsentry.com and use that, it works nicely.
note that just after launching you might get a few http 500's because the cache needs to warm up,
but after a few seconds it should work fine.
