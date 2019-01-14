FROM docker:18
LABEL MAINTAINER="Artyom Nosov <chip@unixstyle.ru>"

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG JENKINS_AGENT_HOME=/home/${user}
ARG DOCKER_COMPOSE_VERSION=1.22.0

ENV JENKINS_AGENT_HOME ${JENKINS_AGENT_HOME}

RUN addgroup -g ${gid} ${group} \
	&& adduser -D -h "${JENKINS_AGENT_HOME}" -u "${uid}" -G "${group}" -s /bin/bash "${user}" \
	&& passwd -u jenkins

RUN apk update \
    && apk add --no-cache bash openssh openjdk8 git subversion curl wget 
RUN sed -i /etc/ssh/sshd_config \
        -e 's/#PermitRootLogin.*/PermitRootLogin no/' \
        -e 's/#RSAAuthentication.*/RSAAuthentication yes/'  \
        -e 's/#PasswordAuthentication.*/PasswordAuthentication no/' \
        -e 's/#SyslogFacility.*/SyslogFacility AUTH/' \
        -e 's/#LogLevel.*/LogLevel INFO/' \
    && mkdir /var/run/sshd
RUN wget -O /usr/local/bin/docker-compose https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m) \
    && chmod +x /usr/local/bin/docker-compose

RUN delgroup ping \
    && addgroup -g 999 docker \
    && addgroup jenkins docker \
    && ln -s /usr/local/bin/docker /usr/bin/docker 

VOLUME "${JENKINS_AGENT_HOME}" "/tmp" "/run"
WORKDIR "${JENKINS_AGENT_HOME}"

COPY entrypoint /usr/local/bin/entrypoint

EXPOSE 22

ENTRYPOINT ["entrypoint"]

