#
# Dockerfile for shadowsocks-rss
#

FROM alpine:3.6
MAINTAINER cuteribs <ericfine1981@live.com>

ADD ./*.bz /ss/

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
	apk update && \
	apk add python libsodium && \
	rm -rf /var/cache/apk/*

WORKDIR /ss/shadowsocks

