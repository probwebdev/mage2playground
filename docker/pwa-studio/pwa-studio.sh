#!/bin/sh
set -e

# Ensure Project directory exists
mkdir -p ${PWASTUDIO_ROOT}/app

# Get current node user UID-GID
CURRENT_UID="$(id -u node)"
CURRENT_GID="$(id -g node)"

# Change node user UID and GID
[[ ! -z "${PWASTUDIO_UID}" && "${PWASTUDIO_UID}" != "${CURRENT_UID}" ]] && \
    usermod -u ${PWASTUDIO_UID} node

[[ ! -z "${PWASTUDIO_GID}" && "${PWASTUDIO_GID}" != "${CURRENT_GID}" ]] && \
    groupmod -g ${PWASTUDIO_GID} node && \
    find ${PWASTUDIO_ROOT} -group ${CURRENT_GID} -exec chgrp -h node {} +

su-exec node yarn run build || exit $?
exec su-exec node "$@"
