#
# Dockerfile for baidupcs
#

FROM cuteribs/alpine
LABEL maintainer="cuteribs <ericfine1981@live.com>"

ADD ./*.bz /app/

RUN apk add --no-cache libcurl libssl1.0 libcrypto1.0 && \
	rm -rf /var/cache/apk/* && \
	chmod +x /app/pcs

VOLUME "/download"

