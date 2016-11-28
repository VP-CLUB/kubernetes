#!/bin/bash
kubectl create -f service-account.yaml

kubectl create -f kibana-service.yaml
kubectl create -f elasticsearch-logging.yaml

ELASTICSEARCH_HOST=$(kubectl --namespace=kube-system get svc elasticsearch -o template --template={{.spec.clusterIP}})
echo "host is $ELASTICSEARCH_HOST"
cp kibana-controller.yaml kibana-controller-actual.yaml
cp fluentd-daemonset.yaml fluentd-daemonset-actual.yaml
#replace
sed -i -- "s/\${ELASTICSEARCH_HOST}/${ELASTICSEARCH_HOST}/g" kibana-controller-actual.yaml
#kubectl create -f fluentd-es-logging-actual.yaml
kubectl create -f kibana-controller-actual.yaml
rm kibana-controller-actual.yaml
#use daemonset
sed -i -- "s/\${ELASTICSEARCH_HOST}/${ELASTICSEARCH_HOST}/g" fluentd-daemonset-actual.yaml
kubectl create -f fluentd-daemonset-actual.yaml
rm fluentd-daemonset-actual.yaml
