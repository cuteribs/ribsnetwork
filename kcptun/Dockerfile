#
# Dockerfile for kcptun
#

FROM golang:alpine
MAINTAINER cuteribs <ericfine1981@live.com>

RUN apk update && \
    apk upgrade && \
    apk add git

RUN go get github.com/xtaci/kcptun/client && go get github.com/xtaci/kcptun/server

RUN apk del git

EXPOSE 29900/udp
EXPOSE 12948