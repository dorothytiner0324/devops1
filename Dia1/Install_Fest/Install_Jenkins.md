# Install Jenkins
es un servidor de integración continua, gratuito, open-source y actualmente uno de los más empleados para esta función. Además es muy fácil de utilizar.
Esta herramienta, proviene de otra similar llamada Hudson, ideada por Kohsuke Kawaguchi, que trabajaba en Sun. Unos años después de que Oracle comprara Sun, la comunidad de Hudson decidió renombrar el proyecto a Jenkins, migrar el código a Github y continuar el trabajo desde ahí. No obstante, Oracle ha seguido desde entonces manteniendo y trabajando en Hudson.

### Pre-Requisitos
1. 1 instancia en Digital Ocean ( 2 GB + 2 CPU )
   - Validar acceso a internet
1. Java v1.8.x 

## Instalando Java
1. Instalamos Java (openjdk)
   ```
   yum install java-1.8*
   ```

1. Confirmar version de Java y JAVA_HOME
   ```sh
   java -version
   find /usr/lib/jvm/java-1.8* | head -n 3
   JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.XXXX.el8_0.x86_64
   export JAVA_HOME
   PATH=$PATH:$JAVA_HOME
    # Para hacerlo permanente, debemos agregarlo en .bash_profile para un usuario determinado, ejm. root, sysadmin, etc
   vi ~/.bash_profile
   ```
   _La salida de lo ejecutado anteriormente sera:_
    ```sh
   [root@~]# java -version
   openjdk version "1.8.0_151"
   OpenJDK Runtime Environment (build 1.8.0_151-b12)
   OpenJDK 64-Bit Server VM (build 25.151-b12, mixed mode)
   ```

## Instalando Jenkins
 You can install jenkins using the rpm or by setting up the repo. We will set up the repo so that we can update it easily in the future.
1. Descargamos la ultima version de jenkins desde: https://pkg.jenkins.io/redhat-stable/   e instalamos:
   ```sh
   yum -y install wget
   wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
   rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
   yum -y install jenkins
   ```

   ### Start Jenkins
   ```sh
   # Start jenkins service
   service jenkins start

   chkconfig jenkins on
   ```

   ### Accediendo a Jenkins
   Por default jenkins usa el puerto `8080`, para ingresar a la interfaz gráfica:
   ```sh
   http://IP_SERVIDOR:8080
   ```
  #### Configurando Jenkins
- El usuario por defecto:  `admin`
- El passwd inicial para la instalacion se encuentra en:`/var/lib/jenkins/secrets/initialAdminPassword`
- Escogemos los "Plugins por defecto"; _estos pueden configurarse mas adelante_
- Si deseamos cambiar el password de `admin`:
   - `Admin` > `Configure` > `Password`
- Configurando el path de `java`
  - `Manage Jenkins` > `Global Tool Configuration` > `JDK`  

![jdk](https://github.com/kdetony/devops/blob/master/Images/jdk.png "Configure JDK")

OBS.

* Le quitamos el check a *Install automatically*

![jdk](https://github.com/kdetony/devops/blob/master/Images/jdk1.png "Configure JDK")

OBS.

* Para obtener el JAVA_HOME, ejecutamos en nuestra consola:

> echo $JAVA_HOME

Finalizamos haciendo clic en **APPLY**

