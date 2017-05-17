#
# Dockerfile for dnspod
#
# ENV Token
# ENV Domain
# ENV RecordId
# ENV RecordLineId
# ENV SubDomain
# ENV IP
#

FROM alpine:3.4
MAINTAINER cuteribs <ericfine1981@live.com>

RUN apk update && \
	apk add curl && \
	rm -rf /var/cache/apk/* && \
	touch ~/cron.log && \
	echo "* 6 * * * curl -X POST https://dnsapi.cn/Record.Ddns -d 'login_token=$Token&format=json&domain=$Domain&record_id=$RecordId&record_line_id=$RecordLineId&sub_domain=$SubDomain&value=$(curl http://members.3322.org/dyndns/getip 2>/dev/null)' >> ~/cron.log 2>&1" > ~/cron.conf

CMD crontab ~/cron.conf && tail -f ~/cron.log
