#!/bin/bash

#boot mode
mode=$1
#docker-compose filename
CONFIG_FILE=docker-compose.yml
#docker stack name
STACK_NAME=devops

#check an argument
if [ $# -ne 1 ]
then 
  echo "                                                                 "
  echo "[ERROR] Docker stack requires an argument. Please check the usage"
  echo "-----------------------------------------------------------------"
  echo "[Usage] docker_boot.sh [mode]                                    "
  echo " - mode: start, stop, restart                                    "
  exit 1
else
  echo "[Docker] Start booting docker stack!                             "
fi


if [ "${mode}" = "start" ]
then
   #start a docker stack
   echo "                                                                "
   echo " -start a docker stack '${STACK_NAME}'                          "
   echo "----------------------------------------------------------------"

   docker stack deploy -c ${CONFIG_FILE}  --resolve-image=always ${STACK_NAME}


elif [ "${mode}" = "stop" ]
then
   #stop the docker stack
   echo "                                                                "
   echo " -stop the docker stack '${STACK_NAME}'                         "
   echo "----------------------------------------------------------------"

   docker stack rm ${STACK_NAME}


elif [ "${mode}" = "restart" ]
then 
   #restart the docker stack
   echo "                                                                "
   echo " -restart the docker stack '${STACK_NAME}' with changed image   "
   echo "----------------------------------------------------------------"

   docker stack rm ${STACK_NAME}
   sleep 30
   docker stack deploy -c ${CONFIG_FILE} --resolve-image=changed ${STACK_NAME}  


else
   echo "                                                                "
   echo "[ERROR] Docker stack requires an proper argument                "
   echo "----------------------------------------------------------------"
   echo "[Usage] docker_boot.sh [mode]                                   "
   echo " -mode: start, stop, restart                                    "
   exit 1
fi


#build a docker image
sudo docker build --no-cache -f ${DOCKER_FILE} --build-arg APP_VERSION=${APP_VERSION} -t myservice/springboot:${APP_VERSION} .
