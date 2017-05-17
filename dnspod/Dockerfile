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

COPY dnspod.sh ~/

ENV Time="* 6 * * *"

RUN apk update && \
	apk add curl && \
	rm -rf /var/cache/apk/* && \
	touch ~/cron.log && \
	echo "$Time sh ~/dnspod.sh" > ~/cron.conf

CMD sh ~/dnspod.sh && crontab ~/cron.conf && tail -f ~/cron.log
