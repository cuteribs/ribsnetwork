#
# Dockerfile for debian
#

FROM debian:wheezy-slim
MAINTAINER cuteribs <ericfine1981@live.com>

# 安装包源切到中科大, 国内访问加速
RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \

# 设置默认时区为亚洲/上海 (没有北京可选)
	cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
	echo "Asia/Shanghai" > /etc/timezone

