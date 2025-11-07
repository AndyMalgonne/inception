#!/bin/bash
set -e

# Préparation des répertoires nécessaires
mkdir -p /run/mysqld /var/run/mysqld
chown -R mysql:mysql /run/mysqld /var/run/mysqld


if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "🧩 Initialisation de la base MariaDB..."

    mariadb-install-db --user=mysql --datadir=/var/lib/mysql --auth-root-authentication-method=normal
fi

# Toujours appliquer la config des utilisateurs et de la base
echo "🚀 Configuration initiale..."
mariadbd --user=mysql --bootstrap <<EOF
USE mysql;
FLUSH PRIVILEGES;

CREATE DATABASE IF NOT EXISTS \`${MYSQL_DB}\`;

CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';

GRANT ALL PRIVILEGES ON \`${MYSQL_DB}\`.* TO '${MYSQL_USER}'@'%';
GRANT ALL PRIVILEGES ON \`${MYSQL_DB}\`.* TO '${MYSQL_USER}'@'localhost';

ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

# Lancer MariaDB au premier plan
echo "✅ MariaDB prête — lancement du serveur principal."
exec mariadbd --user=mysql --console
