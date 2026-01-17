# SQL Server Demo

Simple Spring Boot app using SQL Server on Kubernetes.

## Build
mvn clean package

## Build image
docker build -t sqlserver-demo .

## Run locally
docker run -p 8080:8080 \
  -e DB_HOST=localhost \
  -e DB_PORT=1433 \
  -e DB_NAME=demo \
  -e DB_USER=sa \
  -e DB_PASSWORD=Petclinic1! \
  sqlserver-demo
