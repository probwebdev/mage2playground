ARG COMPOSER_VER=1.8
ARG PHP_CLI_VER=7.2-cli-alpine

# Composer
FROM composer:$COMPOSER_VER as composer

# Mage 2 Stage
FROM php:$PHP_CLI_VER

ARG REDIS_VER=4.3.0

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
    pecl install redis-$REDIS_VER && \
    docker-php-ext-enable redis && \
    apk del --no-network .build-deps

VOLUME /root/.composer/cache

WORKDIR /var/www/html

COPY docker/cli/etc /usr/local/etc/
COPY docker/cli/bin /usr/local/bin/
COPY docker/cli/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN chmod +x /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/mage2*

ENV MAGENTO_ROOT /var/www/html
ENV DEBUG false

ENTRYPOINT ["docker-entrypoint"]

CMD ["/bin/bash", "-c"]
