FROM php:7.1-apache

#update and install dependencies
RUN apt-get update && apt-get install -y \
  git \
  curl \
  unzip \
  imagemagick \
  libicu-dev

#Install mediawiki
ARG MEDIAWIKI_VERSION_MAJOR=1.29
ARG MEDIAWIKI_VERSION=1.29.0

RUN curl -s -o mediawiki.tar.gz "https://releases.wikimedia.org/mediawiki/${MEDIAWIKI_VERSION_MAJOR}/mediawiki-${MEDIAWIKI_VERSION}.tar.gz" \
  && tar -xz --strip-components=1 -f mediawiki.tar.gz \
  && rm mediawiki.tar.gz

#setup composer and install extensions
RUN mv composer.local.json-sample composer.local.json \
  && sed -i '5s#.*#"extensions/*/composer.json"#' composer.local.json \
  && curl -s -o composer.phar https://getcomposer.org/composer.phar \
  && chmod 755 composer.phar \
  && mv composer.phar /usr/local/bin/composer \
  && composer update

#set up directory structure
RUN mkdir -p /var/www/data \
  && chown -R www-data:www-data /var/www/data 

RUN ln -s /var/www/data/LocalSettings.php /var/www/html/LocalSettings.php \
  && rm -rf /var/www/html/images \
  && ln -s /var/www/data/images /var/www/html/images


#install mediawiki requirements
RUN docker-php-ext-install mysqli opcache intl \
  && pecl channel-update pecl.php.net \
  && pecl install apcu \
  && docker-php-ext-enable apcu
