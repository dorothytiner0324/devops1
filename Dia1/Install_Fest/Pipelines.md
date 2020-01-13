Procedimiento
================
Vamos a trabajar en el Servidor Jenkins

OBS.

* Debemos tener habilitados los plugins: **publish over ssh, ssh, ssh agent**

# Scripts
0. Creamos la carpeta **/var/lib/jenkins/app**, y aqui estarán todos los scripts.

1. Primer script: *build.sh*
```sh
#!/bin/bash
echo "#########"
echo "Build"
echo "########"

rm -rf /tmp/hello-world
cd /tmp
git clone https://github.com/yankils/hello-world.git
cd hello-world
/opt/maven/bin/mvn package
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
/opt/maven/bin/mvn test
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

HOST="IP_SERVER"
DIR="/tmp/hello-world/webapp/target"

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

HOST="165.227.194.119"
DIR="/tmp/hello-world/webapp/target"

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
> chown -R jenkins.jenkins app 

# Pipeline
```
pipeline {

    agent any

    stages {

        stage('Build') { 
            steps {
            dir ('/var/lib/jenkins/app') { 
            sh './build.sh'
             }
            } 
        }                        
        stage('Test') {
            steps {
            dir ('/var/lib/jenkins/app') {
		sh './test.sh'
            }
            }
        }
        stage('Push') {
            steps {
            dir ('/var/lib/jenkins/app') {
		sh './push.sh'
            }
            }
        }
        stage('Deploy') {
            steps {
                dir ('/var/lib/jenkins/app') {
    	     sh './deploy.sh'
                }
            }
        }
    }
}
```
