#
# Dockerfile for frp
#

FROM cuteribs/alpine
LABEL maintainer="cuteribs <ericfine1981@live.com>"

WORKDIR /frp

ADD ./frp_0.10.0_linux_amd64.tar.bz /frp/

RUN chmod +x /frp/frps && chmod +x /frp/frpc
