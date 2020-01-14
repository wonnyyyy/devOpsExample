#!/bin/bash

#docker-compose filename
CONFIG_FILE=docker-compose.yml
CONFIG_FILE_GREEN=docker-compose_green.yml
CONFIG_FILE_BLUE=docker-compose_blue.yml
CONFIG_NGINX_BLUE=nginxForBlue.conf
CONFIG_NGINX_GREEN=nginxForGreen.conf
#docker stack name
STACK_NAME=devops


#start a docker stack
echo "                                                                "
echo " -start a docker stack '${STACK_NAME}'                          "
echo "----------------------------------------------------------------"

docker stack deploy -c ${CONFIG_FILE} --resolve-image=changed ${STACK_NAME}


#Route to blue application
echo " [Step1] Route to blue application                              "
echo "----------------------------------------------------------------"

cat conf/nginx/${CONFIG_NGINX_BLUE} > conf/nginx.conf

CID=$(docker ps | awk '{print $NF}' | grep nginx)
for cid in $CID; do
  docker exec -it $cid nginx -s reload
done

sleep 10


#Deploy updated version docker image to green application
echo " [Step2] Deploy updated version docker imgae to green application "
echo "------------------------------------------------------------------"

docker stack deploy -c ${CONFIG_FILE_GREEN} --resolve-images=changed ${STACK_NAME}

sleep 60

#Route to green application
echo " [Step3] Route to green application(updated docker image)         "
echo "------------------------------------------------------------------"
cat conf/nginx/${CONFIG_NGINX_GREEN} > conf/nginx.conf

CID=$(docker ps | awk '{print $NF}' | grep nginx)
for cid in $CID; do
  docker exec -it $cid nginx -s reload
done

sleep 10

#Deploy the updated version docker image to blue application
echo " [Step4] Deploy the updated docker image to blue application(round robin) "
echo "--------------------------------------------------------------------------"

cat conf/nginx/nginx.conf > conf/nginx.conf

CID=$(docker ps | awk '{print $NF}' | grep nginx)
for cid in $CID; do
  docker exec -it $cid nginx -s reload
done

echo "Successfully finished 'Blue-Green deployment'"
echo "-------------------------------------------- "

