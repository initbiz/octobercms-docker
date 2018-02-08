#!/bin/bash
set -e

curl -fsSL https://raw.githubusercontent.com/Dragontek/octobercms/master/docker-entrypoint.sh > /tmp/dragontekentrypoint.sh
source /tmp/dragontekentrypoint.sh

#UID set for volume permissions
if [ -z "$WWW_DATA_UID" ]; then
   WWW_DATA_UID='33'
fi
usermod -u $WWW_DATA_UID www-data

chown -R www-data:www-data ~www-data

exec "$@"
