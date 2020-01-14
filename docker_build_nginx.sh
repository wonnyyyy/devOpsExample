#!/bin/bash

echo "----------------------------------------------"
echo "[Docker] Start building docker image of Nginx!"
echo "----------------------------------------------"

DOCKER_FILE=nginxDockerFile

#docker container build 
docker build -f ${DOCKER_FILE} -t myservice/nginx:1.0 . 
