FROM centos/postgresql-12-centos7:latest

USER 0

RUN yum upgrade -y \
  && yum clean all \
  && yum -y clean all --enablerepo='*' \
  && /usr/libexec/fix-permissions /var/lib/pgsql /var/run/postgresql

# https://github.com/sclorg/postgresql-container/blob/384c2584537836d99129ba36dc5f25345212b60d/10/Dockerfile#L86
USER 26

COPY "root/${APP_DATA}/src/postgresql-start" "${APP_DATA}/src/postgresql-start"
