#
# Dockerfile for lighttpd
#

FROM alpine:latest
LABEL maintainer="cuteribs <ericfine1981@live.com>"

EXPOSE 80
EXPOSE 443
VOLUME "/etc/lighttpd"
VOLUME "/data"

# apk 源切到阿里, 国内访问加速
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories

# 设置默认时区为亚洲/上海 (没有北京可选)
RUN	apk add --no-cache tzdata && lighttpd lighttpd-mod_auth && \
	ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
	echo "Asia/Shanghai" > /etc/timezone && \
	apk del tzdata && \
	rm -rf /var/cache/apk/* && \
	mkdir /data && mkdir /data/www && mkdir /data/crt && \
	echo 'not 404 found' > /data/www/index.html

ADD ./lighttpd.conf /etc/lighttpd/

CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]