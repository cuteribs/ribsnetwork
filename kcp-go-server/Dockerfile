#
# Dockerfile for kcptun server
#

FROM alpine:3.4
MAINTAINER cuteribs <ericfine1981@live.com>

WORKDIR /kcp

ADD ./kcp-go-server-20161222.tar.bz /kcp/

RUN chmod +x /kcp/server_linux_amd64

CMD ["/kcp/server_linux_amd64", "$@"]
