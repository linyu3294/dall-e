#!/bin/bash

./gradlew clean build
docker build --platform linux/amd64 -t dalle .
docker run -p 8086:8080 dalle

docker login
echo "Enter the user name"
read username
echo "Enter the password"
read password
docker tag dalle "${username}"/dalle
docker push "${username}"/dalle