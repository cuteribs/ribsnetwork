#
# Dockerfile for shadowsocks-libev
#

FROM alpine
MAINTAINER cuteribs <ericfine1981@live.com>

ARG SS_VER=2.5.6
ARG SS_URL=https://github.com/shadowsocks/shadowsocks-libev/archive/v$SS_VER.tar.gz

ENV SERVICE		ss-server
ENV SERVER_ADDR 0.0.0.0
ENV SERVER_PORT 8080
ENV	LOCAL_PORT	8338
ENV PASSWORD	cuteribs
ENV METHOD      rc4-md5
ENV TIMEOUT     60
ENV DNS_ADDR    8.8.8.8
ENV DNS_ADDR_2  8.8.4.4

RUN set -ex && \
    apk add --no-cache --virtual .build-deps \
                                asciidoc \
                                autoconf \
                                build-base \
                                curl \
                                libtool \
                                linux-headers \
                                openssl-dev \
                                pcre-dev \
                                tar \
                                xmlto && \
    cd /tmp && \
    curl -sSL $SS_URL | tar xz --strip 1 && \
    ./configure --prefix=/usr --disable-documentation && \
    make install && \
    cd .. && \

    runDeps="$( \
        scanelf --needed --nobanner /usr/bin/ss-* \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | xargs -r apk info --installed \
            | sort -u \
    )" && \
    apk add --no-cache --virtual .run-deps $runDeps && \
    apk del .build-deps && \
    rm -rf /tmp/*

USER nobody

EXPOSE $SERVER_PORT/tcp $SERVER_PORT/udp

CMD $SERVICE -s $SERVER_ADDR \
              -p $SERVER_PORT \
			  -b 0.0.0.0 \
			  -l LOCAL_PORT \
              -k $PASSWORD \
              -m $METHOD \
              -t $TIMEOUT \
              --fast-open \
              -d $DNS_ADDR \
              -d $DNS_ADDR_2 \
              -u