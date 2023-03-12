#
# Dockerfile for lighttpd
#

FROM cuteribs/lighttpd
LABEL maintainer="cuteribs <ericfine1981@live.com>"

EXPOSE 80

ADD ./lighttpd.conf /etc/lighttpd/
ADD ./www /data/www

CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]