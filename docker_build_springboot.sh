#!/bin/bash

echo "---------------------------------------------------------"
echo "[Docker] Start building docker image of ' Spring-boot'! "
echo "---------------------------------------------------------"

#custom dockerFile 
DOCKER_FILE=springBootDockerFile

#check an argument
if [ $# -ne 1 ]
then 
  echo "                                                                 "
  echo "[ERROR] Docker build requires an argument. Please check the usage"
  echo "-----------------------------------------------------------------"
  echo "[Usage] docker_build_springboot.sh [appVersion]                  "
  echo " - appVersion: v1, v2 ...                                        "
  exit 1
else
  echo "[Step1] Start building docker image of spring-boot web application"
  echo "------------------------------------------------------------------"
fi

#application version will be used for spring-boot application docker image version
APP_VERSION=$1

#build a docker image
docker build --no-cache -f ${DOCKER_FILE} -t myservice/springboot:${APP_VERSION} .
