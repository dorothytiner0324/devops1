Procedimiento
================

# Scripts

1. Primer script: *build.sh*
```sh
#!/bin/bash
cd /tmp
git clone https://IP_SERVER_GITLAB:XXX/hello-world.git 
cd hello-world
mvn package 
```
OBS.
* La ruta donde se genera el *war* deberia ser: /tmp/hello-world/webapp/target/webapp.war

2. Segundo script: *test.sh* 

3. Tercer script:  *push.sh*

4. Cuarto script: *deploy.sh*

# Pipeline

```
pipeline {
  agent any
  stages { 
    stage{'Build'} {
      steps {  
        sh ''' 
           /PATH/build.sh 
           '''
      }
    }
    stage{'Test'} {
      steps {  
        sh ''' 
           /PATH/test.sh
           '''
      }
    }
    stage{'Push'} {
      steps {  
        sh ''' 
           /PATH/push.sh
           '''
      }
    }
    stage{'Deploy'} {
      steps {  
        sh ''' 
           /PATH/deploy.sh
           '''
      }
    }
  }
}
```
