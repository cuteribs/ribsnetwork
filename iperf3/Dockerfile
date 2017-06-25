#
# Dockerfile for iperf3
#

FROM alpine:3.6
MAINTAINER cuteribs <ericfine1981@live.com>

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
	apk update && \
	apk add iperf3 && rm -rf /var/cache/apk/*

EXPOSE 5201

ENTRYPOINT ["iperf3"]