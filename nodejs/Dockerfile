#
# Dockerfile for nodejs
#

FROM cuteribs/alpine
LABEL maintainer="cuteribs <ericfine1981@live.com>"

RUN apk add --no-cache nodejs nodejs-npm && \
	# npm 源切到阿里, 国内访问加速
	npm config set registry http://registry.npm.taobao.org/	&& \
	rm -rf /var/cache/apk/*

CMD ["ash"]


