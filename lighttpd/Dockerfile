#
# Dockerfile for lighttpd
#

FROM cuteribs/alpine
MAINTAINER cuteribs <ericfine1981@live.com>

RUN apk add --no-cache lighttpd lighttpd-mod_auth

ADD ./*.conf /lighttpd/


EXPOSE 80
EXPOSE 443
VOLUME ["/lighttpd"]
VOLUME ["/www"]

CMD ["lighttpd", "-D", "-f", "/lighttpd/lighttpd.conf"]