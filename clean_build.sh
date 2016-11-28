#!/bin/bash
docker-compose stop && \
docker-compose rm --all && \
docker volume rm `docker volume ls -q -f dangling=true` 
