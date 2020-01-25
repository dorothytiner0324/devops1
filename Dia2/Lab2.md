### Jenkins con ansible

Para ejecutar playbooks desde Jenkins, primero debemos tener instalado el plugin de **ansible** en Jenkins, quien sera nuestro master.

en **/var/lib/jenkins**, creamos la carpeta **ansible**, y dentro de ella vamos a descargar el siguiente ansible.cfg:

> wget https://raw.githubusercontent.com/ansible/ansible/devel/examples/ansible.cfg

En el archivo ansible.cfg, realizamos la sgt modificacion: 

> inventory  = /var/lib/jenkins/ansible/hosts

A su vez, vamos a crear el archivo **hosts** con el siguiente contenido:
```
[all]
IP_SERVER_DOCKER
IP_SERVER_JENKINS

[nodos]
IP_SERVER_DOCKER
```

OBS.

* La carpeta ansible tiene que tener como owner al usuario jenkins. 

Ahora, con estas configuraciones, en el servidor Jenkins, donde tenemos instalado Ansible, vamos a ejecutar lo siguiente:

> ansible all -m ping

OBS.

Este comando debe ejecutarse dentro de /var/lib/jenkins/ansible

Vamos a ejecutar ahora otros ejemplos:

> ansible all -a "/bin/echo hello"

> ansible all -m shell -a 'ls -lta /tmp/'

Bien, con estos ejemplos, vamos ahora a ejecutar un playbook sencillo:

Creamos el archivo playbook.yml en /var/lib/jenkins/ansible
```   
- hosts: all
  tasks:
   - shell: echo $(date) > /tmp/horaa-ansible
```

Lo ejecutamos:

> ansible-playbook -i hosts playbook.yml

Validamos en los servidores en la carpeta /tmp la ejecucion del playbook.

Lo que ahora ahora, sera realizarlo desde Jenkins, para ello, vamos a crear un job de nombre ansible / Proyecto de estilo Libre / Ejecutar / Invoke ansible playbook 

La salida debe ser similar a esta:

