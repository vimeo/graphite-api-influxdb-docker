# graphite-api-influxdb-docker

builds the [vimeo/graphite-api-influxdb](https://registry.hub.docker.com/u/vimeo/graphite-api-influxdb/) docker image, with graphite-api and graphite-influxdb
using [baseimage-docker](http://phusion.github.io/baseimage-docker/)
which means you effectively get a full working linux system with an init system, logging,
etc.  So you can login if anything goes wrong.

# building

* install docker on your system
* make a new directory and put your own Dockerfile in it, it looks like so:

```
FROM vimeo/graphite-api-influxdb
```

* put a customized graphite-api.yaml in this directory, you can base yourself off [the graphite-api.yaml in this repository](https://github.com/vimeo/graphite-api-influxdb-docker/blob/master/graphite-api.yaml)

* build!

```
docker build .
```

* run !

```
docker run -p 8000:8000 <image-id>
```

# logging in to the container

See [container admininstration](https://github.com/phusion/baseimage-docker/blob/master/README.md#container_administration)

# http 500 errors

on /render calls, you might get http 500 responses.
unfortunately we can't simply log yet what happend (i.e. which exception)
or display the errors in the http response.
see https://github.com/brutasse/graphite-api/issues/16
but you can make a free account on getsentry.com and use that, it works nicely.
You can also try this patch for graphite-api https://github.com/brutasse/graphite-api/pull/73#issuecomment-74080310
It works for some people (including yours truly)

# Gunicorn not starting?
This shouldn't happen to you as an end user,
but may happen if you're tweaking this image.
Try running in debug/standalone mode by running this script:
https://github.com/brutasse/graphite-api/blob/master/bin/graphite
