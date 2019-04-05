#
# Dockerfile for homebridge
#

FROM cuteribs/nodejs
LABEL maintainer="cuteribs <ericfine1981@live.com>"

RUN apk add --no-cache python2 g++ make dbus nodejs avahi avahi-compat-libdns_sd avahi-dev && \
	yarn add homebridge homebridge-config-ui && \
	apk del python2 g++ gcc make && \
	rm -rf /var/cache/apk/* && \
	export PATH=$PATH:/node_modules/homebridge/bin && \
	touch /var/log/homebridge.log

WORKDIR /root/.homebridge
ADD ./config.json /root/.homebridge/

ENV Command="homebridge -I | tee /var/log/homebridge.log"

CMD $Command
