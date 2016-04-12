#!/bin/sh

echo Starting nginx
exec /usr/sbin/nginx 2>&1 | logger -t "nginx"
