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

Copiamos todos los archivos TF que tenemos en nuestra carpeta **REFS/Terraform/Infra**



