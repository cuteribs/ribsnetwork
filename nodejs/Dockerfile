#
# Dockerfile for nodejs
#

FROM alpine:3.6
MAINTAINER cuteribs <ericfine1981@live.com>

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
	apk update && \
	apk add nodejs-npm && \
	rm -rf /var/cache/apk/*

CMD ["ash"]


