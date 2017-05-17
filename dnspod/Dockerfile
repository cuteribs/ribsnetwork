#
# Dockerfile for dnspod
#
# ENV Time
# ENV Token
# ENV Domain
# ENV RecordId
# ENV RecordLineId
# ENV SubDomain
# ENV IP
#

FROM alpine:3.4
MAINTAINER cuteribs <ericfine1981@live.com>

COPY ./dnspod.sh /app/

ENV Time="* 6 * * *"

RUN apk update && \
	apk add curl && \
	rm -rf /var/cache/apk/* && \
	touch /app/cron.log && \
	chmod +x /app/dnspod.sh && \
	echo "$Time sh /app/dnspod.sh" > /app/cron.conf

CMD /app/dnspod.sh && crontab /app/cron.conf && tail -f /app/cron.log
