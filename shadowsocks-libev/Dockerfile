#
# Dockerfile for shadowsocks-libev
#

FROM alpine:3.6
MAINTAINER cuteribs <ericfine1981@live.com>

WORKDIR /ss

ADD ./*.bz /ss/

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
	apk update && \
	apk add mbedtls pcre && \
	rm -rf /var/cache/apk/*

