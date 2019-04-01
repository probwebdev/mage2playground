#!/bin/bash

[[ "${DEBUG}" = "true" ]] && set -x

# Ensure our Magento directory exists
mkdir -p ${MAGENTO_ROOT}

sudo -u www-data magento cron:install

exec "$@"
