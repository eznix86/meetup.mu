FROM registry.suse.com/bci/php:8 AS installer

RUN zypper -n in php8-intl php8-tokenizer php8-fileinfo php8-dom php8-xmlreader php8-xmlwriter php8-pdo php8-sqlite php8-mysql
RUN zypper -n in nodejs npm


FROM installer

WORKDIR /app
COPY . .

RUN composer install
RUN npm install
RUN npm run build

COPY .env.prod .env

RUN php artisan key:generate
RUN php artisan storage:link

EXPOSE 8000
ENV URL=0.0.0.0

CMD ["php", "artisan", "migrate:fresh", "--seed"]
ENTRYPOINT [ "sh", "-c", "php artisan serve --host=$URL --port=8000" ]
