#!/bin/bash
set -e

[[ "${DEBUG}" = "true" ]] && set -x

# Ensure our Magento directory exists
mkdir -p ${MAGENTO_ROOT}

# Change magento user UID and GID
[[ ! -z "${MAGE2_UID}" ]] && usermod -u ${MAGE2_UID} magento
[[ ! -z "${MAGE2_GID}" ]] && groupmod -g ${MAGE2_GID} magento

sudo -u magento magento cron:install

exec "$@"
