#!/usr/bin/env bash


echo "========================BUILDING THE BASE"
docker build --no-cache -t yourrepo/laravel:base -f docker/base/Dockerfile .

docker push yourrepo/laravel:base

echo "========================BULDING THE APP PROD================================"

docker build --build-arg CONSUL_SOURCE=http://consulserver --build-arg BUILD_ENVIRONMENT=production --build-arg BUILD_PATH=yourservice -t yourrepo/laravel:prod.${BUILD_NUMBER}.${GIT_HASH} -f docker/prod/Dockerfile . 


echo "========================PUSHING THE APP PROD=============================" 

docker push yourrepo/laravel:prod.${BUILD_NUMBER}.${GIT_HASH}