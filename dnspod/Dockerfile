#
# Dockerfile for dnspod
#

FROM alpine:3.6
MAINTAINER cuteribs <ericfine1981@live.com>

COPY ./dnspod.sh /app/

ENV Time="* 6 * * *"

RUN apk update && \
	apk add wget ca-certificates openssl && \
	rm -rf /var/cache/apk/* && \
	touch /app/cron.log && \
	echo "$Time sh /app/dnspod.sh" > /app/cron.conf

CMD sh /app/dnspod.sh && crontab /app/cron.conf && tail -f /app/cron.log
