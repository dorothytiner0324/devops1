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

> id jenkins
```
uid=997(jenkins) gid=994(jenkins) groups=994(jenkins)
```

b. Copiamos la llave SSH del usuario jenkins en el mismo servidor Jenkins ojo!.

c. En el *servidor Docker*, vamos a crear el usuario jenkins, de esta forma:

> useradd -u 997 -g 994 jenkins -m -s /bin/bash

> passwd jenkins

d. Regresamos al servidor Jenkins, ejecutamos ( con el usuario jenkins )

> ssh-copy-id -i ~/.ssh/id_rsa.pub jenkins@IP_SRV_DOCKER

e. Validamos la conexion via ssh entre ambos servidores.

f. configurar usuario jenkins en **credentials**

> Administrar Jenkins > Global tool Configuration > Ansible
```
Name: Ansible2.9.x
PATH: /usr/local/bin
```

### OBS.

1. Para el servidor Jenkins, debemos hacer un cambio en **/etc/passwd** para el usuario jenkins, es decir de *false* a *bash*
para que pueda realizar conexiones ssh. 

2. Nos dirigimos a /var/lib/jenkins/.ssh para copiar id_rsa.pub al archivo authorized_keys

> cat id_rsa.pub > authorized_keys 

> chmod 600 authorized_keys
