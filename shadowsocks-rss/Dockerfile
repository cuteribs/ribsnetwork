#
# Dockerfile for shadowsocks-rss
#

FROM cuteribs/alpine
MAINTAINER cuteribs <ericfine1981@live.com>

ADD ./*.bz /ss/

RUN apk add --no-cache python libsodium && \
	rm -rf /var/cache/apk/*

WORKDIR /ss/shadowsocks

