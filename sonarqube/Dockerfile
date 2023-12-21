FROM alpine

LABEL maintainer="cuteribs <ericfine1981@live.com>"

ENV VERSION=10.1.0.73491

EXPOSE 9000/tcp

RUN apk add --no-cache openjdk17-jre unzip && \
	wget -qO- https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$VERSION.zip | busybox unzip - && \
	mv sonarqube-$VERSION /sonarqube && \
	rm -rf /sonarqube/bin/* && \
	addgroup -S sonar && adduser -D -H -S -G sonar -s /bin/sh sonar && \
	chown -R sonar:sonar /sonarqube

VOLUME /sonarqube/conf
VOLUME /sonarqube/data
VOLUME /sonarqube/logs
VOLUME /sonarqube/extensions

WORKDIR /sonarqube

USER sonar

CMD java -jar /sonarqube/lib/sonar-application-$VERSION.jar -Dsonar.log.console=true
