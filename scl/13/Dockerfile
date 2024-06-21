FROM centos/postgresql-13-centos7:latest

USER 0

# https://github.com/sclorg/postgresql-container/issues/369
RUN rm -f /etc/yum.repos.d/cbs.centos.org_repos_sclo7-rh-postgresql13-rh-candidate_x86_64_os_.repo \
  && yum upgrade -y \
  && yum clean all \
  && yum -y clean all --enablerepo='*' \
  && /usr/libexec/fix-permissions /var/lib/pgsql /var/run/postgresql

# https://github.com/sclorg/postgresql-container/blob/384c2584537836d99129ba36dc5f25345212b60d/10/Dockerfile#L86
USER 26

COPY "root/${APP_DATA}/src/postgresql-start" "${APP_DATA}/src/postgresql-start"
