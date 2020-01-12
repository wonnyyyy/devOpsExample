#!/bin/bash

echo "--------------------------------------------"
echo "[Docker] Start building Nginx Container!    "
echo "--------------------------------------------"

DOCKER_FILE=nginxDockerFile

#docker container build 
docker build --no-cache -f ${DOCKER_FILE} -t spring-boot-sample-web-ui/nginx:1 
