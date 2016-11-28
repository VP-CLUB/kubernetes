#!/bin/bash
#delete
#kubectl delete -f namespace.yaml

kubectl --namespace=kube-system delete -f skydns-rc.yaml
kubectl --namespace=kube-system delete -f skydns-svc.yaml
#create
kubectl create -f namespace.yaml 
kubectl --namespace=kube-system create -f skydns-rc.yaml 
kubectl --namespace=kube-system create -f skydns-svc.yaml

