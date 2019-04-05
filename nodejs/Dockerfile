#
# Dockerfile for nodejs
#

FROM cuteribs/alpine
LABEL maintainer="cuteribs <ericfine1981@live.com>"

RUN apk add --no-cache nodejs yarn && \
	# yarn 源切到阿里, 国内访问加速
	yarn config set registry https://registry.npm.taobao.org --global && \
	yarn config set disturl https://npm.taobao.org/dist --global && \
	rm -rf /var/cache/apk/*

CMD ["ash"]


