#
# Dockerfile for xware
#

FROM cuteribs/debian
MAINTAINER cuteribs <ericfine1981@live.com>

WORKDIR /xware

ADD ./xware.tar.bz /xware/

RUN	apt-get update && \
	apt-get install lib32z1 -y && \
	chmod +x /xware/portal

CMD /xware/portal > /xware/portal.log 2>&1 && tail -f /xware/portal.log