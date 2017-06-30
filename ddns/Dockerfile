#
# Dockerfile for ddns
#

FROM alpine:3.6
MAINTAINER cuteribs <ericfine1981@live.com>

COPY ./*.sh /app/

WORKDIR /app/

#ENV Time="* 6 * * *"
#ENV Script="dnspod"
#ENV ApiId="123456789"
#ENV ApiKey="f7c3bc1d808e04732adf679965ccc34ca7ae3441"
#ENV Domain="example.com"
#ENV SubDomain="www"

# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \

RUN	apk update && \
	apk add wget ca-certificates openssl && \
	rm -rf /var/cache/apk/* && \
	chmod +x /app/*.sh && \
	touch /app/cron.log

CMD "/app/$Script.sh" && echo "$Time /app/$Script.sh" > /etc/crontabs/root && crond -f
