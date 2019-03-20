ARG PHP_VER=7.2-fpm-alpine

FROM php:$PHP_VER

WORKDIR /var/www/html

RUN apk add --update && \
    apk add --no-cache --virtual .build-deps freetype-dev libpng-dev libjpeg-turbo-dev \
      libzip-dev libxslt-dev icu-dev zlib-dev  && \
    apk add --no-cache --virtual .runtime-deps curl git freetype libpng libjpeg-turbo icu-libs libxslt && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ \
      --with-jpeg-dir=/usr/include \
      --with-png-dir=/usr/include && \
    docker-php-ext-configure zip --with-libzip && \
    docker-php-ext-install \
      gd \
      xsl \
      pdo_mysql \
      opcache \
      bcmath \
      soap \
      intl && \
    apk del .build-deps

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

USER www-data

COPY composer.json composer.lock ./

RUN composer install && \
    composer clear-cache

EXPOSE 80
