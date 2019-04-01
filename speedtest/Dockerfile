#
# Dockerfile for speedtest
#

FROM cuteribs/alpine
LABEL maintainer="cuteribs <ericfine1981@live.com>"

RUN apk add --no-cache nginx php7-fpm php7-openssl && \
	rm -rf /var/cache/apk/*

ADD ./nginx.conf /etc/nginx/
ADD ./run.sh /
RUN chmod +x /run.sh \
	&& wget https://codeload.github.com/adolfintel/speedtest/tar.gz/4.7.1 \
	&& mkdir /www \
	&& tar xvf 4.7.1 \
	&& mv speedtest-4.7.1/* /www/ \
	&& rm -rf 4.7.1 speedtest-4.7.1

EXPOSE 80
VOLUME ["/www"]

CMD ["/run.sh"]