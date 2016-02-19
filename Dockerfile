#############################################################################
# Dockerfile to build an image with Git, php-cli and composer
# Based on yesops/ubuntu:latest                                         
#############################################################################

## Set the base image to Ubuntu
FROM ubuntu:14.04

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
	mcrypt

## Add php5.6 repository
RUN add-apt-repository ppa:ondrej/php5-5.6 -y

## Add git core repository
RUN add-apt-repository ppa:git-core/ppa -y

## Installs PHP
RUN apt-get update && apt-get install -y --no-install-recommends \
	php5-readline \
    php5-cli \
    php5-mysql \
    php5-xcache \
    php5-json \
    php5-mcrypt \
    php5-gd \
    php5-curl \
    php5-intl \
    php5-redis \
    php5-xdebug
	
## Upgrades
RUN apt-get dist-upgrade -y

## Install composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

## Install PHPUnit
RUN wget https://phar.phpunit.de/phpunit.phar
RUN chmod +x phpunit.phar
RUN mv phpunit.phar /usr/local/bin/phpunit