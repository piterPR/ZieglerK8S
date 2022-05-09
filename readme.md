## Short overview
The application was run on a popular instance for use on the local machine minikube. (Link with installation steps below)
All the documentation can be found in the README.md file. I tried to change the application.properties file in order to set global variables for the database connection, however when building a new image it turned out that version gradle:4.7.0-jdk8-alpine is not available, which contributed to leaving the containerization in the current version. 



## To run k8s distro on local machine 
Firstly we need to configure minikube on local machine, follow this link to setup minikube to local development.
https://minikube.sigs.k8s.io/docs/start/


## Start local cluster with dashboard
```
minikube start
minikube dashboard

```

## Deploy application on local minikube kubernetes cluster(OPTION 1 automatic DEPLOY)

To use automatic deploy you need to run deploy.sh script located in 
/minikubeK8S/scripts/deploy.sh 

Give  chmod +x that you'll make file deploy.sh executable
```
chmod +x minikubeK8S/scripts/deploy.sh
```
Run deploy.sh
```
./minikubeK8S/scripts/deploy.sh
```



## Execution of commands automatically in sequence (OPTION 2  non-automatic DEPLOY)

We start with the deployment of services then the persistentvolume needed to deploy the database and finally we move on to the deployment of the main applications. 
Next, we need to execute the following commands

CONFIGMAPS 
```
minikubeK8S/configmap/
kubectl apply -f minikubeK8S/configmap/mysql-configmap.yaml
```


SERVICES 
```
cd minikubeK8S/services/
kubectl apply -f mysql-service.yaml
kubectl apply -f spring-petclinc-kotlin-service.yaml
```

PVC 
```
cd minikubeK8S/persistentvolume
kubectl apply -f mysql-pvc.yaml
```
DEPLOYMENT 
```
cd minikubeK8S/deployment/ 
kubectl apply -f mysql-deployment.yaml
kubectl apply -f spring-petclinc-kotlin-deployment.yaml
```


## Undeploy all deployments (OPTION 1 automatic UNDEPLOY)

To use automatic deploy you need to run undeploy.sh script located in 
/minikubeK8S/scripts/undeploy.sh 


Give  chmod +x that you'll make file deploy.sh executable
```
chmod +x minikubeK8S/scripts/undeploy.sh
```

Run undeploy.sh
```
./minikubeK8S/scripts/undeploy.sh
```


## Execution of commands automatically in sequence (OPTION 2  non-automatic UNDEPLOY)


CONFIGMAPS 
```
minikubeK8S/configmap/
kubectl delete -f minikubeK8S/configmap/mysql-configmap.yaml
```


DEPLOYMENTS
```
cd minikubeK8S/deployment/ 
kubectl delete -f mysql-deployment.yaml
kubectl delete -f spring-petclinc-kotlin-deployment.yaml
```
SERVICES
```
cd minikubeK8S/services/
kubectl delete -f mysql-service.yaml
kubectl delete -f spring-petclinc-kotlin-service.yaml
```

PVC 
```
cd minikubeK8S/persistentvolume
kubectl delete -f mysql-pvc.yaml
```