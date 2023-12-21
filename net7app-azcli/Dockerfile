FROM mcr.microsoft.com/dotnet/aspnet:7.0-alpine

RUN apk add --no-cache icu-libs icu-data-full && \
	apk add --no-cache --update python3 py3-pip && \
    apk add --no-cache --update --virtual=build gcc musl-dev python3-dev libffi-dev openssl-dev cargo make && \
    pip3 install --no-cache-dir --prefer-binary azure-cli && \
    apk del build # buildkit

ENV ASPNETCORE_ENVIRONMENT=Development
	
VOLUME /app
VOLUME /root/.azure
VOLUME /root/.microsoft/usersecrets
	
WORKDIR /app


