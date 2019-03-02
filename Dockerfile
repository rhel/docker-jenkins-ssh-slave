FROM docker:18
LABEL MAINTAINER="Artyom Nosov <chip@unixstyle.ru>"

ARG USER=jenkins
ARG GROUP=jenkins
ARG UID=3000
ARG GID=3000
ARG JENKINS_AGENT_HOME=/home/${USER}
ARG DOCKER_COMPOSE_VERSION=1.22.0

ENV JENKINS_AGENT_HOME $JENKINS_AGENT_HOME

RUN addgroup -g $GID $GROUP \
 && adduser -D -h "$JENKINS_AGENT_HOME" -u "$UID" -G "$GROUP" -s /bin/bash "$USER" \
 && passwd -u $USER

RUN apk update \
    && apk add --no-cache bash openssh openjdk8 git py-pip subversion curl wget
RUN sed -i /etc/ssh/sshd_config \
        -e 's/#PermitRootLogin.*/PermitRootLogin no/' \
        -e 's/#RSAAuthentication.*/RSAAuthentication yes/'  \
        -e 's/#PasswordAuthentication.*/PasswordAuthentication no/' \
        -e 's/#SyslogFacility.*/SyslogFacility AUTH/' \
        -e 's/#LogLevel.*/LogLevel INFO/' \
    && mkdir /var/run/sshd

RUN pip install --no-cache-dir docker-compose==${DOCKER_COMPOSE_VERSION}

RUN delgroup ping \
    && addgroup -g 999 docker \
    && addgroup $USER docker \
    && ln -s /usr/local/bin/docker /usr/bin/docker 

VOLUME "$JENKINS_AGENT_HOME"
WORKDIR "$JENKINS_AGENT_HOME"

COPY entrypoint /usr/local/bin/entrypoint

EXPOSE 22

ENTRYPOINT ["entrypoint"]
