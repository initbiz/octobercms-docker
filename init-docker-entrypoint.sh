#!/bin/bash
set -e

source /usr/local/bin/docker-entrypoint.sh "apache2-foreground"

exec "$@"
