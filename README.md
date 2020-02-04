[![](https://img.shields.io/docker/pulls/adorsys/postgres.svg?logo=docker)](https://hub.docker.com/r/adorsys/postgres/)
[![](https://img.shields.io/docker/stars/adorsys/postgres.svg?logo=docker)](https://hub.docker.com/r/adorsys/postgres/)

# adorsys/postgres

https://hub.docker.com/r/adorsys/postgres/

## Description

Postgres container based on https://github.com/sclorg/postgresql-container but create multiple databases

# Environment

| Key | Description | Example |
|-----|-------------|---------|
| `POSTGRESQL_ADDITIONAL_DATABASES` | additional databases as comma separated list | `POSTGRESQL_ADDITIONAL_DATABASES=db` |
| `POSTGRESQL_DATABASE_<name>_USER` | username for database `<name>` | `POSTGRESQL_DATABASE_db_USER=dbuser` |
| `POSTGRESQL_DATABASE_<name>_PASSWORD` | password for database `<name>` | `POSTGRESQL_DATABASE_db_PASSWORD=dbpassword` |

# Example
```bash
docker run -d --rm \
  -p 5432:5432
  -e POSTGRESQL_ADMIN_PASSWORD=password \
  -e POSTGRESQL_USER=defaultuser \
  -e POSTGRESQL_PASSWORD=defaultpassword \
  -e POSTGRESQL_DATABASE=defaultdb \
  -e POSTGRESQL_ADDITIONAL_DATABASES=db \
  -e POSTGRESQL_DATABASE_db_USER=dbuser \
  -e POSTGRESQL_DATABASE_db_PASSWORD=dbpassword \
  adorsys/postgres:10-scl
```

## Tags

| Tag | Base Image |
|-----|-------------|
| 10-scl | [centos/postgresql-10-centos7](https://hub.docker.com/r/centos/postgresql-10-centos7) |
| 12-scl | [centos/postgresql-12-centos7](https://hub.docker.com/r/centos/postgresql-12-centos7) |
