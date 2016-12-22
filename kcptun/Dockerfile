#
# Dockerfile for kcptun
#

FROM alpine:3.4
MAINTAINER cuteribs <ericfine1981@live.com>

ARG KCP_VER=20161207
ARG KCP_URL=https://github.com/xtaci/kcptun/releases/download/v$KCP_VER/kcptun-linux-amd64-$KCP_VER.tar.gz

RUN apk update && apk add curl \
	&& curl -sSL $KCP_URL | tar xz \
	&& apk del curl
