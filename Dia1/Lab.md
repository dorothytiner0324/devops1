LABORATORIO  
=============

### Introduccion Docker

es un proyecto de código abierto que automatiza el despliegue de aplicaciones dentro de contenedores de software, proporcionando una capa adicional de abstracción y automatización de virtualización de aplicaciones en múltiples sistemas operativo. <fuente *wikipedia*>

Vamos a inicializar un contenedor, para ello vamos a ejecutar el siguiente comando:


```$docker run hello-world```

OBS.

* Si no existe una imagen previa, un contenedor no puede inicializar.

### Comandos Docker

- docker start container
- docker stop container
- docker run container
- docker ps
- docker system df  -v
- docker inspect 
- docker cp 
- docker exec 
- docker top
- docker stats --all

### Imagenes

- Buscar una imagen: ```$docker search image```
- Descargar una imagen: ```$docker pull image```
- Listar imagenes: ```$docker image```
- Borrar imagen: ```$docker rmi $NAME```

### Contenedores

- Listar contendor: 
> docker ps -a

- Ejecutar un contenedor: 

> docker run httpd

¿Que ocurre cuando ejecutamos este comando?

Ahora vamos a ejecutarlo de la siguiente manera:

> docker run --name superapi httpd

> docker run -dit --name superapi nginx

OBS.

* Ejecutar el contenedor de la siguiente forma:

> docker run -dit --name superapi1 -p :80 nginx


- Eliminar un contenedor: 

> docker rm -fv superapi

**Actividad**: 

* buscar e instalar la imagen de ubuntu y crear el contenedor de nombre **stux**,  el puerto 80 debe visualizarse por el puerto 8282 en el HOST.


### Dockerfile

Un Dockerfile es un archivo de texto plano que contiene las instrucciones necesarias para automatizar la creación de una **imagen** que será utilizada posteriormente para la ejecución de instancias específicas ( i.e. contenedores ).

Ejm.
```
FROM centos:7

RUN yum -y install httpd

CMD apachectl -DFOREGROUND
```

Para ejecutar un **Dockerfile**, usamos: 

> docker build --tag myapache .

Con esto configuramos nuestra imagen de Centos7 con apache ( httpd ), ahora iniciamos el contenedor de nombre *apachetest*: 

> docker run -d -p 80:80 apachetest


Vamos a agregar un **index.html** en nuestra imagen para ello, en nuestro Dockerfile

```
FROM centos

RUN yum -y install httpd

WORKDIR /var/www/html

COPY index.html .

ENV contenido prueba web 

RUN echo "$contenido" > /var/www/html/prueba.html                                                                                                                     
CMD apachectl -DFOREGROUND
```

OBS.

Entrypoint VS CMD ?

En la carpeta donde nos encontramos, vamos a crear el sgt index.html 

> echo "Hola Docker test run" > index.html

Construimos nuestra imagen personalizada: 

> docker build -t apache-new .

Y ahora iniciamos el contenedor: 

> docker run -dit --name webprd apache-new


## Volumenes




Para crear un volumen para un contenedor: 

```$docker run -d --name db -p 3306:3306 -e "MYSQL_ROOT_PASSWORD=123456" -v /opt/mysql:/var/lib/mysql mysql:5.7```



### Redes


Si queremos crear una RED:
```$docker network create lab-net```

```docker network create **-d** bridge --subnet 192.168.0.0/24 --gateway 192.168.0.1 lab-net```

Asignando la red a un contenedor
```$docker run -d --network lab-net --name dev2 -ti centos```



### Docker Compose




### Dockerhub
