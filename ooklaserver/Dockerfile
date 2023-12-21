#
# Dockerfile for OoklaServer
#

FROM alpine
LABEL maintainer="cuteribs <ericfine1981@live.com>"

WORKDIR /ookla

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
	wget -O glibc.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r1/glibc-2.35-r1.apk && \
	wget -O glibc-bin.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r1/glibc-bin-2.35-r1.apk && \
	apk add --no-cache --force-overwrite glibc.apk glibc-bin.apk && \
	rm glibc* && \
	wget -qO- https://install.speedtest.net/ooklaserver/stable/OoklaServer-linux64.tgz  | tar xzoC /ookla

EXPOSE 5060 8080 5060/udp 8080/udp
CMD ["/ookla/OoklaServer"]

# docker run -d --name ooklaserver -p 5060:5060 -p 8080:8080 -p 5060:5060/udp -p 8080:8080/udp cuteribs/ooklaserver