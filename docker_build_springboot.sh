#!/bin/bash

echo "---------------------------------------------------------"
echo "[Docker] Start building docker image of ' Spring-boot'! "
echo "---------------------------------------------------------"

#docker파일 설정
DOCKER_FILE=springBootDockerFile

#application version 설정
echo $1
APP_VERSION=$1

#docker image build
sudo docker build -f ${DOCKER_FILE} -t myservice/springboot:${APP_VERSION} .
