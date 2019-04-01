#
# Dockerfile for alpine
#

FROM alpine:latest
LABEL maintainer="cuteribs <ericfine1981@live.com>"

# apk 源切到阿里, 国内访问加速
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories

# 设置默认时区为亚洲/上海 (没有北京可选)
RUN	apk add --no-cache tzdata && \
	cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
	echo "Asia/Shanghai" > /etc/timezone && \
	apk del tzdata
