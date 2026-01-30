#!/bin/bash

########################
# include the magic
########################
. demo-magic.sh

# hide the evidence
clear

# Put your stuff here
pe "helm repo add splunk-otel-collector-chart https://signalfx.github.io/splunk-otel-collector-chart && helm repo update"

pe "helm install splunk-otel-collector --set="splunkObservability.accessToken=VZiHqp4S_JFh0i-10QH2VQ,clusterName=troubleshooting-agent-demo,splunkObservability.realm=us1,gateway.enabled=false,splunkPlatform.endpoint=https://http-inputs-o11y-workshop-us1.splunkcloud.com:443/services/collector/event,splunkPlatform.token=ee8119b5-0fd0-40e6-89c3-c843fabbdf7a,environment=troubleshooting-agent-demo" splunk-otel-collector-chart/splunk-otel-collector"

pe "kubectl get ns k1 >/dev/null 2>&1 || kubectl create ns k1; cat <<'YAML' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ipbo-busybox
  namespace: k1
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ipbo-busybox
  template:
    metadata:
      labels:
        app: ipbo-busybox
    spec:
      containers:
        - name: bb
          image: busybox:1.00-sfx # doesn't exist
          command: ["/bin/sh", "-c", "sleep 3600"]
YAML"

pe "kubectl -n k1 get pods -l app=ipbo-busybox -w"