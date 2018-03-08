#!/usr/bin/env bash
set -e

cd /var/www/html
sudo -u www-data composer install -n

exit 0