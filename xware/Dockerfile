#
# Dockerfile for xware
#

FROM debian:wheezy-slim
MAINTAINER cuteribs <ericfine1981@live.com>

WORKDIR /xware

ADD ./xware.tar.bz /xware
ADD ./libc6_2.13-38+deb7u11_amd64.deb /xware/
ADD ./libc6-i386_2.13-38+deb7u11_amd64.deb /xware/

RUN dpkg -i /xware/libc6_2.13-38+deb7u11_amd64.deb && \
	dpkg -i /xware/libc6-i386_2.13-38+deb7u11_amd64.deb && \
	rm /xware/*.deb && \
	chmod +x /xware/portal