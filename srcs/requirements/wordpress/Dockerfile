FROM debian:bookworm

RUN apt update -y

RUN apt-get update -y && apt-get install -y --no-install-recommends \
    php-fpm php-mysql default-mysql-client curl ca-certificates unzip \
  && rm -rf /var/lib/apt/lists/*

COPY ./tools/script.sh /
RUN chmod +x /script.sh


CMD [ "/script.sh" ]