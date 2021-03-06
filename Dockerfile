﻿FROM fduarte42/docker-php:7.2

ENV VIRTUAL_PORT 80
ENV VIRTUAL_HOST "phpmyadmin.fw-test.liberda.de, www.fw-test.liberda.de, fw-test.liberda.de"
ENV APACHE_HOST "www.fw-test.liberda.de"
ENV APACHE_ALIAS "localhost"
ENV BASE_DOMAIN "fw-test.liberda.de"
ENV DOCUMENT_ROOT "public"
ENV APP_ENV "dev"
ENV APPLICATION_ENVIRONMENT "dev"
ENV TYPO3_CONTEXT "dev"
ENV PHPMYADMIN_RESTRICTION "0"

COPY docker-data/config/container/php/php.ini /usr/local/etc/php/conf.d/zzz-custom.ini
COPY docker-data/config/container/php/apache2/sites-enabled/ /etc/apache2/sites-enabled/
COPY docker-data/config/container/php/ssmtp/ssmtp.production.conf /etc/ssmtp/ssmtp.conf
COPY docker-data/config/container/php/ssh/ /ssh/
COPY docker-data/config/container/php/cron/crontab /tmp/crontab
COPY .env-build /etc/environment

COPY "htdocs/" /var/www/html/

COPY docker-data/config/build/build.sh /build.sh
RUN /bin/bash /build.sh
