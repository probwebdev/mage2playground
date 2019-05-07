#!/bin/bash
set -e

[[ "${DEBUG}" = "true" ]] && set -x

# Ensure our Magento directory exists
mkdir -p ${MAGENTO_ROOT}

if [[ -f ${MAGENTO_ROOT}/auth.json ]]; then
    export COMPOSER_AUTH=$(cat ${MAGENTO_ROOT}/auth.json)
fi

# Change magento user UID and GID
[[ ! -z "${MAGE2_UID}" ]] && usermod -u ${MAGE2_UID} magento
[[ ! -z "${MAGE2_GID}" ]] && groupmod -g ${MAGE2_GID} magento

if [ "$1" = 'bash' -a "$(id -u)" = '0' ]; then
	exec su-exec magento "$@"
fi

exec "$@"
