# SQL Server Demo

Simple Spring Boot app using SQL Server on Kubernetes.

##To rebuild java app, use following commands and push to your repo
docker buildx create --use

docker buildx build \
  --platform linux/amd64 \
  -t mqbui1/sqlserver-demo:latest \
  --push \
  .

##Deploy resources to Kubernetes
kubectl apply -f k8s/

##Deploy Splunk Otel Collector using with Helm chart
helm install splunk-otel-collector \
--set="operatorcrds.install=true", \
--set="operator.enabled=true", \
--set="splunkObservability.realm=$REALM" \
--set="splunkObservability.accessToken=$ACCESS_TOKEN" \
--set="clusterName=$INSTANCE-k3s-cluster" \
--set="splunkObservability.profilingEnabled=true" \
--set="agent.discovery.enabled=true" \
--set="agent.service.enabled=true"  \
--set="environment=$INSTANCE-workshop" \
--set="splunkPlatform.endpoint=$HEC_URL" \
--set="splunkPlatform.token=$HEC_TOKEN" \
--set="splunkPlatform.index=splunk4rookies-workshop" \
splunk-otel-collector-chart/splunk-otel-collector \
-f ~/workshop/k3s/otel-collector-sqlserverdemo.yaml
