#
# Dockerfile for lighttpd
#

FROM cuteribs/alpine
LABEL maintainer="cuteribs <ericfine1981@live.com>"

RUN apk add --no-cache lighttpd lighttpd-mod_auth && \
	rm -rf /var/cache/apk/* && \
	mkdir /data && mkdir /data/www && mkdir /data/crt && \
	echo 'not 404 found' > /data/www/index.html

ADD ./*.conf /etc/lighttpd/

EXPOSE 80
EXPOSE 443
VOLUME "/etc/lighttpd"
VOLUME "/data"

CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]