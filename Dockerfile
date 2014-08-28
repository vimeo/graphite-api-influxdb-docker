FROM phusion/baseimage:0.9.10

ENV HOME /root
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh
CMD ["/sbin/my_init"]

### following part mostly taken from brutasse/graphite-api

VOLUME /srv/graphite

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y language-pack-en
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales

RUN apt-get install -y build-essential python-dev libffi-dev libcairo2-dev python-pip

RUN pip install gunicorn graphite-api[sentry,cyanite] graphite-influxdb

EXPOSE 8000

####

# add our config

ADD graphite-api.yaml /etc/graphite-api.yaml
RUN chmod 0644 /etc/graphite-api.yaml

# init scripts

RUN mkdir /etc/service/graphite-api
ADD graphite-api.sh /etc/service/graphite-api/run
RUN chmod +x /etc/service/graphite-api/run

# optional. if you want the ability to use key-based ssh login

ADD <your-ssh-key>.pub  /tmp/your_key
RUN cat /tmp/your_key >> /root/.ssh/authorized_keys && rm -f /tmp/your_key


# dependencies

RUN pip install Flask-Cache statsd
RUN pip install raven blinker

# for developing:
RUN apt-get install -y tcpdump ngrep dnsutils memcached libmemcached-dev telnet


# the best versions are often not in pypi, for now.

# we need the caching support, and some fixes
RUN pip uninstall -y graphite-api 
RUN pip install https://github.com/Dieterbe/graphite-api/tarball/check-series-early

# we need the latest version!
RUN pip uninstall -y graphite-influxdb
RUN pip install https://github.com/Vimeo/graphite-influxdb/tarball/master

# we need the timeout fix https://github.com/influxdb/influxdb-python/pull/41
RUN pip uninstall -y influxdb
RUN pip install https://github.com/influxdb/influxdb-python/tarball/master


# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
