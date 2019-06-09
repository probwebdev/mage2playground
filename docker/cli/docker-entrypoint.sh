#!/bin/bash
set -e

[[ "${DEBUG}" = "true" ]] && set -x

# Ensure our Magento directory exists
mkdir -p ${MAGENTO_ROOT}

# Get current magento user UID-GID
CURRENT_UID="$(id -u magento)"
CURRENT_GID="$(id -g magento)"

if [[ -f ${MAGENTO_ROOT}/auth.json ]]; then
    export COMPOSER_AUTH=$(cat ${MAGENTO_ROOT}/auth.json)
fi

# Change magento user UID and GID
[[ ! -z "${MAGE2_UID}" && "${MAGE2_UID}" != "${CURRENT_UID}" ]] && \
    usermod -u ${MAGE2_UID} magento && \
    find ${MAGENTO_ROOT} -user ${CURRENT_UID} -exec chown -h magento {} +

[[ ! -z "${MAGE2_GID}" && "${MAGE2_GID}" != "${CURRENT_GID}" ]] && \
    groupmod -g ${MAGE2_GID} magento && \
    find ${MAGENTO_ROOT} -group ${CURRENT_GID} -exec chgrp -h magento {} +

# Run command as magento user
if [ "$1" = 'bash' -a "$(id -u)" = '0' ]; then
	exec su-exec magento "$@"
fi

exec "$@"
