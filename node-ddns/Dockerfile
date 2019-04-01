#
# Dockerfile for ddns
#

FROM cuteribs/nodejs
MAINTAINER cuteribs <ericfine1981@live.com>

WORKDIR /js

COPY ./* /js/

RUN npm install --no-optional --only=prod

ENTRYPOINT node ddns.js


