FROM phusion/baseimage:0.9.10

ENV HOME /root
ONBUILD RUN /etc/my_init.d/00_regen_ssh_host_keys.sh
CMD ["/sbin/my_init"]

### see also brutasse/graphite-api

VOLUME /srv/graphite

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y language-pack-en
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN locale-gen en_US.UTF-8 && dpkg-reconfigure locales

RUN apt-get install -y build-essential python-dev libffi-dev libcairo2-dev python-pip
RUN pip install gunicorn graphite-api[sentry,cyanite] graphite-influxdb Flask-Cache statsd raven blinker

EXPOSE 8000

# add our config

ONBUILD ADD graphite-api.yaml /etc/graphite-api.yaml
ONBUILD RUN chmod 0644 /etc/graphite-api.yaml

# init scripts

RUN mkdir /etc/service/graphite-api
ADD graphite-api.sh /etc/service/graphite-api/run
RUN chmod +x /etc/service/graphite-api/run

# we need latest version
RUN pip uninstall -y graphite-api 
RUN pip install https://github.com/Dieterbe/graphite-api/tarball/support-templates2

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
