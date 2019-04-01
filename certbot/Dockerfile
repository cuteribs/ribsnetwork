#
# Dockerfile for cerbot
#

FROM cuteribs/alpine
LABEL maintainer="cuteribs <ericfine1981@live.com>"

#ENV LoginToken=13490,6b5976c68aba5b14a0558b77c17c3932
#ENV Email=admin@example.com
#ENV DomainList=example.com,www.example.com,test.example.com

VOLUME /etc/letsencrypt

COPY ./*.sh /certbot/
COPY ./cli.ini /certbot/

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
	apk update && \
	apk add certbot openssl ca-certificates wget && \
	rm -rf /var/cache/apk/* && \
	chmod +x /certbot/*.sh

WORKDIR /certbot

CMD ["/certbot/certbot.sh"]
