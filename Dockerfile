# syntax = docker/dockerfile:1.0-experimental
ARG COMPOSER_VER=1.8
ARG PHP_VER=7.2-fpm-alpine

# Composer
FROM composer:$COMPOSER_VER as composer

WORKDIR /app

COPY composer.json composer.lock ./

RUN --mount=type=secret,id=auth_json,dst=/app/auth.json,required composer install --ignore-platform-reqs

# Mage 2 Stage
FROM php:$PHP_VER

ARG REDIS_VER=4.3.0
ARG XDEBUG_VER=2.7.0

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
      git \
      bash \
      mariadb-client \
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

COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY --from=composer /app ./

COPY docker/mage2/etc /usr/local/etc/

RUN mkdir /var/log/php-fpm

EXPOSE 9000

CMD ["php-fpm", "-R"]
