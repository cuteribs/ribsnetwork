#
# Dockerfile for homebridge
#

FROM cuteribs/nodejs
LABEL maintainer="cuteribs <ericfine1981@live.com>"

RUN apk add --no-cache python2 g++ make dbus nodejs avahi avahi-compat-libdns_sd avahi-dev && \
	npm install -g --unsafe-perm homebridge homebridge-config-ui-x && \
	apk remove python2 g++ make && \
	touch /var/log/homebridge.log

WORKDIR /root/.homebridge
ADD ./config.json /root/.homebridge/

ENV Command="homebridge -I | tee /var/log/homebridge.log"

CMD $Command
