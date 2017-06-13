#
# Dockerfile for cerbot
#

FROM alpine:3.6
MAINTAINER cuteribs <ericfine1981@live.com>

#ENV LoginToken=13490,6b5976c68aba5b14a0558b77c17c3932
#ENV DomainList=example.com,www.example.com,test.example.com

VOLUME /etc/letsencrypt/live

COPY ./dnspod-auth-hook.sh /certbot/

RUN apk update && \
	apk add certbot openssl ca-certificates wget && \
	rm -rf /var/cache/apk/* && \
	DomainListParameters='' && \
	for i in $(echo $DomainList | tr "," "\n"); do DomainListParameters="$DomainListParameters -d $i"; done

ENTRYPOINT ["certbot", "certonly -c cli.ini --manual-auth-hook /certbot/dnspod-auth-hook.sh $DomainListParameters"]
