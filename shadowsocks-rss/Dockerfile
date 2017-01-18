#
# Dockerfile for shadowsocks-rss
#

FROM alpine:3.4
MAINTAINER cuteribs <ericfine1981@live.com>

WORKDIR /ss

ADD ./*.bz /ss/

RUN apk update && apk add python libsodium

