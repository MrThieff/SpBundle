FROM php:7.3.7-cli-alpine3.10

RUN apk add --update --no-cache \
        git \
        openssh \
        openssh-client \
        libcurl \
        curl-dev \
        curl \
        libxml2-dev \
        libzip-dev \
        tzdata \
    && docker-php-ext-install -j$(nproc) \
        pdo \
        pdo_mysql \
        json \
        curl \
        bcmath \
        sockets

RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* \
    && curl -SLsk https://getcomposer.org/installer | php -- --install-dir=/bin --filename=composer --quiet --version=2.0.8

COPY php.ini /usr/local/etc/php

RUN mkdir "/app"

WORKDIR /app

# DEV section
RUN apk add --update --no-cache \
    autoconf\
    g++\
    make \
    bash \
    && pecl install -f xdebug-2.9.6 \
    && docker-php-ext-enable xdebug

ENV TZ=America/Chicago
