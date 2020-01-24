Instalacion de Docker
======================

Para realizar la instalación de docker en un entorno linux, ya sea debian, ubuntu, Centos, haremos uso del siguiente script de instalación:

> curl -fsSL https://get.docker.com -o get-docker.sh

Ahora lo ejecutamos:

> sh get-docker.sh

Para validar la versión de docker:

> docker version

Y si queremos saber otro tipo de recursos:

> docker info
```
cat /etc/docker/daemon.json
 {"hosts": ["tcp://0.0.0.0:2375", "unix:///var/run/docker.sock"]}
 
 mkdir -p /etc/systemd/system/docker.service.d
 
 touch override.conf
 
 [Service]
 ExecStart=
 ExecStart=/usr/bin/dockerd
```

> systemctl daemon-reload

> systemctl restart docker



