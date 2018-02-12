#!/bin/bash
set -e

if [ -z "$WWW_DATA_UID" ]; then
    WWW_DATA_UID=33
fi

usermod -u $WWW_DATA_UID www-data

chown -R www-data ~www-data

source /usr/local/bin/docker-entrypoint.sh "apache2-foreground"
