#!/bin/bash -u

docker-compose -f $LOCAL_ROOT_PATH/docker/compose/docker-compose.yaml down
rm -rf ca_root/ data/ basic.tar.gz