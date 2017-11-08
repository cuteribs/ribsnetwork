#!/bin/sh

if [ ! -d /data/www ]; then
	mkdir -p /data/www
	chown nginx:www-data /data/www
	chmod -R 777 /data/www
fi

if [ -f /data/crt/site.crt ]; then
	if [ ! -f /etc/ssl_flag ]; then
		cp /app/nginx.ssl.conf /etc/nginx/nginx.conf
		touch /etc/ssl_flag
	fi	
fi

# start php-fpm
if [ ! -d /data/log ]; then
	mkdir -p /data/log
fi

php-fpm5

# start nginx
if [ ! -d /tmp/nginx ]; then
	mkdir -p /tmp/nginx
	chown nginx /tmp/nginx
fi

nginx