#
# Dockerfile for aria2
#

FROM cuteribs/alpine
MAINTAINER cuteribs <ericfine1981@live.com>

RUN apk add --no-cache aria2 && \
	mkdir /download

VOLUME "/download"

EXPOSE 6800

CMD aria2c -d=/download --enable-rpc --rpc-listen-all --rpc-listen-port=6800 --rpc-secret=cuteribs