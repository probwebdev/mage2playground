#!/bin/bash
set -e

[[ "${DEBUG}" = "true" ]] && set -x

# Update Configuration Files
[[ ! -z "${PHP_MEMORY_LIMIT}" ]] && sed -i "s/!PHP_MEMORY_LIMIT!/${PHP_MEMORY_LIMIT}/" /usr/local/etc/php/conf.d/zz-mage2.ini
[[ ! -z "${UPLOAD_MAX_FILESIZE}" ]] && sed -i "s/!UPLOAD_MAX_FILESIZE!/${UPLOAD_MAX_FILESIZE}/" /usr/local/etc/php/conf.d/zz-mage2.ini
[[ ! -z "${MAGENTO_RUN_MODE}" ]] && sed -i "s/!MAGENTO_RUN_MODE!/${MAGENTO_RUN_MODE}/" /usr/local/etc/php-fpm.conf

# Ensure our Magento directory exists
mkdir -p ${MAGENTO_ROOT}

# Get current magento user UID-GID
CURRENT_UID="$(id -u magento)"
CURRENT_GID="$(id -g magento)"

# Change magento user UID and GID
[[ ! -z "${MAGE2_UID}" && "${MAGE2_UID}" != "${CURRENT_UID}" ]] && \
    usermod -u ${MAGE2_UID} magento && \
    find ${MAGENTO_ROOT} -user ${CURRENT_UID} -exec chown -h magento {} +
[[ ! -z "${MAGE2_GID}" && "${MAGE2_GID}" != "${CURRENT_GID}" ]] && \
    groupmod -g ${MAGE2_GID} magento && \
    find ${MAGENTO_ROOT} -group ${CURRENT_GID} -exec chgrp -h magento {} +

# Enable Xdebug
[[ "${PHP_ENABLE_XDEBUG}" = "true" ]] && \
    docker-php-ext-enable xdebug && \
    echo "Xdebug is enabled"

exec "$@"
