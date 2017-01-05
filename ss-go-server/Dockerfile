#
# Dockerfile for shadowsocks-go server
#

FROM alpine:3.4
MAINTAINER cuteribs <ericfine1981@live.com>

WORKDIR /ss

ADD ./*.bz /ss/

RUN chmod +x /ss/shadowsocks-server-linux64-1.1.5

CMD ["/ss/shadowsocks-server-linux64-1.1.5", "$@"]
