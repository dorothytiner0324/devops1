LABORATORIO  
=============

### Introduccion Docker

es un proyecto de código abierto que automatiza el despliegue de aplicaciones dentro de contenedores de software, proporcionando una capa adicional de abstracción y automatización de virtualización de aplicaciones en múltiples sistemas operativo. <fuente *wikipedia*>

Vamos a inicializar un contenedor, para ello vamos a ejecutar el siguiente comando:

> docker run hello-world

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


### Volumenes

Existen tres maneras distintas de gestionar volúmenes para contenedores, dos de ellas serán persistentes y la tercera no. Al decir que “no es persistente” queremos decir que cuando un contenedor se destruya todos los ficheros almacenados en esa carpeta se borrarán y cuando creemos un nuevo contenedor comenzaremos sin ningún dato.

(a)Volúmen: Es la manera sencilla y predefinida para almacenar todos los ficheros (salvo unas pocas excepciones) de un contenedor, usará el espacio de nuestro equipo real y en “/var/lib/docker/volumes” creará una carpeta para cada contenedor.

(b)Volúmen bind / conectados: Es una manera de asociar una carpeta de nuestro equipo real y mapearla como una carpeta dentro de un contenedor. Este sistema nos permite ver esa carpeta desde el contenedor y también desde nuestro equipo real.

(c)TMPFS (temporal file system): es una manera de montar carpetas temporales en un contenedor.Usan la RAM del equipo y su contenido desaparece al parar el contenedor. En caso de tener poca RAM, los ficheros se pasarán al SWAP del equipo real. Crearemos otro contenedor donde una determinada carpeta de un servidor web será “temporal”.

Para crear un volumen para un contenedor: 

> docker run -d --name db -p 3306:3306 -e "MYSQL_ROOT_PASSWORD=123456" -v /opt/mysql:/var/lib/mysql mysql:5.7

> docker run -d --name db -p 3306:3306 -e "MYSQL_ROOT_PASSWORD=123456" -v SG_DATA:/var/lib/mysql mysql:5.7

> docker run -d -it --name ubuntu3 --tmpfs /var/html/temporal  centos

### Redes

Existen 3 redes preconfiguradas en Docker,

(a)Bridge. La red standard que usarán todos los contenedores.

(b)Host. El contenedor usará el mismo IP del servidor real que tengamos.

(c)None. Se utiliza para indicar que un contenedor no tiene asignada una red.

Si queremos crear una RED:

> docker network create labnet

Creamos una red especifica:

> docker network create **-d** bridge --subnet 192.168.0.0/24 --gateway 192.168.0.1 labprd

Asignando la red a un contenedor:

> docker run -d --network lab-net --name dev2 -ti centos

### Docker Compose

es una herramienta que permite simplificar el uso de Docker, generando scripts que facilitan el diseño y la construcción de servicios. Aquí resumimos algunos tips.
Con Docker Compose puedes crear diferentes contenedores y al mismo tiempo, en cada contenedor, diferentes servicios. En vez de utilizar una serie de comandos bash y scripts, Docker Compose implementa recetas similares a las de Ansible, para poder instruir al engine a realizar tareas, programáticamente.

Ya contamos con Docker, ahora, vamos a instalar docker-compose: 

> curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

> chmod +x /usr/local/bin/docker-compose

Vamos a crear el siguiente Dockerfile: 

```
FROM centos:7
RUN yum update -y
RUN yum -y install httpd
RUN echo 'Hello, web dockeri con docker-compose' > /var/www/html/index.html
ENTRYPOINT ["apachectl"]
CMD ["-D", "FOREGROUND"]
```

Ahora usaremos el siguiente docker-compose.yml 

```
version: '3'
services:
  db:
     image: mysql
     container_name: mysql_db
     restart: always
     environment:
        - MYSQL_ROOT_PASSWORD="secret"
  web:
    image: apache
    build: .
    depends_on:
       - db
    container_name: apache_web
    restart: always
    ports:
      - "8080:80"
```

Procedemos a ejecutar:

> docker-compose up -d 

Validamos la ejecucion del contenedor, asi como el nombre de la imagen creada.

OBS.

OBS2.
1.  -d es para enviar la ejecución a segundo plano

2.- Si queremos ver la salida completa:

> docker-compose logs -f -t

3.- Si queremos detenerlo:
> docker-compose down

4.- Ver que está ejecutando:
> docker-compose ps 

5.- Si queremos ejecutar alguna instrucción en el contenedor:

> docker-compose exec ID_CONTAINER bash

### Dockerhub

Docker Hub, es el repositorio comunitario que tenemos para descargar imagenes y tambien para subirlas, dicho esto, vamos a realizar un ejemplo de como subir una imagen personalizada a Docker Hub, para ello, debemos primero tener una cuenta en Docker Hub.
Lo que haremos ahora será crear una imagen PERSONALIZADA, vamos a tomar como referencia este Dockerfile: 

```
FROM centos:7
RUN yum -y install httpd
WORKDIR /var/www/html
ENV conte Mi Web en DockerHub  
RUN echo "$conte" > /var/www/html/index.html                                                                                                                     
CMD [“/usr/sbin/httpd”, ”-DFOREGROUND”]
EXPOSE 80
```

OBS. 
- Vamos a colocar este Dockerfile en la carpeta: hub para lo cual debemos previamente crearla. Y lo compilamos: 

> docker build -t  imghub  . 

Con nuestra imagen ya creada, la listamos con : 
```
**docker images**
REPOSITORY          TAG                 IMAGE ID            CREATED                          SIZE
imghub               latest              84175a1aeeeb    21 seconds ago      313 MB
```
Ahora, un requisito para subir una imagen a Docker Hub es que sea de la forma : 

> ID_USER_DOCKERHUB/NAME_IMAGEN:TAG 

Entonces, como nuestra imagen se creo con el nombre **imghub**, esta no cumple con el formato, para poder modificar el nombre lo haremos de la siguiente manera:

> docker tag imghub  kdetony/img1:0.1

Volvemos a ejecutar: 
```
**docker images**
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
imghub               latest              84175a1aeeeb        43 minutes ago      313 MB
kdetony/img1        0.1                 84175a1aeeeb        43 minutes ago      313 MB
```

Y ahora procedemos a subir nuestra imagen:
```
**docker push kdetony/imghub:0.1**

The push refers to repository [docker.io/kdetony/imghub]
3023d784d755: Preparing
3dd57181f9e5: Preparing
877b494a9f30: Preparing
denied: requested access to the resource is denied
```

Esto se debe a que no hemos realizado un login previo:

> docker login
```
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username: kdetony
Password:
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
```

Repetimos el paso anterior:

> docker push kdetony/img1:0.1
```
The push refers to repository [docker.io/kdetony/img1]
3023d784d755: Pushed
3dd57181f9e5: Pushed
877b494a9f30: Mounted from library/centos
0.1: digest: sha256:2714c23cdcdb21ae24575acbd51f752080a7c2aec1f608122b887006847bba93 size: 948
``` 

Revisamos que nuestra imagen haya subido de forma correcta en Docker Hub.


