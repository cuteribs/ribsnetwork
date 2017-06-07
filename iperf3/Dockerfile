#
# Dockerfile for iperf3
#

FROM alpine:3.6
MAINTAINER cuteribs <ericfine1981@live.com>

RUN apk update && apk add iperf3 && rm -rf /var/cache/apk/*

EXPOSE 5201

ENTRYPOINT ["iperf3"]