## DevOps 과제: devOpsExample 

#[수행목표]
- 웹 어플리케이션을 docker를 통해 무중단 배포/운영 하는 환경 구성


#[개발환경]
- 1) OS: Ubuntu 
- 2) 웹서버: Nginx (reverse proxy, round robin 적용)
- 3) 웹 어플리케이션: spring-boot-sample-web-ui
- 4) Build: Gradle
- 5) Deploy: Docker
- 6) CI: Git
- 7) 스크립트 개발언어: bash


#[업무 Flow]
업무 flow는 간략하게 아래와 같으며 상세 내용은 각 항목을 참조

 - [최초 배포]
   gradle build(springboot) -> docker build(nginx, springboot) -> docker stack deploy
 
 - [어플리케이션 수정본 배포] blue-green deploy 방식 사용
   gradle build(springboot v1) -> docker build(springboot v1) -> route to blue -> green deploy 
   -> route to green -> blue deploy -> route to blue-green (round-robin) 
   
 - 1) spring-boot-sample-web-ui 어플리케이션 빌드
       - 빌드 버전: v1 (어플리케이션 버전 의미)
       - 빌드 수행: gradle build script 실행
       - 빌드 스크립트: gradle_build.sh (빌드 스크립트 실행 방안은 아래 [빌드 스크립트 실행]항목 참조)
      
 - 2) nginx용, springboot 어플리케이션 용 docker image build
       - 빌드 버전: v1 (docker image 버전 의미)
       - 빌드 수행: bash 스크립트 실행
       - 빌드 스크립트: docker_build_nginx.sh, docker_build_springboot.sh
         (빌드 스크립트 실행 방안은 아래 [빌드 스크립트 실행] 항목 참조
         
 - 3) docker stack deploy 
       - springboot1, springboot2 컨테이너 모두 myservice/springboot:1.0 이미지로 deploy 됨

 - 4) spring-boot-sample-web-ui 어플리케이션 수정내역 발생, 수정 본 재 빌드
 
       - 어플리케이션 내 소스 수정 발생했다고 가정
       - 빌드 버전: v2 (어플리케이션 버전 의미)
       - 빌드 수행: gradle build script 실행
       - 빌드 스크립트: $ ./gradle_build.sh prod v2
         > prod: profile 환경 중 운영환경 의미한다고 가정. local, dev 옵션도 사용 가능하나 여기서는 모두 prod 사용
         > v2: v2 버전의 어플리케이션 빌드 
       
 - 5) 변경된 소스 적용을 위한 springboot docker image 재 빌드
 
       - 빌드 버전: v2 (docker image 버전 의미)
       - 빌드 수행: bash 스크립트 'docker_build_springboot.sh' 실행
       - 스크립트 실행: $ ./docker_build_springboot.sh v2
         > v2: v2 버전의 docker image 빌드
                 
 - 6) 어플리케이션 healt check
       - curl http://localhost/checkHealth
       - 정상 서비스 중인 경우 {"status":"UP"} json 데이터 반환
    
    
    
#[빌드 스크립트 실행]
$ ./gradle_build.sh [v1 | v2]
  - v1: web application 최초 배포 버전
  - v2: 수정 사항 반영된 web application 수정 배포 버전이라 가정함  



#[배포 스크립트 실행]
아래 스크립트 실행을 순차 진행한다.

$ ./docker_build_nginx.sh
  - nginx docker image 빌드
 
$ ./docker_build_springboot.sh [v1 | v2]
  - v1: springboot용 docker image 최초 배포 버전
  - v2: 수정 사항 반영된 docker image 버전
  
$ docker swarm init 

$ ./docker_boot.sh [start | stop | restart]
  - start: 현재 docker stack deploy
  - stop: 현재 배포된 docker 컨테이너들 stop
  - restart: 현재 배포된 docker 컨테이너들 stop 후 변경된 이미지로 다시 deploy
  
 $ ./docker_deploy.sh
  - blue green 배포 방식 적용
