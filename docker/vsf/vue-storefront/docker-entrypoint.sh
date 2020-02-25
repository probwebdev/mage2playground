#!/bin/sh
set -e

# Ensure Project directory exists
mkdir -p /home/node/app

# Get current node user UID-GID
CURRENT_UID="$(id -u node)"
CURRENT_GID="$(id -g node)"

# Change node user UID and GID
[[ ! -z "${VUE_STOREFRONT_UID}" && "${VUE_STOREFRONT_UID}" != "${CURRENT_UID}" ]] && \
    usermod -u ${VUE_STOREFRONT_UID} node

[[ ! -z "${VUE_STOREFRONT_GID}" && "${VUE_STOREFRONT_GID}" != "${CURRENT_GID}" ]] && \
    groupmod -g ${VUE_STOREFRONT_GID} node && \
    find ${VUE_STOREFRONT_ROOT} -group ${CURRENT_GID} -exec chgrp -h node {} +

su-exec node yarn install || exit $?
su-exec node yarn build:client && yarn build:server && yarn build:sw || exit $?

exec su-exec node "$@"
