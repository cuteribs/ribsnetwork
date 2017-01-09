#
# Dockerfile for nginx php sqlite
#

FROM alpine:3.4
MAINTAINER cuteribs <ericfine1981@live.com>

RUN apk update && \
	apk add nginx php5 php5-fpm php5-openssl php5-sqlite3 sqlite && \
	rm -rf /var/cache/apk/*

ADD ./nginx.conf /etc/nginx/
ADD ./php-fpm.conf /etc/php5/
ADD ./run.sh /
RUN chmod +x /run.sh


EXPOSE 80
EXPOSE 443
VOLUME ["/DATA"]

CMD ["/run.sh"]