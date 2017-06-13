#
# Dockerfile for cerbot
#

FROM alpine:3.6
MAINTAINER cuteribs <ericfine1981@live.com>

#ENV LoginToken=13490,6b5976c68aba5b14a0558b77c17c3932
#ENV Email=admin@example.com
#ENV DomainList=example.com,www.example.com,test.example.com

VOLUME /etc/letsencrypt

COPY ./*.sh /certbot/
COPY ./cli.ini /certbot/

RUN apk update && \
	apk add certbot openssl ca-certificates wget && \
	rm -rf /var/cache/apk/* && \
	chmod +x /certbot/*.sh

WORKDIR /certbot

CMD ["/certbot/certbot.sh"]
