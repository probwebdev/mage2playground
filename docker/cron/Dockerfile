ARG MAGE2CLI_IMAGE=mage2cli:7.2
FROM $MAGE2CLI_IMAGE

USER root

WORKDIR /var/www/html

COPY docker/cron/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

ENTRYPOINT ["docker-entrypoint"]

CMD crond -l 2 -f
