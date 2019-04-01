#
# Dockerfile for nginx php sqlite
#

FROM cuteribs/alpine
LABEL maintainer="cuteribs <ericfine1981@live.com>"

RUN apk add --no-cache nginx sqlite php7-fpm php7-pdo_sqlite php7-ctype php7-iconv php7-xmlrpc php7-mcrypt php7-sockets php7-curl && \
	rm -rf /var/cache/apk/*

ADD ./nginx.conf /app/
ADD ./nginx.ssl.conf /app/
ADD ./php-fpm.conf /app/
ADD ./run.sh /app/
RUN cp /app/nginx.conf /etc/nginx/ && \
	cp /app/php-fpm.conf /etc/php7/ && \
	chmod +x /app/run.sh

EXPOSE 80
EXPOSE 443
VOLUME ["/data"]

CMD ["/app/run.sh"]