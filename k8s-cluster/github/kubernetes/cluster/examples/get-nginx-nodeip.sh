#!/bin/bash
NGINX_NODE=$(kubectl get pod fluentd-logging --namespace=kube-system -o template --template={{.status.hostIP}})
echo "NGINX_NODE is $NGINX_NODE"
