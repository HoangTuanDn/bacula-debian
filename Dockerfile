FROM ubuntu:22.04

ENV TZ="Asia/Ho_Chi_Minh"

ENV WEB_USER=www-data

RUN export DEBIAN_FRONTEND=noninteractive && apt update \
    && apt-get install -y --no-install-recommends wget gnupg sudo \
    && apt-get install -y curl patch zip unzip php-cli php-bcmath php-curl php-xml php-json php-ldap php-mysql php-pdo php-pgsql php-intl php-fpm \
    && apt-get install -y postgresql postgresql-client \
    && apt-get install -y nginx 

RUN echo "deb [arch=amd64] https://www.bacula.org/packages/654b09f35d0a4/debs/13.0.1 jammy main" > /etc/apt/sources.list.d/Bacula-Community.list \
    && wget https://www.bacula.org/downloads/Bacula-4096-Distribution-Verification-key.asc \
    && apt-key add Bacula-4096-Distribution-Verification-key.asc \
    && rm Bacula-4096-Distribution-Verification-key.asc \
    && mkdir /etc/dbconfig-common

COPY "common/config/bacula-postgresql.conf" /etc/dbconfig-common

RUN export DEBIAN_FRONTEND=noninteractive && apt update \
    && service postgresql start \
    && apt-get install -y bacula-postgresql 

RUN PSQL_VERSION=$(pg_config --version | cut -d' ' -f2 | cut -d'.' -f1) \
    && sed -i '/# TYPE/ a host    bacula          bacula          0.0.0.0/0               md5' /etc/postgresql/${PSQL_VERSION}/main/pg_hba.conf \
    && sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /etc/postgresql/${PSQL_VERSION}/main/postgresql.conf 

COPY "systems/sudoers.d/bacularis-standalone" /etc/sudoers.d/

COPY "systems/entrypoint/docker-entrypoint.sh" /docker-entrypoint.sh

WORKDIR /var/www

ENV COMPOSER_ALLOW_SUPERUSER=1

RUN curl -s http://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && composer --no-install --no-scripts create-project bacularis/bacularis-app \
    && cd bacularis-app && composer config --no-plugins allow-plugins.cweagans/composer-patches true \
    && composer install && composer run-script post-create-project-cmd && cd .. \
    && bacularis-app/protected/tools/install.sh -w nginx -u ${WEB_USER} -p /var/run/php/php8.1-fpm.sock \
    && cp bacularis-app/bacularis-nginx.conf /etc/nginx/sites-available/bacularis.conf \
    && ln /etc/nginx/sites-available/bacularis.conf /etc/nginx/sites-enabled \
    && chown -R ${WEB_USER}:${WEB_USER} bacularis-app/protected \
    && chown -R ${WEB_USER}:${WEB_USER} bacularis-app/htdocs/assets 

COPY "systems/config/api-standalone.conf" /var/www/bacularis-app/protected/vendor/bacularis/bacularis-api/API/Config/api.conf

COPY --chown=${WEB_USER}:${WEB_USER} common/config/API/* /var/www/bacularis-app/protected/vendor/bacularis/bacularis-api/API/Config/

COPY --chown=${WEB_USER}:${WEB_USER} common/config/Web/* /var/www/bacularis-app/protected/vendor/bacularis/bacularis-web/Web/Config/

EXPOSE 9101/tcp 9102/tcp 9103/tcp 9097/tcp

VOLUME ["/var/lib/postgresql", "/opt/bacula/etc", "/opt/bacula/archive"]

ENTRYPOINT [ "/docker-entrypoint.sh" ]

CMD ["nginx", "-g", "daemon off;"]



