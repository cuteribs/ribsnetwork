#
# Dockerfile for shadowsocks-libev
#

FROM alpine:3.4
MAINTAINER cuteribs <ericfine1981@live.com>

WORKDIR /ss

ADD ./pcre-8.38-r1.apk /ss/
ADD ./ss-libev_v2.5.6_alpine3.4.tar.bz /ss/

RUN apk add /ss/pcre-8.38-r1.apk

RUN rm /ss/pcre-8.38-r1.apk
