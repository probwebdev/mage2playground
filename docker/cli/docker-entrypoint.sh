#!/bin/bash

[[ "${DEBUG}" = "true" ]] && set -x

# Ensure our Magento directory exists
mkdir -p ${MAGENTO_ROOT}

if [[ -f ${MAGENTO_ROOT}/auth.json ]]; then
    export COMPOSER_AUTH=$(cat ${MAGENTO_ROOT}/auth.json)
fi

exec "$@"
