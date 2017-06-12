#
# Dockerfile for cerbot
#

FROM alpine:3.6
MAINTAINER cuteribs <ericfine1981@live.com>

ENV LoginToken
ENV DomainList
VOLUME /etc/letsencrypt/live

COPY ./dnspod-auth-hook.sh /certbot/

RUN apk update && \
	apk add certbot openssl ca-certificates wget && \
	rm -rf /var/cache/apk/* && \	

CMD certbot certonly -c cli.ini --manual-auth-hook /certbot/dnspod-auth-hook.sh $DomainList
