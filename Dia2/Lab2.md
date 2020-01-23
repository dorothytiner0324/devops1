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

Vamos a usar un ejemplo:

> kubectl run dokuwiki --image=dokuwiki --record

vemos el manifiesto creado:

> kubectl get deployments dokuwiki -o yaml

y listamos el estado del pod:

> kubectl get pods

si hacemos el update:

> kubectl set image deployment/dokuwiki dokuwiki=bitnami/dokuwiki:09 --all

Listamos el estado de los pod “actualizados”
``` 
kubectl get pods
dokuwiki-fcbbf5844-rrmck        0/1     ErrImagePull   0          5s
```

Vemos que hay un error en la imagen, entonces recurrimos a un rollback

para ellos vamos a listar los históricos:
> kubectl rollout history deployment/dokuwiki

y procedemos a realizar el rollback
> kubectl rollout undo deployment/dokuwiki

listamos ahora los pods
> kubectl get pods

Vamos a repasar los términos, para ello vamos a trabajar con la imagen de bitnami/nginx

> kubectl run webnginx --image=bitnami/nginx:1.12 --record

listamos los pods:
> kubectl get pods

y listamos los deployments:
> kubectl get deploy

para listar/editar el deployment:
> kubectl edit deploy/webnginx

si deseo listar los pods con labels
> kubectl get pod --show-labels

si deseo solo listar el pod en ejecución:
> kubectl get pods -w -l run=webnginx

escalemos en 8 replicas:
> kubectl scale deploy/webnginx --replicas=8

*mirar la otra consola*

y miramos los deployments:
> kubectl get deploy

si borramos un pod, vemos que se vuelve a crear, esto debido al replicaset que ha sido creado vía el deployment

listo el historico :
> kubectl rollout history deploy/webnginx

actualizamos la imagen:
> kubectl set image deploy/webnginx webnginx=bitnami/nginx:1.14--all

se presenta un error como se presenta, entonces hacemos el rollback

> kubectl get rs -l run=webnginx

antes de hacer el rollback vamos a dejar corriendo el estado del replicaset:

> kubectl get rs -w -l run=webnginx
```
kubectl rollout undo deploy/webnginx
deployment.extensions/webnginx rolled back
```

si borramos el replicaset:

> kubectl delete replicaset.apps/webnginx-5fdb9bd66b

este se vuelve a regenerar debido a que el deployment se mantiene activo.

### OBS.

para que siempre guarde las actividades, hay que indicarlo:

> kubectl run nginx --image=bitnami/nginx:1.12 --record

para ver los logs de un pod en base a su label:
> kubectl logs -f -l run=webnginx


CI Gitlab con Kubernetes
==========================

