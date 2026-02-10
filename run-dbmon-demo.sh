#!/bin/bash

########################
# include the magic
########################
. demo-magic.sh

# hide the evidence
clear

# Put your stuff here
pe "docker login"

pe "mkdir -p ~/.docker/cli-plugins"

pe "curl -fL https://github.com/docker/buildx/releases/download/v0.16.2/buildx-v0.16.2.linux-amd64 \
  -o ~/.docker/cli-plugins/docker-buildx"

pe "chmod +x ~/.docker/cli-plugins/docker-buildx"

pe "docker buildx version"

pe "docker buildx create --use"

pe "docker buildx build \
  --platform linux/amd64 \
  -t mqbui1/sqlserver-demo:latest \
  --push \
  ."

pe ". check_env.sh"

pe "helm repo add splunk-otel-collector-chart https://signalfx.github.io/splunk-otel-collector-chart && helm repo update"

pe "helm install splunk-otel-collector \
--set="operatorcrds.install=true", \
--set="operator.enabled=true", \
--set="splunkObservability.realm=$REALM" \
--set="splunkObservability.accessToken=$ACCESS_TOKEN" \
--set="clusterName=$INSTANCE-k3s-cluster" \
--set="splunkObservability.profilingEnabled=true" \
--set="agent.service.enabled=true"  \
--set="environment=$INSTANCE-workshop" \
--set="splunkPlatform.endpoint=$HEC_URL" \
--set="splunkPlatform.token=$HEC_TOKEN" \
--set="splunkPlatform.index=splunk4rookies-workshop" \
splunk-otel-collector-chart/splunk-otel-collector \
-f otel/otel-collector.yaml"

pe "kubectl apply -f k8s/"

