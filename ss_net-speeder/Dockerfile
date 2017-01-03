#
# Dockerfile for shadowsocks-libev
#

FROM alpine:3.4
MAINTAINER cuteribs <ericfine1981@live.com>

WORKDIR /ss

COPY ./*.apk /ss/
ADD ./*.tar.bz /ss/

RUN apk add /ss/*.apk && \
	rm /ss/*.apk
	
CMD /ss/net_speeder eth0 "ip" &

