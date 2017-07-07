#
# Dockerfile for shadowsocks-libev
#

FROM cuteribs/alpine
MAINTAINER cuteribs <ericfine1981@live.com>

WORKDIR /ss

ADD ./*.bz /ss/

# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
RUN	apk add --no-cache --virtual mbedtls pcre && \
	rm -rf /var/cache/apk/*
