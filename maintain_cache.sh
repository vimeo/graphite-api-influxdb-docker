#!/bin/sh
exec /sbin/setuser root python2 /usr/local/bin/maintain_cache.py >>/var/log/maintain_cache.log 2>&1
