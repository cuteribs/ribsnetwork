#
# Dockerfile for shadowsocks-libev
#

FROM cuteribs/alpine
LABEL maintainer="cuteribs <ericfine1981@live.com>"

WORKDIR /ss

ADD ./*.bz /ss/

RUN	apk add --no-cache libev libsodium mbedtls pcre udns && \
	rm -rf /var/cache/apk/*
