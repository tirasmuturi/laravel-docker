# NGINX x ALPINE.
FROM nginx:mainline-alpine

# MAINTAINER OF THE PACKAGE.
LABEL maintainer="Tiras Muturi <tirasmuturi@gmail.com>"

# INSTALL SOME SYSTEM PACKAGES.
RUN apk --update --no-cache add ca-certificates \
    bash \
    supervisor \
    curl \
    wget \
    git \
    nodejs \
    bzip2 \
    nodejs-npm

RUN rm -rf /var/cache/apk/* && \
    npm install -g bower grunt-cli && \
    echo '{ "allow_root": true }' > /root/.bowerrc

# ensure www-data user exists
RUN set -x ; \
  addgroup -g 82 -S www-data ; \
adduser -u 82 -D -S -G www-data www-data

#install envconsul
RUN curl -L "https://releases.hashicorp.com/envconsul/0.7.3/envconsul_0.7.3_linux_amd64.tgz" | tar zxf - -C /usr/bin/ && \
    chmod +x /usr/bin/envconsul


# trust this project public key to trust the packages.
#ADD https://php.codecasts.rocks/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub
ADD https://dl.bintray.com/php-alpine/key/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub

# IMAGE ARGUMENTS WITH DEFAULTS.
ARG PHP_VERSION=7.3
ARG ALPINE_VERSION=3.9
ARG COMPOSER_HASH=544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061
ARG NGINX_HTTP_PORT=80
ARG NGINX_HTTPS_PORT=443

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /tmp
ENV COMPOSER_VERSION 1.7.2

# CONFIGURE ALPINE REPOSITORIES AND PHP BUILD DIR.
RUN echo "http://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VERSION}/main" > /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VERSION}/community" >> /etc/apk/repositories && \
#    echo "@php https://php.codecasts.rocks/v${ALPINE_VERSION}/php-${PHP_VERSION}" >> /etc/apk/repositories
    echo "@php https://dl.bintray.com/php-alpine/v${ALPINE_VERSION}/php-${PHP_VERSION}" >> /etc/apk/repositories

# INSTALL PHP AND SOME EXTENSIONS. SEE: https://github.com/codecasts/php-alpine
RUN apk add --no-cache --update php-fpm@php \
    php@php \
    php-openssl@php \
    php-pdo@php \
#   php-pdo_mysql@php \
    php-pdo_pgsql@php \
    php-mbstring@php \
    php-phar@php \
    php-session@php \
    php-dom@php \
    php-ctype@php \
    php-zlib@php \
    php-gd@php \
    php-iconv@php \
    php-json@php \
    php-zip@php \
    php-xmlreader@php \
    php-xml@php && \
    ln -s /usr/bin/php7 /usr/bin/php

# CONFIGURE WEB SERVER.
RUN mkdir -p /var/www && \
    mkdir -p /run/php && \
    mkdir -p /run/nginx && \
    mkdir -p /var/log/supervisor && \
    mkdir -p /etc/nginx/sites-enabled && \
    mkdir -p /etc/nginx/sites-available && \
    rm /etc/nginx/nginx.conf && \
    rm /etc/php7/php-fpm.d/www.conf && \
    rm /etc/php7/php.ini

# install Composer
RUN php -v
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer --ansi --version --no-interaction

# ADD START SCRIPT, SUPERVISOR CONFIG, NGINX CONFIG AND RUN SCRIPTS.
ADD start.sh /start.sh
ADD setup/supervisor/supervisord.conf /etc/supervisord.conf
ADD setup/nginx/nginx.conf /etc/nginx/nginx.conf
ADD setup/nginx/site.conf /etc/nginx/sites-available/default.conf
ADD setup/php/php.ini /etc/php7/php.ini
ADD setup/php-fpm/www.conf /etc/php7/php-fpm.d/www.conf
RUN chmod 755 /start.sh

# EXPOSE PORTS!
EXPOSE ${NGINX_HTTPS_PORT} ${NGINX_HTTP_PORT}