![ansible](https://github.com/kdetony/devops/blob/master/Images/ansible.png "Ansible")

Actividad
===============

1. ¿Qué ocurriria si creamos un repositorio y subimos en el nuestro playbook + hosts?
2. En Jenkins, en la opcion: "Fuentes de repositorios" agregar el repositorio.

Para realizar esta actividad y ver el proceso de CI Jenkins/Ansible/Gitlab

Creamos en gitlab:
```
Group: ICA
Project: ANSBILE
```
**El proyecto y grupo deben ser publicos**

En el servidor Jenkins, con el usuario *jenkins* vamos a clonar el repositorio creado en */tmp*

En la carpeta clonada, vamos a copiar, hosts y ejemplo.yml, posterior a ello lo subiermos al repositorio.

> git add

> git commit -m 'archivos ansible'

> git push

* Crear un job en jenkins de nombre: test-ci para realizar la ejecucion del playbook.

Introduccion a Kubernetes
=======================

Para empezar a trabajar con Kubernetes, vamos a plantear la siguiente arquitectura:

* 1 Master
* 2 Nodes - Workers

Vamos a crear de forma "grafica/manual" nuestro Cluster de Kubernetes, para ello, vamos a ir a esta opcion en Digital Ocean:

![kubernetes](https://github.com/kdetony/devops/blob/master/Images/k8s.png "k8s")

Ahora escogeremos esta opcion:

![kubernetes](https://github.com/kdetony/devops/blob/master/Images/k8s1.png "k8s")

Vamos a trabajar con esta version de kubernetes:

![kubernetes](https://github.com/kdetony/devops/blob/master/Images/k8s2.png "k8s")

Y completamos nuestro cluster escogiendo el nombre para nuestro *pool*: **devops** con 2 **nodos**

![kubernetes](https://github.com/kdetony/devops/blob/master/Images/k8s3.png "k8s")

Para finalizar, asignamos el nombre de *scluster* a nuestro cluster de kubernetes.

![kubernetes](https://github.com/kdetony/devops/blob/master/Images/k8s4.png "k8s")

Al finalizar, tendremos este pantalla, y hacemos clic en **Get Started**

![kubernetes](https://github.com/kdetony/devops/blob/master/Images/k8s5.png "k8s")

En esta pantalla, hacemos clic en **continue**

![kubernetes](https://github.com/kdetony/devops/blob/master/Images/k8s6.png "k8s")

Antes de continuar, lo que haremos es instalar **kubectl**, esta acción lo realizaremos en el **servidor Jenkins**: 
```
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
yum install -y kubectl
```
Ahora, con **kubectl** instalador, vamos a continuar con la instalacion, copiamos la linea que nos indica la pantalla
```
cd ~/.kube && kubectl --kubeconfig="scluster-kubeconfig.yaml" get nodes
```
![kubernetes](https://github.com/kdetony/devops/blob/master/Images/k8s7.png "k8s")

Pos ultimo, hacemos clic en **Great, I'm Done**

![kubernetes](https://github.com/kdetony/devops/blob/master/Images/k8s8.png "k8s")

Bien, ya contamos con nuestro cluster de kubernetes READY!, pero como hemos visto, si bien el tiempo de configuración es casi infimo, porque no hacerlo mediante *infraestructura como codigo*?, para ello veremos lo sgt.

Terraform - Infraestructura como Codigo
=======================================

Es un software de infraestructura como código (infrastructure as code) desarrollado por HashiCorp. Permite a los usuarios definir y configurar la infraestructura de un centro de datos en un lenguaje de alto nivel, generando un plan de ejecución para desplegar la infraestructura en OpenStack, por ejemplo, u otros proveedores de servicio tales como AWS, IBM Cloud (antiguamente Bluemix), Google Cloud Platform, Linode, DigitalOcean, Microsoft Azure, Oracle Cloud Infrastructure o VMware vSphere. La infraestructura se define utilizando la sintaxis de configuración de HashiCorp denominada HashiCorp Configuration Language (HCL) o, en su defecto, el formato JSON.

Con Terraform ya instalado, vamos a proceder a crear todo el ambiente necesario para desplegar nuestro cluster: 

Copiamos todos los archivos TF que tenemos en nuestra carpeta **REFS/Terraform/Infra** en nuestro **servidor Jenkins** 
en la ruta **/root/infra** y los archivos de **REFS/Terraform/App**  a **/root/app** 

Instalación
============= 

> wget https://releases.hashicorp.com/terraform/0.12.19/terraform_0.12.19_linux_amd64.zip

> yum -y install unzip 

> unzip terraform_0.12.19_linux_amd64.zip

> mv terraform /usr/local/bin 

Configuracion de Token Digital Ocean
=============================

Para realizar la configuracion de nuestro Token, nos ubicamos en esta parte de nuestro dashboard en digital ocean

![kubernetes](https://github.com/kdetony/devops/blob/master/Images/k8s9.png "k8s")

En esta pantalla rellenamos los campos como visualizamos:

![kubernetes](https://github.com/kdetony/devops/blob/master/Images/k8s10.png "k8s")

Y anotamos nuestro Token generado:

![kubernetes](https://github.com/kdetony/devops/blob/master/Images/k8s11.png "k8s")

Finalizamos ejecutando este pequeño script de nombre **token.sh** en nuestra consola:
```sh
#!/bin/bash
export DIGITALOCEAN_TOKEN='TOKEN_GENERADO'
``` 

Infraestructura como Código
=============================

Ahora, regresamos a nuestra carpeta **/root/infra** y vamos a ejecutar lo siguiente:

> terraform init 

> terraform plan 

### OBS.

* En caso de solicitar el token de DigitalOcean, lo ingresamos sin problema ;) 

> terraform apply 

Configuracion del cluster
========================

Con el archivo **kubeconfig.yaml** descargado, vamos ahora validar nuestro acceso al cluster, para ello vamos a ejecutar:

> kubectl config --kubeconfig=kubeconfig.yaml get nodes

### OBS.
Si queremos trabajar de forma "nativa" con el archivo kubeconfig.yaml realizamos la sgt configuración: 

> mkdir -p $HOME/.kube

> mv kubeconfig.yaml  $HOME/.kube/config

> kubectl get pods 

## Comandos a usar

* Listar todos los componentes para kubernetes
> kubectl get all 

* Ejecutar un archivo yaml 
> kubectl apply -f file.yml

> kubectl apply -f /DIR/

* Listar Nodos:
  * kubectl get nodes
  * kubectl get nodes -o wide 

* Listar Namespaces:
  * kubectl get ns 

* Listart Servicios:
  * kubectl get svc
  
 **OBSERVACION**
 ```
 apiVersion: apps/v1, para k8s versiones antes 1.9.0 usar apps/v1beta2  
 y antes de la version 1.8.0 usar: extensions/v1beta1
 ``` 

Terminologia
===============

## POD
unidad mínima de k8s, vamos a crear el archivo **pod.yml**:
``` 
apiVersion: v1
kind: Pod
metadata:
  name: dbmongo
spec:
  containers:
  - image: mongo
    name: dbmongo
```

ahora: 

> kubectl apply -f pods.yml  

Para listar los pods creados: 

> kubectl get pods

para ver información del pod:

> kubectl describe pod dbmongo   

tambien:  

> kubectl get all && kubectl describe pod/dbmongo

Podemos crear un POD de la siguiente manera:

> kubectl run webnginx --image=nginx --restart=Never

y listamos los pods:

> kubectl get po y/o  pods

Si nos olvidamos del manifiesto que creo un pod, podemos recurrir a:

> kubectl get pod webnginx -o yaml  

**y/o**

> kubectl get pod/webnginx -o yaml

para acceder el POD:

> kubectl exec -it pod/webnginx bash  

para poder ver el estado de nginx: 
> curl $IP 

si queremos exponer el puerto, esto se conocer como NodePort, para lo cual podemos realizar: 
( acceso desde la ip del NODO/MASTER ojo!  no es para exponer al mundo )

> kubectl port-forward webnginx 80

Para validarlo, desde un nodo:  
> curl 127.0.0.1

> kubectl port-forward webnginx 80:8080

Para validarlo, desde un nodo: 
> curl 127.0.0.1:8080


## LABELS
sirve para cualquier objeto de k8s, añade una *clave y valor a un objeto*, con el objetivo de identificar pods () ejm. vamos a crear el archivo **label.yml**
```
apiVersion: v1
kind: Pod
metadata:
  name: webnginx-label 
  labels:
      name: webnginx-label 
      pod-template: "mypodweb"
      run: nginx

spec:
  containers:
  - image: nginx
    name:  webnginx-label 

```

Para ejecutarlo de forma manual

> kubectl apply -f label.yml

> kubectl label pods webnginxlabel foo=bar 

**Desventaja:**  si se borra, se pierde el label ojo !!! 

Para listar las etiquetas:

> kubectl get pods --show-labels 

Si queremos buscar LABELs y mostrarlos en nuevas columnas:
> kubectl get pods -l foo=bar

> kubectl get pods -Lrun

## REPLICA-CONTROLLER (replicaset)
Nos permite tener tantas **"replicas"** de un POD que necesitemos ejecutar, ejm. vamos a crear el archivo **rc.yml**
```
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: wnginx
  namespace: default
spec:
  replicas: 2
  selector:
    matchLabels:
      app: wnginx
  template:
    metadata:
      labels:
        app: wnginx
    spec:
      containers:
        - image:  nginx
          name:  nginx
```

para aplicarlo:

> kubectl apply -f rc.yml 

ojo también se puede usar:

> kubectl create -f rs.yml

De esta forma, no se puede editar directamente el manifesto…. y a parte que no es muy usado. Si deseamos escalar los pods, por un tema de carga :

> kubectl scale rs wnginx --replicas=5

y para listar los pods en base a los replicaset

> kubectl get pods --watch 

## DEPLOYMENT
Lo que nos permite un deployment:
- replica management
- pod scaling
- rolling updates - 0 downtime
- rollback 
- clean-up policies

Creamos el archivo **deploy.yml**
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: dp-nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: dp-nginx
  template:
    metadata:
      labels:
        app: dp-nginx
    spec:
      containers:
      - name:  dpnginx
        image: nginx:latest
        ports:
        - containerPort: 80
```

lo aplicamos
> kubectl apply -f deploy.yml

si queremos escalar el deployment:
> kubectl scale deploy dp-nginx --replicas=4

Si queremos listar los deployments
> kubectl get deployments

Ahora, como se mencionó podemos hacer updates en "caliente" de la sgt forma:
> kubectl set image deployment.apps/deploy-nginx webnginxprd=nginx:1.16.1 --all

#### OBS:
```
deployment.apps/dp-nginx : nombre del deployment
dpnginx :                  nombre del contenedor
```

Actividad
============

Vamos a repasar los términos, para ello vamos a trabajar con la imagen de bitnami/nginx

> kubectl run validateweb --image=bitnami/nginx:1.12 --record

listamos los pods:
> kubectl get pods

y listamos los deployments:
> kubectl get deploy

para listar/editar el deployment:
> kubectl edit deploy/validateweb

si deseo listar los pods con labels
> kubectl get pod --show-labels

si deseo solo listar el pod en ejecución:
> kubectl get pods -w -l run=validateweb

escalemos en 8 replicas:
> kubectl scale deploy/validateweb --replicas=8

*mirar la otra consola*

y miramos los deployments:

> kubectl get deploy

si borramos un pod, vemos que se vuelve a crear, esto debido al replicaset que ha sido creado vía el deployment

listo el historico :
> kubectl rollout history deploy/validateweb

actualizamos la imagen:
> kubectl set image deploy/validateweb validateweb=bitnami/nginx:1.14--all

se presenta un error como se presenta, entonces hacemos el rollback

> kubectl get rs -l run=validateweb

antes de hacer el rollback vamos a dejar corriendo el estado del replicaset:

> kubectl get rs -w -l run=validateweb
```
kubectl rollout undo deploy/validateweb
deployment.extensions/validateweb rolled back
```

si borramos el replicaset:

> kubectl get rs

> kubectl delete replicaset.apps/validateweb-5fdb9bd66b

No se borra debido a que el deployment se mantiene activo.

### OBS.

Para que siempre guarde las actividades, hay que indicarlo:

> kubectl run nginxtest --image=bitnami/nginx:1.12 --record

Para ver los logs de un pod en base a su label:
> kubectl logs -f -l run=nginxtest


CI Gitlab con Kubernetes
==========================

### Configuracion de un Pipeline Gitlab

Con gitlab tambien podemos manejar CI para un proyecto determinado, para ello, vamos a partir de lo
siguiente

0. Vamos a ejecutar este **docker-compose.yml**
```
version: '3'
services:
  git:
    container_name: git-server
    hostname: IP_SERVER_DOCKER
    ports:
      - "443:443"
      - "80:80"
      - "4421:22"
    volumes:
      - "/home/deploy/gitlab/config:/etc/gitlab"
      - "/home/deploy/gitlab/logs:/var/log/gitlab"
      - "/home/deploy/gitlab/data:/var/opt/gitlab"
    image: gitlab/gitlab-ce
    restart: always
    networks:
      - net
 
networks:
  net:

```
### OBS.

Reemplazar IP_SERVER_DOCKER por la ip publica del servidor o droplet o instancia cloud.

> docker-compose up -d

0.1 Vamos a configurar ahora la conexion de Gitlab hacia nuestro cluster de kubernetes

0.2 Realizamos ahora las sgts acciones:  ( las anotamos en un block de notas )

> cat /root/.kube/config 

> echo "CERTIFICATED" | base64 -d 

> API URL: https://0cfd407b-9432-4b02-9fe0-4b292065c853.k8s.ondigitalocean.com

> TOKEN: 53da99b3647d1c3b52fd4a3683d50533f3c48dba753ee8bfcedd0505110f29e1

0.3 Con los datos ya obtenidos, en nuestro servidor Gitlab, vamos a configurar la conexion, para ello, hacemos clic en la "tuerca" 

![cik8s](https://github.com/kdetony/devops/blob/master/Images/gitk8s.png "git-k8s")

Escogemos la opcion: Agregar cluster kuebrentes
```
name: k8sdevops
CERTIFICATED: el que ya tenemos almacenado
URL API
TOKEN
```

0.4 Instalamos como plugins: **Helm, Gitlab Runner**

1. Creamos un grupo de nombre: dev-ci y un proyecto de nombre: test-ci / public 

2. En nuestro repositorio, nos vamos a ubicar en el proyecto **test-ci** y nos ubicamos en **settings**

![cik8s](https://github.com/kdetony/devops/blob/master/Images/gitk8s1.png "git-k8s")

3. En este apartado vamos a configurar las variables de entorno que usaremos mas adelante, las cuales van a ser:
```
CI_REGISTRY_IMAGE : ID_DOCKER_HUB/testdevops

CI_REGISTRY_PASSWORD : PASSWD_DOCKER_HUB
 
CI_REGISTRY_USER : ID_DOCKER_HUB
```

4. En el proyecto, vamos a crear de 0 un simple codigo en php, solo para validar toda esta funcionalidad, la cual es aplicable si desearamos ejecutar un proyecto java, python, go, etc

**CREATE FILE:  .gitlab-ci.yml**
```
docker-build:
  # Official docker image.
  image: docker:latest
  stage: build
  services:
    - docker:dind
  before_script:
    - docker login -u "$CI_REGISTRY_USER" -p "$CI_REGISTRY_PASSWORD"
  script:
    - docker build --pull -t "$CI_REGISTRY_IMAGE":"$CI_COMMIT_SHA" .
    - docker push "$CI_REGISTRY_IMAGE"
  variables:
    DOCKER_HOST: tcp://localhost:2375
    DOCKER_TLS_CERTDIR: ""

deploy:
  stage: deploy
  image: bitnami/kubectl
  script:
    - kubectl get deployment hola-php || kubectl create deployment hola-php --image="$CI_REGISTRY_IMAGE":"$CI_COMMIT_SHA"
    - kubectl set image deployment/hola-php hola-php="$CI_REGISTRY_IMAGE":"$CI_COMMIT_SHA"
```

**CREATE FILE: Dockerfile**
```
FROM php:7.4.1-apache-buster

COPY src/ /var/www/html

EXPOSE 80

```

**CREATE DIRECTORY: src** + **CREATE FILE: index.php**
```
<?php
echo "Hola deploy CI GITLAB";
?>
```
## OBS.

Antes de continuar, gitlab para poder ejecutar y tener completo acceso al namespace que sea ha creado: **gitlab-managed-apps**
debemos darle estos accesos de privilegios de ejecuion ( RBAC )

**clusterrole.yml**
```
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: deployment-manager
rules:
- apiGroups: ["", "extensions", "apps"]
  resources: ["deployments", "replicasets", "pods"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"] # You can also use ["*"]
```  

**clusterrolebinding.yaml**
```
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: runner-gitlab-runner-deployments
subjects:
- kind: ServiceAccount
  namespace: "gitlab-managed-apps"
  name: "default"
  apiGroup: ""
roleRef:
  kind: ClusterRole
  name: "deployment-manager"
  apiGroup: ""
```

Los ejecutamos 1 a 1: 

> kubectl apply -f clusterrole.yml

> kubectl apply -f clusterrolebinding.yaml

5. Ahora, para ejecutar nuestro pipeline, nos ubicamos aqui: 

![cik8s](https://github.com/kdetony/devops/blob/master/Images/gitk8s2.png "git-k8s")

![cik8s](https://github.com/kdetony/devops/blob/master/Images/gitk8s3.png "git-k8s")

6. Haccemos clic en ahora en **CI/CD > Jobs** para ver la ejecucion de nuestro pipeline :) 

7. Si toda va bien, deberiamos ver la imagen creada en Dockerhub :) 

8. Para validar que realmente se haya ejecutado nuestro pipeline, en el servidor Docker, donde tenemos instalado kubectl, vamos a ejecutar lo sgt: 

> kubectl get ns 

> kubectl -n gitlab-managed-apps get pods

> kubectl -n gitlab-managed-apps get all

La salida de esto, es visualizar nuestro pod ejecutandose :)  ...

### OBS
Si nuestro pod no se ha inicializado, debemos hacer un troubleshotting al mismo, para ello recurrimos a:

> kubectl -n gitlab-managed-apps describe pod/hola-php-ID_POD

### Pipeline Ejm. con mas stages

0. Para este ejm. vamos a usar el siguiente **docker-compose.yml**
```
version: '3'
services:
  git:
    container_name: git-server
    hostname: 167.172.197.61
    ports:
      - "443:443"
      - "80:80"
      - "4421:22"
    volumes:
      - "/home/deploy/gitlab/config:/etc/gitlab"
      - "/home/deploy/gitlab/logs:/var/log/gitlab"
      - "/home/deploy/gitlab/data:/var/opt/gitlab"
    image: gitlab/gitlab-ce
    restart: always
    networks:
      - net
 
  runner:
    image: gitlab/gitlab-runner:latest
    container_name: git-runner
    ports:
      - "8093:8093"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /home/deploy/gitlab/runner-config:/etc/gitlab-runner
    restart: always
    networks:
      - net   

networks:
  net:
```

Los ejecutamos:

> docker-compose up -d 

### OBS.

Si nos muestra algun error, hacer el cambio de puertos y nombre del contenedor

1. Ahora, configuramos un "runner" que viene a ser el **medio** que usar gitlab para ejecutar todos los stages.( referencial )

2. Creamos el grupo: **simpleg** y el proyecto **simplet**

3. Nos ubicamos en **settings > CI/CD** y vamos hacemos clic en **RUNNERS**

4. Vamos a ingresar al contenedor **gitlab-runner** 

> docker exec -it ID_CONTAINER bash 

5. Dentro del contenedor vamos a ejecutar: 

> gitlab-runner register

6. Debemos ingresar estos datos: 

> http//:IP_GITLAB

> TOKEN

> NAME : runner test

> TAG: build,test,deploy

> CONNECTOR: ssh 

> IP_SERVER_DOCKER

> PORT: 22

> USER_ACCESS_SERVER: root

> PASSWORD


7. Dentro de nuestro proyecto, vamos a crear un archivo de nombre: **.gitlab-ci.yml**
```
stage:
    - build
    - test

build:
   stage: build
   script:
      - echo "Building"
      - mkdir build 
      
   tags:
      - build   

test:
   stage: test
   script: 
      - echo "Testing"
      - echo "Test message" > build/info.txt
   tags:
      - test    
```

8. Ejecutamos nuestro pipeline, para ello, nos ubicamos en **CI/CD > Pipelines > Run Pipeline**  

9. Si todo salio oka! debemos validar el resultado de la ejecucion de nuestro pipeline desde gitlab :-)
