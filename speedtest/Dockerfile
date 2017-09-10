#
# Dockerfile for speedtest
#

FROM cuteribs/alpine
MAINTAINER cuteribs <ericfine1981@live.com>

RUN apk add --no-cache nginx php7-fpm php7-openssl && \
	rm -rf /var/cache/apk/*

ADD speedtest.tar.bz /www/
ADD ./nginx.conf /etc/nginx/
ADD ./run.sh /
RUN chmod +x /run.sh


EXPOSE 80
VOLUME ["/www"]

CMD ["/run.sh"]