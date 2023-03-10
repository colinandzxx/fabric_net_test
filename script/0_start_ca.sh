#!/bin/bash -u

# docker stop $(docker ps -aq)
# docker rm $(docker ps -aq)
# docker rmi $(docker images dev-* -q)
# rm -rf organizations data
docker-compose -f $LOCAL_ROOT_PATH/docker/compose/docker-compose.yaml up -d ca.origin.myproject.com