#
# Dockerfile for shadowsocks-libev
#

FROM alpine:3.4
MAINTAINER cuteribs <ericfine1981@live.com>

ADD ./privoxy.sh /app/

RUN apk update && \
	apk add privoxy && \
	rm -rf /etc/init.d/privoxy && \
	rm -rf /var/cache/apk/*

ENTRYPOINT ["/app/privoxy.sh"]
