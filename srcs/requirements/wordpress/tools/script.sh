#!/bin/bash
set -e

mkdir -p /var/www/html
chown -R www-data:www-data /var/www/html
cd /var/www/html

if ! command -v wp >/dev/null 2>&1; then
  curl -fsSL -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  chmod +x /usr/local/bin/wp
fi

: ${DB_HOST:=mariadb}

echo "Waiting for database ${DB_HOST}:3306..."
ATTEMPTS=0
until mysqladmin ping -h"${DB_HOST}" --silent; do
  ATTEMPTS=$((ATTEMPTS+1))
  if [ $ATTEMPTS -ge 60 ]; then
    echo "Timed out waiting for database at ${DB_HOST}:3306" >&2
    exit 1
  fi
  printf '.'
  sleep 1
done
echo " DB is up."

if [ ! -f index.php ]; then
  wp core download --allow-root
fi

if [ ! -f wp-config.php ]; then
  wp config create --dbname="${MYSQL_DB}" --dbuser="${MYSQL_USER}" --dbpass="${MYSQL_PASSWORD}" --dbhost="${DB_HOST:-mariadb}" --skip-salts --allow-root
fi

if ! wp core is-installed --allow-root >/dev/null 2>&1; then
  wp core install --url="${WP_SITE_URL}" --title="${WP_TITLE}" --admin_user="${WP_ADMIN_USR}" --admin_password="${WP_ADMIN_PWD}" --admin_email="${WP_ADMIN_EMAIL}" --skip-email --allow-root || true
fi

for f in /etc/php/*/fpm/pool.d/www.conf; do
  [ -f "$f" ] && sed -i 's|listen = .*|listen = 9000|g' "$f" || true
done

mkdir -p /run/php
chown -R www-data:www-data /run/php

if command -v php-fpm >/dev/null 2>&1; then
    PHP_FPM=php-fpm
elif command -v php-fpm8.2 >/dev/null 2>&1; then
    PHP_FPM=php-fpm8.2
else
    echo "No php-fpm binary found" >&2
    exit 1
fi

exec "$PHP_FPM" -F
