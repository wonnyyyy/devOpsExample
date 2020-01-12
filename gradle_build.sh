#! /bin/bash
echo "--------------------------------------------------------------"
echo " Build Web Application 'spring-boot-sample-web-ui' by Gradle  "
echo "--------------------------------------------------------------"
echo "                                                              " 

#variables
PROFILE=$1

#arguments 입력 확인
if [ $# -ne 1 ]
then
    echo "                                                               "
    echo "---------------------------------------------------------------"
    echo "[ERROR] Gradle build requires arguments. Please check the usage"
    echo "---------------------------------------------------------------"
    echo "[Usage]: gradle_build.sh [profile]                             "
    exit 1
else
    echo "                                                               "
    echo "[Step1] Start synchronizing resources from Github              "
    echo "---------------------------------------------------------------"
fi

#source dir로 이동
cd /app/devOpsExample

#source synchronize
git pull

sleep 20 

#gradle build 수행 
echo "                                                                  "
echo "[Step2] Start building web application 'spring-boot-sample-web-ui'"
echo " -Build profile: $1                                               "
echo "------------------------------------------------------------------"

./gradlew clean bootWar -Pprofile=${PROFILE}
