#!/usr/bin/env bash
set -e

cd /var/www/html
chown -R www-data:www-data .
chmod -R 775 .
#sudo -u www-data composer install -n
