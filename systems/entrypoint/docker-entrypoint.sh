#!/usr/bin/env bash

set -e

trap stop SIGTERM SIGINT SIGQUIT SIGHUP ERR

function start_postgresql(){
    /etc/init.d/postgresql start
}

function stop_postgresql(){
    /etc/init.d/postgresql stop
}

function start_bacula(){
    /opt/bacula/scripts/bacula start
}

function stop_bacula(){
    /opt/bacula/scripts/bacula stop
}

function start_php_fpm(){
    /etc/init.d/php8.1-fpm start
}

function stop_php_fpm(){
    /etc/init.d/php8.1-fpm stop
}

function change_bacula_config(){
    find /opt/bacula/etc -type f -name "*.conf" -exec sed -i "s/buildkitsandbox/$HOSTNAME/g" {} \;
}

function start(){
    start_postgresql
    change_bacula_config
    start_bacula
    start_php_fpm
}

start

exec "$@"