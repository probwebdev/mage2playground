#!/bin/bash

[ "$DEBUG" = "true" ] && set -x

# Ensure our Magento directory exists
mkdir -p $MAGENTO_ROOT
chown www-data:www-data $MAGENTO_ROOT
chmod u+x bin/magento

exec "$@"
