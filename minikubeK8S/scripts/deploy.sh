#!/bin/bash

banner() {
    msg="# $* #"
    edge=$(echo "$msg" | sed 's/./#/g')
    echo "$edge"
    echo "$msg"
    echo "$edge"
}

# going to main catalog
cd "$(dirname "$0")"

banner "Checking if k8s cluster is running"

SERVICE="minikube"

# checking if minikube is running
if pgrep -x "$SERVICE" >/dev/null
then
    banner "$SERVICE is running, going next"
else
    banner "$SERVICE minikube not running, Trying to run new minikube instance"
    minikube start
    if pgrep -x "$SERVICE" >/dev/null
    then 
        sleep 5
        banner "$SERVICE is not running and can't run a new instance. Check minikube installation"
        minikube start
        exit;
    fi
fi

cd -

# creating configmap into local k8s cluster 
banner "Trying to creating configmap in k8s cluster"
kubectl apply -f minikubeK8S/configmap/mysql-configmap.yaml



# creating services into local k8s cluster 
banner "Trying to run services in k8s cluster"

pwd
kubectl apply -f minikubeK8S/services/mysql-service.yaml
kubectl apply -f minikubeK8S/services/spring-petclinc-kotlin-service.yaml


# creating pvc into local k8s cluster 
banner "Trying to run pvc in k8s cluster"
kubectl apply -f minikubeK8S/persistentvolume/mysql-pvc.yaml

# creating deployment and waiting if deployment is ready into local k8s cluster 
banner "Trying to run DEPLOYMENT in k8s cluster"

kubectl apply -f minikubeK8S/deployment/mysql-deployment.yaml
#waiting for mysql status = ready
while [ "$(kubectl get pods -l=app='mysql' -o jsonpath='{.items[*].status.containerStatuses[0].ready}')" != "true" ]; do
   sleep 5
   echo "Waiting for mysql to be ready."
done
kubectl apply -f minikubeK8S/deployment/spring-petclinc-kotlin-deployment.yaml

#waiting for spring app status = ready
while [ "$(kubectl get pods -l=app='spring-petclinc-kotlin' -o jsonpath='{.items[*].status.containerStatuses[0].ready}')" != "true" ]; do
   sleep 5
   echo "Waiting for spring-petclinc-kotlin to be ready."
done

sleep 5

banner "Everything is running, creating minikube tunel to acces via localhost"
sudo minikube tunnel


