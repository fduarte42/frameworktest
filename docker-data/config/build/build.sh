#!/usr/bin/env bash
set -e

cd /var/www/html
ls -la
chown -R www-data:www-data .
chmod -R 775 .
sudo -u www-data composer install -n
ls -la

cd /var/www/html2
ls -la
chown -R www-data:www-data .
chmod -R 775 .
sudo -u www-data composer install -n
ls -la
