```
version: '3.7'

networks:
  jenkins-ssh-slave:
    name: jenkins-ssh-slave
    driver: bridge

services:
  jenkins-ssh-slave:
    container_name: jenkins-ssh-slave
    image: pearbox/jenkins-ssh-slave
    environment:
      - JENKINS_SLAVE_SSH_PUBKEY=<put your ssh-rsa here>
    restart: unless-stopped
    ports:
      - "2022:22"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    networks:
      - jenkins-ssh-slave
```
