Procedimiento
================

# Scripts
0. Creamos la carpeta **/deploy/hello-world** en el servidor Jenkins, y en esta carpeta crearemos todos los scripts.

1. Primer script: *build.sh*
```sh
#!/bin/bash
echo "#########"
echo "Build"
echo "########"

cd /tmp
git clone https://IP_SERVER_GITLAB:XXX/hello-world.git 
cd hello-world
mvn package 
```
OBS.
* La ruta donde se genera el *war* deberia ser: /tmp/hello-world/webapp/target/webapp.war

2. Segundo script: *test.sh* 
```sh
#!/bin/bash
echo "########"
echo "Test"
echo "########"

cd /tmp/hello-world
mvn test
```
OBS.
* El resultado de nuestra prueba unitaria ( unit test ) se encuentra en: */tmp/hello-world/webapp/target/surefire-reports*.


3. Tercer script:  *push.sh*
Para este punto, y hasta este momento, tenemos la NECESIDAD de probar nuestro artefacto creado, por lo cual es recomendable tener un ambiente o servidor
donde desplegar y hacer validaciones, para necesitamos o un contenedor/instancia/VM para empezar a trabajar.
```sh
#!/bin/bash
echo "##########"
echo "Push"
echo "##########"

HOST=165.227.194.119
DIR=/tmp/hello-world/webapp/target

ssh $HOST docker stop $(docker ps -qa)
ssh $HOST docker run --rm -dit -p 9090:8080 --name webtest tomcat:8.5
scp $DIR/webapp.war $HOST:/tmp/ 
ssh $HOST docker cp /tmp/webapp.war /usr/local/tomcat/webapps/

```
OBS.
* Debemos copiar tomcat-users.xml en el contendor creado
* Podemos crear un Dockerfile y agilizar aun este proceso

4. Cuarto script: *deploy.sh*
```sh
#!/bin/bash
echo "##########"
echo "Deploy PRD"
echo "##########"

HOST=165.227.194.119
DIR=/tmp/hello-world/webapp/target

ssh $HOST docker stop $(docker ps -qa)
ssh $HOST docker run --rm -dit -p 9595:8080 --name webprd tomcat:8.5
ssh $HOST mkdir -p /tmp/prd
scp $DIR/webapp.war $HOST:/tmp/prd
ssh $HOST docker cp /tmp/prd/webapp.war /usr/local/tomcat/webapps/
ssh $HOST docker restart webprd
```
OBS.
* Debemos copiar tomcat-users.xml en el contendor creado
* Podemos crear un Dockerfile y agilizar aun este proceso


# Pipeline

```
pipeline {

    agent any

    stages {

        stage('Build') {
            steps {
        sh './deploy/hello-world/build.sh'   
            }
        }                        
        stage('Test') {
            steps {
		sh './deploy/hello-world/test.sh' 
            }
        }
        stage('Push') {
            steps {
		sh './deploy/hello-world/push.sh'
            }
        }
        stage('Deploy') {
            steps {
       		sh './deploy/hello-world/deploy.sh'
            }
        }
    }
}
```
