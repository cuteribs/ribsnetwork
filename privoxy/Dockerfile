#
# Dockerfile for privoxy
#

FROM alpine:3.6
MAINTAINER cuteribs <ericfine1981@live.com>

ADD ./privoxy.sh /app/

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
	apk update && \
	apk add privoxy && \
	chmod +x /app/privoxy.sh && \
	rm -rf /etc/init.d/privoxy && \
	rm -rf /var/cache/apk/*

CMD ["/app/privoxy.sh"]
