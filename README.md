**PostgreSQL Docker Image**

Docker container based on Phusion baseimage and the official Postgres Docker
image, with a few additional extensions (plpython3, plperl).

Primarily redone to be able to use the init system and cron from baseimage to
automate setup and maintenance tasks (e.g., certificate retrieval an renewal).

Currently at **PostgreSQL 10.0**. 

## Details

- `docker-entrypoint.sh` taken basically directly from the official PostgreSQL
  image. As a result, all the same configuration variables apply.

