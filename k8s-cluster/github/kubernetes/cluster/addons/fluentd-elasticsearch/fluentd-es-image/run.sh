#!/bin/bash
echo ELASTICSEARCH_URL=${ELASTICSEARCH_URL}
echo "ELASTICSEARCH_URL is ${ELASTICSEARCH_URL}"
sed -i -- "s/\${ELASTICSEARCH_URL}/${ELASTICSEARCH_URL}/g" /etc/td-agent/td-agent.conf
#start
td-agent
