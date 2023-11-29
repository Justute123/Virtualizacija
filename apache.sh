#!/bin/bash
apt-get update
apt-get install -y apache2
systemctl start apache2
systemctl enable apache2

echo "Apache Server is running!" > /var/www/html/index.html
echo "Apache Server configured!"