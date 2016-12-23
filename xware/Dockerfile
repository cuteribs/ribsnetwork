#
# Dockerfile for xware
#

FROM debian:wheezy-slim
MAINTAINER cuteribs <ericfine1981@live.com>

WORKDIR /xware

COPY ./*.deb /xware/
COPY ./*.sh /xware/
ADD ./xware.tar.bz /xware/

RUN dpkg -i /xware/libc6_*.deb && \
	dpkg -i /xware/libc6-*.deb && \
	dpkg -i /xware/lib32z1_*.deb && \
	rm /xware/*.deb && \
	chmod +x /xware/portal
