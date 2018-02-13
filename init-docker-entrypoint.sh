#!/bin/bash
set -e

#Additional ENV variable to change www-data UID
if [ -z "$WWW_DATA_UID" ]; then
    WWW_DATA_UID=33
fi
usermod -u $WWW_DATA_UID www-data

#To work with bash as a shell for www-data, we have to give him access to his home dir
chown -R www-data ~www-data

#run dragontek/octobercms's entrypoint
source /usr/local/bin/docker-entrypoint.sh "apache2-foreground"
