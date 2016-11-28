#!/bin/bash
kubectl create secret docker-registry aliregistrykey --docker-server=https://hub.docker.vpclub.cn --docker-username=chen.wei --docker-password=vpclub.prod --docker-email=chen.wei@vpclub.cn
#kube
kubectl create secret docker-registry aliregistrykey --docker-server=https://hub.docker.vpclub.cn --docker-username=chen.wei --docker-password=vpclub.prod --docker-email=chen.wei@vpclub.cn --namespace=kube-system
