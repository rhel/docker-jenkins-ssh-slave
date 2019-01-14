version: '3.7'

volumes:
  jenkins-ssh-slave-home:
    name: jenkins-ssh-slave-home
  jenkins-ssh-slave-tmp:
    name: jenkins-ssh-slave-tmp
  jenkins-ssh-slave-run:
    name: jenkins-ssh-slave-run

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
      - jenkins-ssh-slave-home:/home/jenkins
      - jenkins-ssh-slave-tmp:/tmp
      - jenkins-ssh-slave-run:/run
      - /var/run/docker.sock:/var/run/docker.sock
    networks:
      - jenkins-ssh-slave

