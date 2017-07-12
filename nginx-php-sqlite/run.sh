#!/bin/sh

[ -f /run-pre.sh ] && /run-pre.sh

if [ ! -d /data/www ] ; then
  mkdir -p /data/www
  chown nginx:www-data /data/www
  chmod -R 777 /data/www
fi

# start php-fpm
mkdir -p /data/logs
php-fpm

# start nginx
mkdir -p /tmp/nginx
chown nginx /tmp/nginx
nginx