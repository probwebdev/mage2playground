#!/bin/sh
set -e

# Ensure Project directory exists
mkdir -p ${PWA_STUDIO_ROOT}/app

# Get current node user UID-GID
CURRENT_UID="$(id -u node)"
CURRENT_GID="$(id -g node)"

# Change node user UID and GID
[[ ! -z "${PWA_STUDIO_UID}" && "${PWA_STUDIO_UID}" != "${CURRENT_UID}" ]] && \
    usermod -u ${PWA_STUDIO_UID} node

[[ ! -z "${PWA_STUDIO_GID}" && "${PWA_STUDIO_GID}" != "${CURRENT_GID}" ]] && \
    groupmod -g ${PWA_STUDIO_GID} node && \
    find ${PWA_STUDIO_ROOT} -group ${CURRENT_GID} -exec chgrp -h node {} +

su-exec node yarn run build || exit $?
exec su-exec node "$@"
