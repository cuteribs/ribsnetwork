#
# Dockerfile for ddns
#

FROM cuteribs/nodejs
LABEL maintainer="cuteribs <ericfine1981@live.com>"

WORKDIR /js

COPY ./* /js/

RUN npm install --no-optional --only=prod

ENTRYPOINT node ddns.js


