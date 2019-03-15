#
# Dockerfile for homebridge
#

FROM cuteribs/nodejs:latest
LABEL maintainer="cuteribs <ericfine1981@live.com>"

RUN apk add --no-cache avahi-compat-libdns_sd python2 g++ make && \
	npm install -g --unsafe-perm homebridge homebridge-config-ui-x && \
	touch /var/log/homebridge.log

WORKDIR /root/.homebridge

CMD homebridge
