#############################################################################
# Dockerfile to build an image with Git, php-cli and composer
# Based on yesops/ubuntu:latest                                         
#############################################################################

## Set the base image to Ubuntu
FROM ubuntu:16.04

## File Author / Maintainer
MAINTAINER Alex Wijnholds <info@asclub.eu>

## Update locales
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8 

## Install basic things
RUN apt-get update && apt-get install -y --no-install-recommends \
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

## Add php5.6 repository
RUN add-apt-repository ppa:ondrej/php -y

## Add git core repository
RUN add-apt-repository ppa:git-core/ppa -y

## Installs PHP
RUN apt-get update && apt-get install -y --no-install-recommends \
	php5.6-readline \
	php5.6-cli \
	php5.6-mysql \
	php5.6-xcache \
	php5.6-json \
	php5.6-mcrypt \
	php5.6-dom \
	php5.6-mbstring \
	php5.6-zip \
	php5.6-gd \
	php5.6-bz2 \
	php5.6-curl \
	php5.6-intl \
	php5.6-redis \
	php5.6-xdebug
	
## Upgrades
RUN apt-get dist-upgrade -y

# Disable XDebug by default
RUN phpdismod xdebug

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
RUN wget https://phar.phpunit.de/phpunit.phar
RUN chmod +x phpunit.phar
RUN mv phpunit.phar /usr/local/bin/phpunit

## Install Git Subsplit
RUN wget https://raw.githubusercontent.com/dflydev/git-subsplit/master/git-subsplit.sh
RUN chmod +x git-subsplit.sh
RUN mv git-subsplit.sh "$(git --exec-path)"/git-subsplit
