#
# Dockerfile for aria2
#

FROM cuteribs/alpine
MAINTAINER cuteribs <ericfine1981@live.com>

RUN apk add --no-cache aria2 && \
	mkdir /data

VOLUME "/data"

EXPOSE 6800

CMD aria2c -d=/data --enable-rpc --rpc-listen-all --rpc-listen-port=6800 --rpc-secret=cuteribs