#### Servidor donde se instalará
1. Jenkins server

#### Instalando Maven en Jenkins
1. Descargamos maven de: **https://maven.apache.org/download.cgi**. En nuestro caso, usaremos la ruta: **/opt/maven** como directorio de instalación.
 - Link : https://maven.apache.org/download.cgi
    ```sh
     # En /opt creamos el directorio maven
     mkdir /opt/maven
     cd /opt/maven
     # Descargando maven versión 3.6.0
     wget http://mirrors.estointernet.in/apache/maven/maven-3/3.6.1/binaries/apache-maven-3.6.1-bin.tar.gz
     tar -xvzf apache-maven-3.6.1-bin.tar.gz
     ```
	
1. Configuramos **M2_HOME** y **M2** en **.bash_profile**, esta configuracion puede ser para cualquier usuario ojo!, en nuestro caso usaremos root para esta configuración: 
   ```sh
   vi ~/.bash_profile
   M2_HOME=/opt/maven/apache-maven-3.6.1
   M2=$M2_HOME/bin
   PAHT=<Existing_PATH>:$M2_HOME:$M2
   ```
#### Checkpoint 
1. Realizamos un logoff y nos volvemos a logear para validar la version de maven:
  
    ```sh
    mvn --version
    ```
    
#### Instalacion de Plugin Maven en Jenkins   

Hasta ahora hemos completado la instalación de maven, ahora vamos a instalar el plugin de Maven en Jenkins, para lo cual realizaremos lo sgt:

### En el dashboard de Jenkins
1. Instalamos el plugin de maven:
  - `Manage Jenkins` > `Jenkins Plugins` > `available` > `Maven Invoker`
  - `Manage Jenkins` > `Jenkins Plugins` > `available` > `Maven Integration`

2. Configurando el PATH de Maven
  - `Manage Jenkins` > `Global Tool Configuration` > `Maven`
