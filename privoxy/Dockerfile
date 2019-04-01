#
# Dockerfile for privoxy
#

FROM cuteribs/alpine
LABEL maintainer="cuteribs <ericfine1981@live.com>"

ADD ./privoxy.sh /app/

RUN apk add --no-cache privoxy && \
	chmod +x /app/privoxy.sh && \
	rm -rf /etc/init.d/privoxy && \
	rm -rf /var/cache/apk/*

CMD ["/app/privoxy.sh"]
