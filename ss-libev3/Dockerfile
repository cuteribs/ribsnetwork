#
# Dockerfile for shadowsocks-libev
#

FROM cuteribs/alpine
LABEL maintainer="cuteribs <ericfine1981@live.com>"

WORKDIR /ss

ADD ./*.bz /ss/

# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
RUN apk add --no-cache libev libsodium mbedtls pcre udns

# CMD ss-server -s 0.0.0.0 -p 8080 -k 1234 -u --plugin obfs-server --plugin-opts "obfs=http"

