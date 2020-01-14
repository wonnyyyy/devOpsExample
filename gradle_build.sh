#! /bin/bash
echo "----------------------------------------------------------------"
echo " Building Web Application 'spring-boot-sample-web-ui' by Gradle "
echo "----------------------------------------------------------------"
echo "                                                                " 

#define variables
PROFILE=$1
APP_VERSION=$2


#check arguments
if [ $# -ne 2 ]
then
    echo "                                                                   "
    echo "-------------------------------------------------------------------"
    echo "[ERROR] Gradle build requires arguments. Please check the usage    "
    echo "-------------------------------------------------------------------"
    echo "[Usage] gradle_build.sh -Pprofile=[profile] -PappVersion=[version] "
    echo " - profile   : local, dev, prod                                    "
    echo " - appVersion: v1, v2 ...                                          "
    exit 1
else
    echo "                                                                   "
    echo "[Step1] Start synchronizing resources from Github                  "
    echo "-------------------------------------------------------------------"
fi

#move to source dir
cd /app/devOpsExample

#synchronize resources from remote git repository
git pull

sleep 10

#build web application by using gradle
echo "                                                                  "
echo "[Step2] Start building web application 'spring-boot-sample-web-ui'"
echo " -profile   : $1                                                  "
echo " -appVersion: $2                                                  "
echo "------------------------------------------------------------------"

./gradlew clean bootWar -Pprofile=${PROFILE} -PappVersion=${APP_VERSION}
