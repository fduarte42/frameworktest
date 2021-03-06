#!/bin/sh

if [ ! -f "$(pwd)/.env" ]; then
    echo "Environment File missing. Rename .env-dist to .env and customize it before starting this project."
    exit
fi

# Read .env file
loadENV() {
    local IFS=$'\n'
    for VAR in $(cat .env | grep -v "^#"); do
        eval $(echo "$VAR" | sed 's/=\(.*\)/="\1"/')
    done
}
loadENV

if [ -z "$PROJECTNAME" ]; then
    PROJECTNAME="${PWD##*/}"
fi

PHP_VIRTUAL_HOST="www.$BASE_DOMAIN, $BASE_DOMAIN"
PHP_APACHE_ALIAS="localhost"
if [ -f "$(pwd)/docker-data/config/container/php/apache2/aliases.txt" ]; then
    loadAliasDomain() {
        local IFS=$'\n'
        for DOMAIN in $(cat docker-data/config/container/php/apache2/aliases.txt | grep -v "^#"); do
            DOMAIN=$(echo $DOMAIN | xargs)
            if [ ! -z $DOMAIN ]; then
                PHP_VIRTUAL_HOST="$PHP_VIRTUAL_HOST, $DOMAIN"
                PHP_APACHE_ALIAS="$PHP_APACHE_ALIAS $DOMAIN"
            fi
        done
    }
    loadAliasDomain
fi

echo building Dockerfile ...
cat docker-data/config/build/Dockerfile.tpl | \
    sed "s/{{php_version}}/$PHP_VERSION-squashed/g" | \
    sed "s/{{base_domain}}/$BASE_DOMAIN/g" | \
    sed "s/{{php_virtual_host}}/$PHP_VIRTUAL_HOST/g" | \
    sed "s/{{php_apache_alias}}/$PHP_APACHE_ALIAS/g" | \
    sed "s/{{document_root}}/$DOCUMENT_ROOT/g" | \
    sed "s/{{environment}}/$ENVIRONMENT/g" | \
    sed "s/{{phpmyadmin_restriction}}/$PHPMYADMIN_RESTRICTION/g" | \
    sed "s/{{htdocs_folder}}/$HTDOCS_FOLDER/g" > Dockerfile

echo finished

exit
