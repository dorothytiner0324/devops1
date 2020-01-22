En el servidor Jenkins
=====================

1. Instalamos python y pip

> yum install python3 python3-pip -y sshpass

2. Instalamos ansible via pip

> pip3 install ansible

Validamos la version:

> ansible --version

3. Generamos el juego de llaves ssh para el usuario root

> ssh-keygen -t rsa

4. Copiamos esta llave en todos los servidores que deseemos administrar.

5. En el servidor Jenkins, instalar el plugin de Ansible.

### Adicional

a. Vamos a realizar la sgt modificacion en el servidor jenkins:

> usermod -s /bin/bash jenkins

```
> su - jenkins

> ssh-keygen -t rsa
```

> id jenkins
```
uid=997(jenkins) gid=994(jenkins) groups=994(jenkins)
```

> ssh-keygen -t rsa 

b. Copiamos la llave SSH del usuario jenkins en el mismo servidor Jenkins ojo!.

c. En el *servidor Docker*, vamos a crear el usuario jenkins, de esta forma:

> useradd -u 997 -g 994 username -m -s /bin/bash

d. Generamos su juego de llaves SSH:

> ssh-keygen -t rsa

e. Copiamos el **id_rsa.pub** del usuario jenkins

> echo "id_rsa.pub" >> /home/jenkins/.ssh/authorized_keys

f. Regresamos al servidor Jenkins, ejecutamos ( con el usuario jenkins )

> ssh-copy-id -i ~/.ssh/id_rsa.pub jenkins@IP_SRV_DOCKER

g. Validamos la conexion via ssh entre ambos servidores.

h. configurar usuario jenkins en **credentials**

> Administrar Jenkins > Global tool Configuration > Ansible
```
Name: Ansible2.9.x
PATH: /usr/local/bin
```
