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
