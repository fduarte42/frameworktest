FROM fduarte42/docker-php:7.2

ENV VIRTUAL_PORT 80
ENV VIRTUAL_HOST "phpmyadmin.fw-test.lvh.me, www.fw-test.lvh.me, fw-test.lvh.me"
ENV APACHE_HOST "www.fw-test.lvh.me"
ENV APACHE_ALIAS "localhost"
ENV BASE_DOMAIN "fw-test.lvh.me"
ENV DOCUMENT_ROOT "public"
ENV APP_ENV "dev"
ENV APPLICATION_ENVIRONMENT "dev"
ENV TYPO3_CONTEXT "dev"
ENV PHPMYADMIN_RESTRICTION "0"

COPY ../container/php/php.ini /usr/local/etc/php/conf.d/zzz-custom.ini
COPY ../container/php/apache2/sites-enabled/ /etc/apache2/sites-enabled/
COPY ../container/php/ssmtp/ssmtp.production.conf /etc/ssmtp/ssmtp.conf
COPY ../container/php/ssh/ /ssh/
COPY ../container/php/cron/crontab /tmp/crontab
COPY ../../../.env /etc/environment
COPY "../../../htdocs/" /var/www/html/
RUN chown -R www-data:www-data /var/www/html && chmod -R 775 /var/www/html

VOLUME ["/var/www/html"]

WORKDIR /var/www/html

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
