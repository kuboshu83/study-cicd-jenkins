#!/usr/bin/env bash

docker run -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home --name jenkins --rm jenkins/jenkins:lts-jdk17