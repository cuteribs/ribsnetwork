FROM mcr.microsoft.com/dotnet/aspnet:6.0-alpine

RUN apk add --no-cache icu-libs icu-data-full

ENV ASPNETCORE_ENVIRONMENT=Development
	
VOLUME /app
VOLUME /root/.azure
VOLUME /root/.microsoft/usersecrets
	
WORKDIR /app
