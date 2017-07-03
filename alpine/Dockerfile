#
# Dockerfile for alpine
#

FROM alpine:3.6
MAINTAINER cuteribs <ericfine1981@live.com>

# 安装包源切到中科大, 国内访问加速
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \

# 设置默认时区为亚洲/上海 (没有北京可选)
	apk add --no-cache tzdata && \
	cp /usr/share/timezone/Asia/Shanghai /etc/localtime && \
	echo "Asia/Shanghai" > /etc/timezone && \
	apk del tzdata
