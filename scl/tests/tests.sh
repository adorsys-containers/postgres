#!/bin/bash

set -eu

# shellcheck disable=SC2154
trap 'rv=$?; if docker inspect postgres-test > /dev/null 2>&1; then docker logs postgres-test; docker rm -f postgres-test; fi; exit $rv' INT TERM EXIT

#### TEST: some environments provided
docker run --rm \
  --network=host \
  --name postgres-test \
  -e POSTGRESQL_ADMIN_PASSWORD=password \
  -e POSTGRESQL_ADDITIONAL_DATABASES=db \
  -e POSTGRESQL_DATABASE_db_USER=dbuser \
  "${DOCKER_IMAGE}:${TAG}" 2>&1 | grep "Use 'POSTGRESQL_DATABASE_db_PASSWORD' to define one."

#### TEST: User should not recreated after restart
#### INITIAL RUN
docker run -d \
  --network=host \
  --name postgres-test \
  -v postgres-test-volume:/var/lib/pgsql/data \
  -e POSTGRESQL_ADMIN_PASSWORD=password \
  -e POSTGRESQL_USER=defaultuser \
  -e POSTGRESQL_PASSWORD=defaultpassword \
  -e POSTGRESQL_DATABASE=defaultdb \
  -e POSTGRESQL_ADDITIONAL_DATABASES=db \
  -e POSTGRESQL_DATABASE_db_USER=dbuser \
  -e POSTGRESQL_DATABASE_db_PASSWORD=dbpassword \
  "${DOCKER_IMAGE}:${TAG}"

sleep 5
docker rm -f postgres-test

docker run -d \
  --network=host \
  --name postgres-test \
  -v postgres-test-volume:/var/lib/pgsql/data \
  -e POSTGRESQL_ADMIN_PASSWORD=password \
  -e POSTGRESQL_USER=defaultuser \
  -e POSTGRESQL_PASSWORD=defaultpassword \
  -e POSTGRESQL_DATABASE=defaultdb \
  -e POSTGRESQL_ADDITIONAL_DATABASES=db \
  -e POSTGRESQL_DATABASE_db_USER=dbuser \
  -e POSTGRESQL_DATABASE_db_PASSWORD=dbpassword \
  "${DOCKER_IMAGE}:${TAG}"

sleep 5

# test normal behaivor
docker exec -ePGPASS=defaultpassword postgres-test bash -c "psql -h 127.0.0.1 -U defaultuser -tAc 'SELECT 1;' defaultdb"

# test additional behaivor
docker exec -ePGPASS=dbpassword postgres-test bash -c "psql -h 127.0.0.1 -U dbuser -tAc 'SELECT 1;' db"

docker rm -f postgres-test
