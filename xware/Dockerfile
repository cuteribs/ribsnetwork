#
# Dockerfile for xware 1.0.31
#

FROM cuteribs/debian
LABEL maintainer="cuteribs <ericfine1981@live.com>"

WORKDIR /xware

ADD ./xware_1.0.16.tar.bz /xware/

RUN apt-get update && apt-get install lib32z1 -y && \
	rm -rf /var/lib/apt/lists/* && \
	chmod +x /xware/*

CMD /xware/portal > /xware/portal.log 2>&1 && tail -f /xware/portal.log
