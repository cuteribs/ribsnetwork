#
# Dockerfile for shadowsocks-rss
#

FROM alpine:3.6
MAINTAINER cuteribs <ericfine1981@live.com>

ADD ./*.bz /ss/

RUN apk update && \
	apk add python libsodium && \
	rm -rf /var/cache/apk/*

WORKDIR /ss/shadowsocks

