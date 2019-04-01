#
# Dockerfile for iperf3
#

FROM cuteribs/alpine
LABEL maintainer="cuteribs <ericfine1981@live.com>"

RUN apk add --no-cache iperf3 && \
	rm -rf /var/cache/apk/*

EXPOSE 5201

ENTRYPOINT ["iperf3"]