#!/bin/bash
host=$1
if [ "$host" == "" ]; then
  echo  "please add first param host domain "	
  exit
fi
secretname=$2
if [ "$secretname" == "" ]; then
  echo  "please add second param secretname"  
  exit
fi
appsvc=$3
if [ "$secretname" == "" ]; then
  echo  "please add third  param appsvc"  
  exit
fi

echo "
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: $secretname-ingress
spec:
  tls:
  - hosts:
    - $host
    secretName: $secretname
  rules:
  - host: $host
    http:
      paths:
      - path: /
        backend:
          serviceName: $appsvc
          servicePort: 80" > $secretname-ingress.yaml

#del useless txt
####create secret into k8s with domain k8s.cmos.cn

kubectl create -f $secretname-ingress.yaml
