FROM debian:bookworm

RUN apt -y update && apt install -y nginx && apt install openssl -y

RUN mkdir -p /etc/ssl/private /etc/ssl/certs && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
      -keyout /etc/ssl/private/amalgonn.key \
      -out /etc/ssl/certs/amalgonn.crt \
      -subj "/CN=amalgonn.42.fr"

COPY ./tools/script.sh /
RUN chmod +x /script.sh

COPY ./conf/default /etc/nginx/sites-available/default


CMD [ "/script.sh" ]