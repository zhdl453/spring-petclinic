#!/bin/bash

# cd /home/ubuntu/scripts
# docker compose up -d
docker run -itd -p 80:8080 --name=spring-petclinic s4616/spring-petclinic
