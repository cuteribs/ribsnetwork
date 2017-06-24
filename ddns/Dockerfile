#
# Dockerfile for dnspod
#

FROM alpine:3.6
MAINTAINER cuteribs <ericfine1981@live.com>

COPY ./dnspod.sh /app/

WORKDIR /app/

ENV Time="* 6 * * *"
ENV Script="dnspod"
ENV ApiId="123456789"
ENV ApiKey="f7c3bc1d808e04732adf679965ccc34ca7ae3441"
ENV Domain="example.com"
ENV SubDomain="www"

RUN apk update && \
	apk add wget ca-certificates openssl && \
	rm -rf /var/cache/apk/* && \

ENTRYPOINT /app/ddns.sh
