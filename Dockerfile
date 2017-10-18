FROM phusion/baseimage:latest
ENV PG_MAJOR 10
ENV POSTGIS_MAJOR 2.4
ENV PG_VERSION 10.0-1.pgdg16.04+1
ENV POSTGIS_VERSION 2.4.0+dfsg-1.pgdg16.04+1
RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold" && rm -rf /var/lib/apt/lists/*
RUN set -ex; \
    apt-get update; \
    apt-get install -y wget; \
    echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list; \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -; \
    rm -rf /var/lib/apt/lists/*
RUN groupadd -r --gid=999 postgres && useradd -r -g postgres --uid=999 postgres
RUN set -x; \
    apt-get update; \
    apt-get install -y postgresql-common; \
    sed -ri 's/#(create_main_cluster) .*/\1 = false/' /etc/postgresql-common/createcluster.conf; \
    apt-get install -y \
            postgresql-${PG_MAJOR}=${PG_VERSION} \
            postgresql-plpython3-${PG_MAJOR}=${PG_VERSION} \
            postgresql-plperl-${PG_MAJOR}=${PG_VERSION} \
            ; \
    rm -rf /var/lib/apt/lists/*
RUN mkdir /docker-entrypoint-initdb.d
ENV PATH $PATH:/usr/lib/postgresql/$PG_MAJOR/bin
ENV PGDATA /var/lib/postgresql/data
RUN mkdir -p "$PGDATA" && chown -R postgres:postgres "$PGDATA" && chmod 777 "$PGDATA"
COPY docker-entrypoint.sh /usr/local/bin
ENTRYPOINT ["/sbin/my_init", "--", "docker-entrypoint.sh"]
CMD ["postgres"]
