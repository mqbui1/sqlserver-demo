#Pre-requisite:
sudo apt-get update /
sudo apt-get install -y pv

#Build - change to your docker repo
docker buildx build \
  --platform linux/amd64 \
  -t mqbui1/sqlserver-demo:latest \
  --push \

#Deployment - change to your docker repo
containers:
  - name: java-app
    image: mqbui1/sqlserver-demo:latest

#Usage: 
bash run-dbmon-demo.sh

