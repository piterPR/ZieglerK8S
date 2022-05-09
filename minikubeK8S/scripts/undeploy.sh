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
cd -
#deleting configmaps
kubectl delete -f minikubeK8S/configmap/mysql-configmap.yaml

# deleting deployments into local k8s cluster 
banner "Trying to delete deployments in k8s cluster"
kubectl delete -f minikubeK8S/deployment/spring-petclinc-kotlin-deployment.yaml
kubectl delete -f minikubeK8S/deployment/mysql-deployment.yaml

banner "Trying to delete services in k8s cluster"
kubectl delete -f minikubeK8S/services/spring-petclinc-kotlin-service.yaml
kubectl delete -f minikubeK8S/services/mysql-service.yaml

banner "Trying to delete pvc volume in k8s cluster"
kubectl delete -f minikubeK8S/persistentvolume/mysql-pvc.yaml