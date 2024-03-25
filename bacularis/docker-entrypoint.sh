#!/usr/bin/env bash

set -e

trap stop SIGTERM SIGINT SIGQUIT SIGHUP ERR

function start_php_fpm(){
    /etc/init.d/php7.4-fpm start
}

function stop_php_fpm(){
    /etc/init.d/php7.4-fpm stop
}

function start(){
    start_php_fpm
}

start

exec "$@"