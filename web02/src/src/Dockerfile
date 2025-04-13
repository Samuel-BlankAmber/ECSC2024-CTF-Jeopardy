FROM php:8.2.0-apache


RUN apt-get update && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
	apt-get install -y --no-install-recommends libbz2-dev zlib1g-dev libonig-dev libzip-dev git nodejs && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
    npm install --global yarn && \

	docker-php-ext-install bz2 mbstring mysqli zip && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \


    git clone https://github.com/phpmyadmin/phpmyadmin.git --depth 1 . && \
    composer config version "5.2.2" && \
    composer update --no-dev && \
    yarn install --production

COPY ./config.inc.php /var/www/html/config.inc.php

COPY ./bot.php /var/www/html/public/bot.php
COPY ./custom-functions.php /var/www/html/public/custom-functions.php
COPY ./create-user.php /var/www/html/public/create-user.php
COPY ./Hashcash.php /var/www/html/public/Hashcash.php
COPY ./pow.php /var/www/html/public/pow.php


ENTRYPOINT ["apache2-foreground"]
