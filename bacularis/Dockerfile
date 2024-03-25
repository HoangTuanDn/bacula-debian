ARG B_VERSION=13.0.2

FROM nhtdn/bacula-base:${B_VERSION}

ENV WEB_USER=www-data

RUN export DEBIAN_FRONTEND=noninteractive && apt update \
    && apt-get install -y --no-install-recommends \
        sudo \
        patch \
        zip \
        unzip \
        php-cli \
        php-bcmath \
        php-curl \
        php-xml \
        php-json \
        php-ldap \
        php-mysql \
        php-pdo \
        php-pgsql \
        php-intl \
        php-fpm \
        nginx 

RUN apt-get clean autoclean && rm -rf /var/lib/cache

COPY config/sudoers.d/bacularis-standalone /etc/sudoers.d/

WORKDIR /var/www

ENV COMPOSER_ALLOW_SUPERUSER=1

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer --no-install --no-scripts create-project bacularis/bacularis-app \
    && cd bacularis-app && composer config --no-plugins allow-plugins.cweagans/composer-patches true \
    && composer install && composer run-script post-create-project-cmd && cd .. \
    && bacularis-app/protected/tools/install.sh -w nginx -u ${WEB_USER} -p /var/run/php/php7.4-fpm.sock \
    && cp bacularis-app/bacularis-nginx.conf /etc/nginx/sites-available/bacularis.conf \
    && ln /etc/nginx/sites-available/bacularis.conf /etc/nginx/sites-enabled \
    && chown -R ${WEB_USER}:${WEB_USER} bacularis-app/protected \
    && chown -R ${WEB_USER}:${WEB_USER} bacularis-app/htdocs/assets 

COPY config/api.conf /var/www/bacularis-app/protected/vendor/bacularis/bacularis-api/API/Config/api.conf

COPY --chown=${WEB_USER}:${WEB_USER} config/API/* /var/www/bacularis-app/protected/vendor/bacularis/bacularis-api/API/Config/

COPY --chown=${WEB_USER}:${WEB_USER} config/Web/* /var/www/bacularis-app/protected/vendor/bacularis/bacularis-web/Web/Config/

COPY docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 9097/tcp

VOLUME ["/var/www/bacularis-app/protected/vendor/bacularis/bacularis-api/API/Config", "/var/www/bacularis-app/protected/vendor/bacularis/bacularis-web/Web/Config"]

ENTRYPOINT [ "/docker-entrypoint.sh" ]

CMD ["nginx", "-g", "daemon off;"]