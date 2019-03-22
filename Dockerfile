# syntax = docker/dockerfile:1.0-experimental
ARG PHP_VER=7.2-fpm-alpine
ARG COMPOSER_VER=1.8

# Composer
FROM composer:$COMPOSER_VER as composer

WORKDIR /app

COPY composer.json composer.lock ./

RUN --mount=type=secret,id=auth_json,dst=/app/auth.json,required composer install --ignore-platform-reqs

# Mage 2 Stage
FROM php:$PHP_VER

WORKDIR /var/www/html

RUN apk add --no-cache --virtual .build-deps \
      freetype-dev \
      libpng-dev \
      libjpeg-turbo-dev \
      libzip-dev \
      libxslt-dev \
      icu-dev \
      zlib-dev  && \
    apk add --no-cache --virtual .runtime-deps \
      git \
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
    apk del --no-network .build-deps

COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY --from=composer /app ./

EXPOSE 9000

CMD ["php-fpm"]
