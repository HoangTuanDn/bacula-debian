ARG B_VERSION=13.0.2

FROM nhtdn/bacula-base:${B_VERSION} AS base

FROM postgres:13

ENV TZ="Asia/Ho_Chi_Minh"

ENV POSTGRES_PASSWORD bacula

ENV POSTGRES_USER bacula

ENV POSTGRES_DB bacula

ENV POSTGRES_INITDB_ARGS '--encoding=SQL_ASCII --lc-collate=C --lc-ctype=C'

COPY --from=base /opt/bacula/scripts/make_postgresql_tables /docker-entrypoint-initdb.d/make_postgresql_tables

COPY --from=base /opt/bacula/scripts/grant_postgresql_privileges /docker-entrypoint-initdb.d/grant_postgresql_privileges

RUN { \
	    echo '#!/bin/bash'; \
	    echo 'sh /docker-entrypoint-initdb.d/make_postgresql_tables --username=$POSTGRES_USER'; \
	    echo 'sh /docker-entrypoint-initdb.d/grant_postgresql_privileges --username=$POSTGRES_USER'; \
    } >> /docker-entrypoint-initdb.d/deploy_database.sh \
    && chmod +x /docker-entrypoint-initdb.d/deploy_database.sh \
    && chown postgres. /docker-entrypoint-initdb.d/deploy_database.sh

RUN chown -R postgres. /docker-entrypoint-initdb.d/*

VOLUME ["/var/lib/postgresql/data"]

EXPOSE 5432/tcp