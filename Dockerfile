FROM phusion/baseimage:0.9.10

ENV HOME /root
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh
CMD ["/sbin/my_init"]


### taken from brutasse/graphite-api

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

RUN pip install gunicorn graphite-api[sentry,cyanite]

ADD graphite-api.yaml /etc/graphite-api.yaml
RUN chmod 0644 /etc/graphite-api.yaml

EXPOSE 8000

# except CMD should be the initscript, see further down.
#CMD gunicorn -b 0.0.0.0:8000 -w 2 --log-level debug graphite_api.app:app


#### me

RUN mkdir /etc/service/graphite-api
ADD graphite-api.sh /etc/service/graphite-api/run
RUN chmod +x /etc/service/graphite-api/run

RUN mkdir /etc/service/maintain_cache
ADD maintain_cache.sh /etc/service/maintain_cache/run
RUN chmod +x /etc/service/maintain_cache/run

ADD <your-ssh-key>.pub  /tmp/your_key
RUN cat /tmp/your_key >> /root/.ssh/authorized_keys && rm -f /tmp/your_key

RUN pip install Flask-Cache
RUN pip install graphite-influxdb
RUN pip install raven blinker
# for developing:
# RUN apt-get install -y tcpdump ngrep dnsutils memcached libmemcached-dev telnet

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
