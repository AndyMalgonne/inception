if ! grep -q "amalgonn.42.fr" /etc/hosts; then
    echo "127.0.0.1 amalgonn.42.fr" >> /etc/hosts
fi