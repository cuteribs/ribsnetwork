#
# Dockerfile for xware
#

FROM debian:wheezy-slim
MAINTAINER cuteribs <ericfine1981@live.com>

WORKDIR /xware

ADD ./xware.tar.gz /
ADD ./*.deb /xware/

RUN dpkg -i /xware/libc6-i386_*.deb && \
	dpkg -i /xware/lib32z1_*.deb && \
	chmod +x /xware/portal

RUN rm /xware/libc6-i386_*.deb && \
	rm /xware/lib32z1_*.deb && \
	rm -f /var/cache/*