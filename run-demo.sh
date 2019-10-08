#!/bin/bash

# tomcat
docker run -d \
  --name tomcat-0 \
  -v /root/docker/workspace/prom-jvm-demo:/jmx-exporter \
  -e CATALINA_OPTS="-Xms64m -Xmx128m -javaagent:/jmx-exporter/jmx_prometheus_javaagent-0.12.0.jar=6060:/jmx-exporter/simple-config.yml" \
  -p 6060:6060 \
  -p 8080:8080 \
  tomcat:8.5

docker run -d \
  --name tomcat-1 \
  -v /root/docker/workspace/prom-jvm-demo:/jmx-exporter \
  -e CATALINA_OPTS="-Xms32m -Xmx64m -javaagent:/jmx-exporter/jmx_prometheus_javaagent-0.12.0.jar=6060:/jmx-exporter/simple-config.yml" \
  -p 6061:6060 \
  -p 8081:8080 \
  tomcat:8.5

docker run -d \
  --name tomcat-2 \
  -v /root/docker/workspace/prom-jvm-demo:/jmx-exporter \
  -e CATALINA_OPTS="-Xms32m -Xmx32m -javaagent:/jmx-exporter/jmx_prometheus_javaagent-0.12.0.jar=6060:/jmx-exporter/simple-config.yml" \
  -p 6062:6060 \
  -p 8082:8080 \
  tomcat:8.5

curl -I http://192.168.1.177:8080/
curl -I http://192.168.1.177:8081/
curl -I http://192.168.1.177:8082/

# prometheus 
docker run -d \
  --name=prometheus \
  -p 9090:9090 \
  -v /root/docker/workspace/prom-jvm-demo:/prometheus-config \
  prom/prometheus --config.file=/prometheus-config/prom-jmx.yml

# grafana
docker run -d --name=grafana -p 3000:3000 grafana/grafana

# alertmanager
docker run -d \
  --name=alertmanager \
  -v /root/docker/workspace/prom-jvm-demo:/alertmanager-config \
  -p 9093:9093 \
  prom/alertmanager:master --config.file=/alertmanager-config/alertmanager-config.yml

# prometheus 
curl -I http://192.168.1.177:9090/
# grafana
curl -I http://192.168.1.177:3000/login
# alertmanager
curl -I http://192.168.1.177:9093/

# docker stop tomcat-0 tomcat-1 tomcat-2 prometheus grafana alertmanager
# docker rm tomcat-0 tomcat-1 tomcat-2 prometheus grafana alertmanager