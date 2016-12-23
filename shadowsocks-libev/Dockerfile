#
# Dockerfile for shadowsocks-libev
#

FROM alpine:3.4
MAINTAINER cuteribs <ericfine1981@live.com>

WORKDIR /ss

ADD ./pcre-8.38-r1.apk /ss/
ADD ./*.bz /ss/

RUN apk add /ss/pcre-8.38-r1.apk
