#
# Dockerfile for privoxy
#

FROM alpine:3.4
MAINTAINER cuteribs <ericfine1981@live.com>

ADD ./privoxy.sh /app/

RUN apk update && \
	apk add privoxy && \
	chmod +x /app/privoxy.sh && \
	rm -rf /etc/init.d/privoxy && \
	rm -rf /var/cache/apk/*

CMD ["/app/privoxy.sh"]
