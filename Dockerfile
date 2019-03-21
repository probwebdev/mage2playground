# syntax = docker/dockerfile:1.0-experimental
ARG PHP_VER=7.2-fpm-alpine
ARG COMPOSER_VER=1.8

# Composer
FROM composer:$COMPOSER_VER as composer

# Mage 2 Stage
FROM php:$PHP_VER

WORKDIR /var/www/html

RUN apk add --update && \
    apk add --no-cache --virtual .build-deps freetype-dev libpng-dev libjpeg-turbo-dev \
      libzip-dev libxslt-dev icu-dev zlib-dev  && \
    apk add --no-cache --virtual .runtime-deps curl git freetype libpng libjpeg-turbo icu-libs libxslt libzip && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ \
      --with-jpeg-dir=/usr/include \
      --with-png-dir=/usr/include && \
    docker-php-ext-configure zip --with-libzip && \
    docker-php-ext-install \
      zip \
      gd \
      xsl \
      pdo_mysql \
      opcache \
      bcmath \
      soap \
      intl && \
    apk del .build-deps

COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY composer.json composer.lock ./

RUN --mount=type=secret,id=auth_json,dst=/var/www/html/auth.json,required composer install && \
    composer clear-cache

USER www-data

EXPOSE 80
