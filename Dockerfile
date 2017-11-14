#############################################################################
# Dockerfile to build an image with Git, php-cli and composer
# Based on yesops/ubuntu:latest                                         
#############################################################################

## Set the base image to Ubuntu
FROM ubuntu:16.04

## File Author / Maintainer
MAINTAINER Alex Wijnholds <info@asclub.eu>

# Set the locale
RUN apt-get clean && apt-get update
RUN apt-get install locales

## Update locales
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8 

## Install basic things
RUN apt-get install -y --no-install-recommends \
	software-properties-common \
	python-software-properties \
	openssh-client \
	curl \
	ca-certificates \
	wget \
	git \
	mcrypt \
	libxrender1 \
	libxtst6

## Add php 7.1 repository
RUN add-apt-repository ppa:ondrej/php -y

## Add git core repository
RUN add-apt-repository ppa:git-core/ppa -y

## Installs PHP
RUN apt-get update && apt-get install -y --no-install-recommends \
	php7.1-readline \
	php7.1-cli \
	php7.1-mysql \
	php7.1-sqlite3 \
	php7.1-json \
	php7.1-mcrypt \
	php7.1-dom \
	php7.1-mbstring \
	php7.1-zip \
	php7.1-gd \
	php7.1-bcmath \
	php7.1-bz2 \
	php7.1-curl \
	php7.1-intl \
	php7.1-redis \
	php7.1-xdebug

	
## Laravel Dusk support (Chrome)
RUN apt-get -y install libxpm4 libxrender1 libgtk2.0-0 libnss3 libgconf-2-4
RUN apt-get -y install chromium-browser

## XVFB for headless applications
RUN apt-get -y install xvfb gtk2-engines-pixbuf

## Fonts for the browser
RUN apt-get -y install xfonts-cyrillic xfonts-100dpi xfonts-75dpi xfonts-base xfonts-scalable

## Support for screenshot capturing
RUN apt-get -y install imagemagick x11-apps
	
## Upgrades
RUN apt-get dist-upgrade -y

## Add SSL support
RUN apt-get -y install libssl-dev=1.0.2g-1ubuntu4.8 openssl=1.0.2g-1ubuntu4.8 --allow-downgrades

# Disable XDebug on the CLI
RUN phpdismod -s cli xdebug

## Install composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

## Install composer plugins
RUN /usr/local/bin/composer global require "hirak/prestissimo:^0.3"

## Install codesniffer
RUN wget https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar
RUN chmod +x phpcs.phar
RUN mv phpcs.phar /usr/local/bin/phpcs

## Install mess detector
RUN wget http://static.phpmd.org/php/latest/phpmd.phar
RUN chmod +x phpmd.phar
RUN mv phpmd.phar /usr/local/bin/phpmd

## Install PHPUnit
RUN wget https://phar.phpunit.de/phpunit-5.7.phar
RUN chmod +x phpunit-5.7.phar
RUN mv phpunit-5.7.phar /usr/local/bin/phpunit

## Install Git Subsplit
RUN wget https://raw.githubusercontent.com/dflydev/git-subsplit/master/git-subsplit.sh
RUN chmod +x git-subsplit.sh
RUN mv git-subsplit.sh "$(git --exec-path)"/git-subsplit
