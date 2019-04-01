#
# Dockerfile for shadowsocks-rss
#

FROM cuteribs/alpine
LABEL maintainer="cuteribs <ericfine1981@live.com>"

ADD ./*.bz /ss/

RUN apk add --no-cache python libsodium && \
	rm -rf /var/cache/apk/*

WORKDIR /ss/shadowsocks

