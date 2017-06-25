#
# Dockerfile for nginx php sqlite
#

FROM alpine:3.6
MAINTAINER cuteribs <ericfine1981@live.com>

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
	apk update && \
	apk add nginx sqlite php5-fpm php5-pdo_sqlite php5-ctype php5-iconv php5-xmlrpc php5-mcrypt php5-sockets php5-curl php5-memcache php5-apcu php5-xcache  && \
	rm -rf /var/cache/apk/*

ADD ./nginx.conf /etc/nginx/
ADD ./php-fpm.conf /etc/php5/
ADD ./run.sh /
RUN chmod +x /run.sh


EXPOSE 80
EXPOSE 443
VOLUME ["/data"]

CMD ["/run.sh"]