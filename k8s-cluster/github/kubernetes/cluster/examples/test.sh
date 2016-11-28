#!/bin/bash
kubectl create -f cafe-secret.yaml

kubectl create -f cafe-ingress.yaml


kubectl create -f nginx-ingress-rc.yaml
