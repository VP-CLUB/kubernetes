FROM elasticsearch:2.3.5

MAINTAINER chw717@126.com

USER root
WORKDIR /usr/share/elasticsearch

# Install Elasticsearch plug-ins
RUN ./bin/plugin install io.fabric8/elasticsearch-cloud-kubernetes/2.3.5
RUN chown -hR elasticsearch:elasticsearch /usr/share/elasticsearch
# Override elasticsearch.yml config, otherwise plug-in install will fail
ADD elasticsearch.yml ./config/elasticsearch.yml

EXPOSE 9200 9300
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["elasticsearch"]
