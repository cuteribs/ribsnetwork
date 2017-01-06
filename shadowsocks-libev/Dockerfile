#
# Dockerfile for shadowsocks-libev
#

FROM alpine:3.4
MAINTAINER cuteribs <ericfine1981@live.com>

WORKDIR /ss

COPY ./*.apk /ss/
ADD ./*.bz /ss/

RUN apk add /ss/*.apk && \
	rm /ss/*.apk
