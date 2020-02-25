ARG COMPOSER_VER=1.9
ARG PHP_CLI_VER=7.3-cli-alpine

# Composer
FROM composer:$COMPOSER_VER as composer

# Mage 2 Stage
FROM php:$PHP_CLI_VER

ARG PHP_REDIS_VER=5.0.2

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

RUN apk add --no-cache --virtual .runtime-deps \
      'su-exec>=0.2' \
      sudo \
      bash \
      shadow \
      busybox-suid \
      mariadb-client \
      git \
      freetype \
      libpng \
      libjpeg-turbo \
      icu-libs \
      libxslt \
      libzip

ARG MAGE2_UID=1000
ARG MAGE2_GID=1000
RUN addgroup -S -g $MAGE2_GID magento && \
    adduser -S -G magento -u $MAGE2_UID magento && \
    adduser magento www-data

COPY etc /usr/local/etc/
COPY bin /usr/local/bin/
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint
COPY --from=composer /usr/bin/composer /usr/local/bin/composer

RUN curl -sL https://files.magerun.net/n98-magerun2.phar -o /usr/local/bin/n98-magerun2 && chmod +x /usr/local/bin/n98-magerun2

RUN chmod +x /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/mage2install.sh

ENV MAGENTO_ROOT /var/www/html
ENV COMPOSER_HOME /var/www/html/var/composer_home
ENV PATH ${MAGENTO_ROOT}/bin:${PATH}
ENV DEBUG false

ENTRYPOINT ["docker-entrypoint"]

CMD tail -f /dev/null
