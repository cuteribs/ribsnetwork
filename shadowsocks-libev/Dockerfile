#
# Dockerfile for shadowsocks-libev
#

FROM cuteribs/alpine
MAINTAINER cuteribs <ericfine1981@live.com>

WORKDIR /ss

ADD ./*.bz /ss/

RUN apk add --no-cache mbedtls pcre && \
	rm -rf /var/cache/apk/*

