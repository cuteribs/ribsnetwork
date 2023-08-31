FROM cuteribs/net6app

RUN apk add --no-cache --update python3 py3-pip && \
    apk add --no-cache --update --virtual=build gcc musl-dev python3-dev libffi-dev openssl-dev cargo make && \
    pip3 install --no-cache-dir --prefer-binary azure-cli && \
    apk del build # buildkit
