LABORATORIO  
=============

## PARTE 1 

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
REPOSITORY          TAG                 IMAGE ID            CREATED          SIZE
imghub              latest              84175a1aeeeb    21 seconds ago      313 MB
```
Ahora, un requisito para subir una imagen a Docker Hub es que sea de la forma : 

> ID_USER_DOCKERHUB/NAME_IMAGEN:TAG 

Entonces, como nuestra imagen se creo con el nombre **imghub**, esta no cumple con el formato, para poder modificar el nombre lo haremos de la siguiente manera:

> docker tag imghub  kdetony/img1:0.1

Volvemos a ejecutar: 
```
**docker images**
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
imghub             latest              84175a1aeeeb        43 minutes ago      313 MB
kdetony/img1       0.1                 84175a1aeeeb        43 minutes ago      313 MB
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


## PARTE 2 

### Introduccion a Jenkins 
Como parte de la instalacion de Jenkins, cuando estemos en esta pantalla, debemos solo copiar el PASSWD que nos va a figurar: 

![web](https://github.com/kdetony/devops/blob/master/Images/install_jenkins.png "Web Jenkins")

## Consola de Jenkins 

#### Definiciones

* job o tareas: son optimizaciones de lo que deseemos realizar ( serie de pasos que hacen X cosas)
* personas: usuarios permitidos
* historial: cada tarea o job tiene un historico, todas las tareas de guardan.

![dashboard](https://github.com/kdetony/devops/blob/master/Images/dashboard.png "Dashboard Jenkins")

`Creación de Job`

Nos ubicamos en: *Nueva Tarea/ myjob*

OBS.

* Jenkins esta pensando en hacer tareas en servidores remotos.

Luego de dar OK!, veremos esta pantalla: 

![ex](https://github.com/kdetony/devops/blob/master/Images/ex.png "Ejecucion")


Nos deslizamos hasta la opción **EJECUTAR**
- opcion: Linea de Comandos Shell
- Guardar
- Finalmente, construir ahora

![ex1](https://github.com/kdetony/devops/blob/master/Images/ex1.png "Ejecucion")

Para ejecutar nuestro JOB simplemente hacemos clic en **"construir ahora"**.

OBS

* Cuando hacemos clic en **construir ahora**, nos aparecerá #1 que significa la primera ejecución hacemos clic en console output.

![output](https://github.com/kdetony/devops/blob/master/Images/output.png "Salida Output")

![salida](https://github.com/kdetony/devops/blob/master/Images/salida.png "Salida")

Vamos a seguir mejorando nuestro **job**, para ello hacemos clic en **configurar**. Agregamos lo siguiente en el campo **"Ejecutar"**

> echo "Hola Jenkins $(date)" >> /tmp/log

Ejecutamos nuestro job, hacemos clic en **"construir ahora"**

![job](https://github.com/kdetony/devops/blob/master/Images/job2.png "Job")

OBS 

* Esto se va a ejecutar en el contenedor de Jenkins ojo!

Por último, vamos a usar unas variables para nuestro job de la sgt manera:

Como siguiente paso, vamos a modificar el **job** con lo sgt y ejecutarlo:
```
NOMBRE="paquita"
echo "Hola $NOMBRE que estas haciendo?, ya es tarde? $(date +%F)" 
```
![job](https://github.com/kdetony/devops/blob/master/Images/job3.png "Job")

Vamos a manejar **VARIABLES DE ENTORNO**, para ello, vamos a crear un script de nombre **jenkins.sh** para ejeuctarlo via el job.
```sh
#!/bin/bash
echo "hola $nombre $apellido"
```

A `jenkins.sh` damos permisos de ejecución: chmod +x jenkins.sh, y estará ubicado en `/opt`.

Si ejecutamos el job veremos este resultado:

![job](https://github.com/kdetony/devops/blob/master/Images/job4.png "Job")

![job](https://github.com/kdetony/devops/blob/master/Images/salida1.png "Salida")

Vemos que no se estan invocando las variables ... ¿?

Esto se debe a que las variables de entorno son volatiles, nombre y apellido son variables que no son reconocidas por el script.

Vamos a pasarlo como parametros de esta forma:

![job](https://github.com/kdetony/devops/blob/master/Images/job5.png "Job")

Vemos que sigue sin funcionar, debido a que el script no sabe interpretar de forma correcta los parametros que le hemos asignado, por ello, vamos a modificar el script de la sgt forma:
```sh
#!/bin/bash
nombre=$1
apellido=$2
echo "hola $nombre $apellido"
```

Copiamos el script nuevamente al contendor, volvemos a "construir ahora" y validamos el resultado:

![job](https://github.com/kdetony/devops/blob/master/Images/salida2.png "Salida")

OBS.

* De esta forma de interactuan con scripts fuera de nuestro contenedor.

Pues bien, ahora vamos a enviarle los **PARAMETROS** adecuados, para ello, vamos a crear un nuevo JOB de nombre: **parameter**, y hacemos check en la opcion **"esta ejecucion debe parametrizarse"**

![job](https://github.com/kdetony/devops/blob/master/Images/job6.png "Job")

En añadir parametro, escogemos "parametro de cadena"
```
* Nombre: VALUE
* Valor por defecto: 20
```

![job](https://github.com/kdetony/devops/blob/master/Images/job7.png "Job")

Nos ubicamos en **EJECUTAR**

Agregamos un script de shell ( Ejecutar linea de comandos shell )

> echo "El $VALUE es un numero"

Hacemos clic en **"build parameters"**

![job](https://github.com/kdetony/devops/blob/master/Images/job8.png "Job")

Tenemos mas tipos de parametros en Jenkins que nos pueden ser de utilidad, por lo cual vamos a ver lo siguiente:

* En nuestro job "parameter" vamos a agregar la opción **Elección**

Con los campos a completar:
```
* Nombre: OPCION
* Opciones: SI, NO, Ninguno
```

![job](https://github.com/kdetony/devops/blob/master/Images/job9.png "Job")

Nos ubicamos en la parte del script y añadimos: **$OPCION**

![job](https://github.com/kdetony/devops/blob/master/Images/ejecutar.png "Ejecutar")

Tendremos esta pantalla:

![job](https://github.com/kdetony/devops/blob/master/Images/salida3.png "Salida")

Ejecutamos nuestro **job**

![job](https://github.com/kdetony/devops/blob/master/Images/salida4.png "Salida")

Vamos a añadir ahora un "valor boleano" TRUE/FALSE sobre nuestro job **parameter**

![job](https://github.com/kdetony/devops/blob/master/Images/job10.png "Job")

OBS

* Si hacemos check, el valor por defecto es TRUE

En nuestro script, añadimos la variable:

![job](https://github.com/kdetony/devops/blob/master/Images/job11.png "Job")

Ejecutamos nuestro job y debemos tener lo siguiente:

![job](https://github.com/kdetony/devops/blob/master/Images/job12.png "Job")

Y en la ejecución:

![job](https://github.com/kdetony/devops/blob/master/Images/salida5.png "Job")


### Jenkins hacia un Contenedor 

Nos conectamos a nuestro servidor Docker y en la ruta: /home/docker, vamos a crear la carpeta **app** ( dentro la carpeta app crearemos nuestro archivo Dockerfile )

Dockerfile
```
RUN yum -y install openssh-server net-tools

RUN useradd devuser && \
    echo "devuser" | passwd devuser  --stdin && mkdir /home/devuser/.ssh && \
    chmod 700 /home/devuser/.ssh

COPY llave.pub /home/devuser/.ssh/authorized_keys

RUN chown devuser:devuser  -R /home/devuser &&  chmod 600 /home/devuser/.ssh/authorized_keys

RUN /usr/sbin/sshd-keygen > /dev/null 2>&1

CMD /usr/sbin/sshd -D
```

docker-compose.yml
```
version: '3'
services:
  remote_host:
    container_name: appremoto
    image: imgapp
    ports:
      - "4321:22"
    build:
      context: app 
    networks:
      - net
networks:
  net:
```

Ejecutamos: 

> docker-compose build 
> docker-compose up -d 

Lo que hará docker-compose, es crear una con imagen centos, esta imagen tendra de nombre *imgapp* y luego creará el contenedor de nombre: *appremoto*.

Entramos en el contendor: 

> docker exec -it appremoto bash 

Y ahora, vamos a realizar 2 acciones, primero, crear un usuario: **devuser** y como segundo paso, crear un password para **root**. 

> useradd -d /home/devuser -m devuser
> passwd devuser 
> passwd root 

Acto siguiente desde la consola, vamos a activar el plugin de SSH y realizar la configuracion del contenedor que hemos creado.

En el menú de Jenkins:

**Administrar Jenkins/Administrar plugins**

Acontinuación vamos a crear las credenciales para nuestro contendor, para ello hacemos clic en **credentials**

![ssh](https://github.com/kdetony/devops/blob/master/Images/configssh.png "Config_SSH")

![ssh](https://github.com/kdetony/devops/blob/master/Images/configssh1.png "Config_SSH")

Bien, ahora vamos a agregar las credenciales:

![ssh](https://github.com/kdetony/devops/blob/master/Images/configssh2.png "Config_SSH")

Al finalizar, debemos tener esta pantalla:

![ssh](https://github.com/kdetony/devops/blob/master/Images/configssh3.png "Config_SSH")

Bien, Con el plugin activado y la credencial creada, vamos a configurar nuestro contenedor para que Jenkins pueda conectarse a el.

**Administrar Jenkins/Configurar el Sistema**

Vamos a buscar la opción: **SSH remote hosts**

![ssh](https://github.com/kdetony/devops/blob/master/Images/configssh4.png "Config_SSH")

Ingresamos estos datos:
```
* HOSTNAME: IP_PUBLICA_SERVER_DOCKER
* Puerto: 4321
```

![ssh](https://github.com/kdetony/devops/blob/master/Images/configssh5.png "Config_SSH")

Hacemos clic en el boton *Check Connection* y el resultado debe ser `"Successfull conection"`

Para guardar la configuracion, nos posicionamos en la ultima parte del menu, y damos clic en "guardar"

Hasta ahora, ya tenemos todo listo para ejecutar/lanzar nuestro primer JOB en nuestro contenedor, para ello, vamos a crear una tarea/job:
```
* Nombre Tarea: valida-tarea
* Crear proyecto de libre estilo
```

Nos ubicamos en la opcion: *Ejecutar* y escogemos **Ejecutar shell script on remote host using ssh**:

![job](https://github.com/kdetony/devops/blob/master/Images/job13.png "Job")

Vamos a crear un pequeño mensaje y guardarlo en **/tmp/log.txt** en el contenedor *centos*.

![job](https://github.com/kdetony/devops/blob/master/Images/salida6.png "Salida")

Pues bien, vamos a ejecutar nuestro job, hacemos clic en construir ahora

Y validamos nuestro job:

![job](https://github.com/kdetony/devops/blob/master/Images/salida7.png "Salida")

OBS.

* Recordar que **devuser** debe tener permisos de **RWX** si desea escribir/modificar/ejcutar el contenido en un directorio donde no sea el owner.
* Para validar nuestro JOB en el contenedor: 
> docker exec -it appremoto bash 

`Actividad`
1. Crear llaves SSH en el contenedor para los usuarios:
* devuser
* root 
1. Configurar las credenciales para los usuarios mencionados en jenkins. 




