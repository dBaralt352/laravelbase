FROM php:8.3-alpine
LABEL maintainer="Daniel Baralt"
ARG USER=laravel

RUN apk update && apk add --no-cache \
	curl nodejs npm libzip-dev mysql-client

RUN docker-php-ext-configure pdo_mysql --with-pdo-mysql

RUN docker-php-ext-install pdo_mysql

RUN rm -rf /var/cache/apk/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN addgroup -g 1000 $USER && \
	adduser -D -u 1000 -G laravel $USER

RUN chown -R $USER:$USER /var/www

EXPOSE 8000

WORKDIR /var/www/html

COPY . .

RUN composer install && \
	npm i

ENTRYPOINT ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
