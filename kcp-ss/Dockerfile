#
# Dockerfile for shadowsocks-libev & kcptun
#

FROM alpine:3.4
MAINTAINER cuteribs <ericfine1981@live.com>

COPY ./pcre-8.38-r1.apk /ss/
ADD ./ss-libev_v2.5.6_alpine3.4.tar.bz /ss/
ADD ./kcptun-linux-amd64-20161207.tar.bz /kcptun/

RUN apk add /ss/pcre-8.38-r1.apk && \
	rm /ss/pcre-8.38-r1.apk
