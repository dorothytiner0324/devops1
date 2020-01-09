Instalacion de Gitlab 
======================

1. Para realizar la instalacion de gitlab, esta se realizará en un contenedor, para ello, vamos a usar el sgt docker-compose:
```
version: '3'

services:
   git:
    container_name: git-server
    hostname: gitlab.example.com
    ports:
      - "443:443"
      - "8888:80"
    volumes:
      - "/home/docker/gitlab/config:/etc/gitlab"
      - "/home/docker/gitlab/logs:/var/log/gitlab"
      - "/home/docker/docker/gitlab/data:/var/opt/gitlab"
    image: gitlab/gitlab-ce
    networks:
      - net
networks:
  net:
```
1. Procedemos ejecutar el `docker-compose.yml`:

> docker-compose up -d 

1. Para ingresar al Gitlab: 

> https://IP_SERVER_DOCKER:443" 

```
user: root
```
