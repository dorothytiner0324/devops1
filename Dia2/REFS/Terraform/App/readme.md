# Secuencia de ejecución y Tips

1. kubectl -n test-app apply -f 00-*.yml

2. kubectl -n test-app run -it busybox  --image=alpine  -- s

### Para un POD 

1. kubectl apply -f https://k8s.io/examples/application/shell-demo.yaml
2. kubectl get pod shell-demo
3. kubectl exec -it shell-demo -- /bin/bash

`apt-get update`

`apt-get install -y procps lsof`

`ps aux | grep nginx`

`echo "Hola Plug!!! Page demo" > /usr/share/nginx/html/index.html`
`
