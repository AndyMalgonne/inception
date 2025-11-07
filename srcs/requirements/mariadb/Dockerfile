FROM debian:bookworm

RUN apt-get update -y && apt-get install mariadb-server -y

COPY ./tools/script.sh /
COPY ./conf/mariadb.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
RUN chmod +x /script.sh

EXPOSE 3306

ENTRYPOINT [ "bash", "/script.sh" ]