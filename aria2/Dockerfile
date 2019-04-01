#
# Dockerfile for aria2
#

FROM cuteribs/alpine
LABEL maintainer="cuteribs <ericfine1981@live.com>"

RUN apk add --no-cache aria2 lighttpd lighttpd-mod_auth && \
	mkdir /data && mkdir /data/www && mkdir /data/crt && mkdir /data/download

COPY ./*.sh /
COPY ./*.conf /data/conf/
ADD ./*.bz /data/www/

ENV Secret "cuteribs"
EXPOSE 80
EXPOSE 6800
VOLUME "/data/crt"
VOLUME "/data/download"

CMD sh /run.sh