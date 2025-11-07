#!/bin/bash
set -e

esc_cert=$(printf '%s' "$ssl_certificate" | sed 's/[&]/\\&/g')
esc_key=$(printf '%s' "$ssl_certificate_key" | sed 's/[&]/\\&/g')
esc_domain=$(printf '%s' "$nginx_domain" | sed 's/[&]/\\&/g')

sed -i "s|my_cert|$esc_cert|g" /etc/nginx/sites-available/default
sed -i "s|my_key|$esc_key|g" /etc/nginx/sites-available/default
sed -i "s|DOMAIN_NAME|$esc_domain|g" /etc/nginx/sites-available/default

nginx -g "daemon off;"