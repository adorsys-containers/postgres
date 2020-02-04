#!/bin/bash

set -eu

trap 'rv=$?; if docker inspect postgres-test > /dev/null 2>&1; then docker logs postgres-test; docker rm -f postgres-test; fi; exit $rv' INT TERM EXIT

docker run -d --rm \
  --network=host \
  --name postgres-test \
  -e POSTGRESQL_ADMIN_PASSWORD=password \
  -e POSTGRESQL_USER=defaultuser \
  -e POSTGRESQL_PASSWORD=defaultpassword \
  -e POSTGRESQL_DATABASE=defaultdb \
  -e POSTGRESQL_ADITIONAL_DATABASES=db \
  -e POSTGRESQL_DATABASE_db_USER=dbuser \
  -e POSTGRESQL_DATABASE_db_PASSWORD=dbpassword \
  "${DOCKER_IMAGE}:${TAG}"

sleep 5

# test normal behaivor
docker run -ePGPASS=defaultpassword --network=host "${DOCKER_IMAGE}:${TAG}" psql -h 127.0.0.1 -U defaultuser defaultdb <<< 'SELECT 1;'

# test additional behaivor
docker run -ePGPASS=dbpassword --network=host "${DOCKER_IMAGE}:${TAG}" psql -h 127.0.0.1 -U dbuser db <<< 'SELECT 1;'

docker rm -f postgres-test

docker run --rm \
  --network=host \
  --name postgres-test \
  -e POSTGRESQL_ADMIN_PASSWORD=password \
  -e POSTGRESQL_ADITIONAL_DATABASES=db \
  -e POSTGRESQL_DATABASE_db_USER=dbuser \
  "${DOCKER_IMAGE}:${TAG}" 2>&1 | grep "Use 'POSTGRESQL_DATABASE_db_PASSWORD' to define one."
