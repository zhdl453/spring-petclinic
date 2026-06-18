#!/bin/bash

# cd /home/ubuntu/scripts
# docker compose down || true

docker rm -f $(docker ps -aq)
docker rmi -f $(docker images -q)
