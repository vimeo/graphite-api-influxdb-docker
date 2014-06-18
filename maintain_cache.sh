#!/bin/sh
exec /sbin/setuser root python2 /src/graphite-api/maintain_cache.py >>/var/log/maintain_cache.log 2>&1
