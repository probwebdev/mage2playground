ARG COMPOSER_VER=1.8
ARG PHP_CLI_VER=7.2-cli-alpine

# Composer
FROM composer:$COMPOSER_VER as composer

# Mage 2 Stage
FROM php:$PHP_CLI_VER

ARG PHP_REDIS_VER=4.3.0

WORKDIR /var/www/html

RUN apk add --no-cache --virtual .build-deps \
      build-base \
      autoconf \
      freetype-dev \
      libpng-dev \
      libjpeg-turbo-dev \
      libzip-dev \
      libxslt-dev \
      icu-dev \
      zlib-dev && \
    apk add --no-cache --virtual .runtime-deps \
      busybox-suid \
      mariadb-client \
      git \
      sudo \
      bash \
      freetype \
      libpng \
      libjpeg-turbo \
      icu-libs \
      libxslt \
      libzip && \
    docker-php-ext-configure gd \
      --with-freetype-dir=/usr/include/ \
      --with-jpeg-dir=/usr/include \
      --with-png-dir=/usr/include && \
    docker-php-ext-configure zip \
      --with-libzip && \
    docker-php-ext-install \
      zip \
      gd \
      xsl \
      pdo_mysql \
      opcache \
      bcmath \
      soap \
      intl && \
    pecl install redis-$PHP_REDIS_VER && \
    docker-php-ext-enable redis && \
    apk del --no-network .build-deps

COPY --chown=www-data:www-data composer.json composer.lock ./
COPY docker/cli/etc /usr/local/etc/
COPY docker/cli/bin /usr/local/bin/
COPY docker/cli/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
COPY --from=composer /usr/bin/composer /usr/local/bin/composer

RUN curl -sL https://files.magerun.net/n98-magerun2.phar -o /usr/local/bin/n98-magerun2 && chmod +x /usr/local/bin/n98-magerun2

RUN chmod +x /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/mage2install

ENV MAGENTO_ROOT /var/www/html
ENV COMPOSER_HOME /var/www/html/var/composer_home
ENV PATH ${MAGENTO_ROOT}/bin:${PATH}
ENV CRON_INSTALL false
ENV DEBUG false

USER www-data

ENTRYPOINT ["docker-entrypoint"]

CMD ["/bin/bash"]
