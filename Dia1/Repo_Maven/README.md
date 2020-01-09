Procedimientos
==========

1. hello-world, es un repositorio de ejemplo, que nos servirá para crear un Job desde Jenkins y contruir un WAR.

2. En base a un pipeline, vamos realizar el CI: Jenkins/Maven/Docker 
3. Subir hello-world, a nuestro repositorio GitLab:
   ```sh
   git clone https://IP_SERVER_GITLAB:XXX/hello-world.git
   git add . | git commit -m "Send Files Repo Master" | git push 
   ```
