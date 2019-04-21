#!/usr/bin/env sh

set -e

if [[ -n "${WEBPACK_HOST}" ]]; then
  WEBPACK_HOST=${WEBPACK_HOST}
else
  WEBPACK_HOST=localhost
fi

yarn run build || exit $?

yarn workspace @magento/venia-concept run watch -- --host ${WEBPACK_HOST}
