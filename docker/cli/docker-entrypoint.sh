#!/bin/bash

[[ "${DEBUG}" = "true" ]] && set -x

# Ensure our Magento directory exists
mkdir -p ${MAGENTO_ROOT}

[[ "${CRON_INSTALL}" = "true" ]] && magento cron:install

exec "$@"
